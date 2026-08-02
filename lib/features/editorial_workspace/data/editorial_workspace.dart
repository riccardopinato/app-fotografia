import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import '../../editorial/domain/editorial_validation.dart';
import '../domain/editorial_workspace_models.dart';

class EditorialWorkspace {
  EditorialWorkspace._(this._database);

  static const schemaVersion = 1;
  static const supportedLicenses = EditorialValidator.licenses;
  static const _reviewKinds = {
    'technicalAccuracy',
    'originality',
    'rights',
    'terminology',
  };

  final Database _database;

  static EditorialWorkspace open(File file) {
    file.parent.createSync(recursive: true);
    final database = sqlite3.open(file.path);
    final workspace = EditorialWorkspace._(database);
    workspace._initialize();
    return workspace;
  }

  void close() => _database.dispose();

  void _initialize() {
    _database.execute('PRAGMA foreign_keys = ON');
    _database.execute('PRAGMA journal_mode = WAL');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS workspace_meta (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS sources (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        publisher TEXT,
        issue TEXT,
        publication_date TEXT,
        original_locale TEXT NOT NULL,
        source_type TEXT NOT NULL,
        license_type TEXT NOT NULL,
        license_url TEXT,
        rights_status TEXT NOT NULL,
        verification_status TEXT NOT NULL,
        attribution_required INTEGER NOT NULL,
        attribution_text TEXT,
        rights_evidence TEXT,
        restrictions TEXT,
        tdm_reserved INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS documents (
        id TEXT PRIMARY KEY,
        source_id TEXT NOT NULL REFERENCES sources(id) ON DELETE RESTRICT,
        title TEXT NOT NULL,
        original_file_path TEXT,
        extracted_text_path TEXT NOT NULL,
        extraction_method TEXT NOT NULL,
        page_start INTEGER,
        page_end INTEGER,
        checksum TEXT NOT NULL UNIQUE,
        raw_text TEXT NOT NULL,
        imported_at TEXT NOT NULL
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS fragments (
        id TEXT PRIMARY KEY,
        document_id TEXT NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
        ordinal INTEGER NOT NULL,
        body TEXT NOT NULL,
        normalized_hash TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'imported',
        created_at TEXT NOT NULL,
        UNIQUE(document_id, ordinal)
      )
    ''');
    _database.execute(
      'CREATE INDEX IF NOT EXISTS fragments_hash_idx '
      'ON fragments(normalized_hash)',
    );
    _database.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS fragment_search USING fts5(
        fragment_id UNINDEXED,
        body
      )
    ''');
    _database.execute('''
      INSERT INTO fragment_search(fragment_id, body)
      SELECT fragments.id, fragments.body
      FROM fragments
      WHERE NOT EXISTS(
        SELECT 1 FROM fragment_search
        WHERE fragment_search.fragment_id = fragments.id
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS drafts (
        id TEXT PRIMARY KEY,
        version INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        canonical_locale TEXT NOT NULL,
        premium INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS draft_sources (
        draft_id TEXT NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
        source_id TEXT NOT NULL REFERENCES sources(id) ON DELETE RESTRICT,
        PRIMARY KEY(draft_id, source_id)
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS draft_fragments (
        draft_id TEXT NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
        fragment_id TEXT NOT NULL REFERENCES fragments(id) ON DELETE RESTRICT,
        PRIMARY KEY(draft_id, fragment_id)
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS draft_tags (
        draft_id TEXT NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
        tag_code TEXT NOT NULL,
        PRIMARY KEY(draft_id, tag_code)
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS draft_translations (
        draft_id TEXT NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
        locale TEXT NOT NULL,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        body TEXT NOT NULL,
        method TEXT NOT NULL,
        search_terms_json TEXT NOT NULL,
        status TEXT NOT NULL,
        source_version INTEGER NOT NULL,
        reviewed_at TEXT,
        PRIMARY KEY(draft_id, locale)
      )
    ''');
    _database.execute('''
      CREATE TABLE IF NOT EXISTS review_tasks (
        id TEXT PRIMARY KEY,
        draft_id TEXT NOT NULL REFERENCES drafts(id) ON DELETE CASCADE,
        kind TEXT NOT NULL,
        locale TEXT,
        status TEXT NOT NULL,
        reviewer TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        decided_at TEXT
      )
    ''');
    _database.execute(
      'CREATE INDEX IF NOT EXISTS review_queue_idx '
      'ON review_tasks(status, created_at)',
    );
    _database.execute('''
      CREATE TABLE IF NOT EXISTS exports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locale TEXT NOT NULL,
        package_version INTEGER NOT NULL,
        file_path TEXT NOT NULL,
        checksum TEXT NOT NULL,
        content_count INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(locale, package_version)
      )
    ''');

    final current = _database.select(
      "SELECT value FROM workspace_meta WHERE key = 'schema_version'",
    );
    if (current.isEmpty) {
      _database.execute(
        'INSERT INTO workspace_meta(key, value) VALUES (?, ?)',
        ['schema_version', '$schemaVersion'],
      );
    } else if (current.first['value'] != '$schemaVersion') {
      throw StateError(
        'Unsupported editorial workspace schema '
        '${current.first['value']}; expected $schemaVersion.',
      );
    }
  }

  WorkspaceIngestResult ingest(WorkspaceIngestManifest manifest) {
    final checksum = _checksum(utf8.encode(manifest.extractedText));
    final duplicateDocument = _database.select(
      'SELECT id FROM documents WHERE checksum = ?',
      [checksum],
    );
    if (duplicateDocument.isNotEmpty) {
      return const WorkspaceIngestResult(
        documentInserted: false,
        fragmentsInserted: 0,
        duplicatesDetected: 0,
      );
    }
    final fragments = _splitFragments(manifest.extractedText);
    final now = _now();
    var duplicateCount = 0;

    return _transaction(() {
      final source = manifest.source;
      _database.execute(
        '''
        INSERT INTO sources(
          id, title, author, publisher, issue, publication_date,
          original_locale, source_type, license_type, license_url,
          rights_status, verification_status, attribution_required,
          attribution_text, rights_evidence, restrictions, tdm_reserved,
          created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          title = excluded.title,
          author = excluded.author,
          publisher = excluded.publisher,
          issue = excluded.issue,
          publication_date = excluded.publication_date,
          original_locale = excluded.original_locale,
          source_type = excluded.source_type,
          license_type = excluded.license_type,
          license_url = excluded.license_url,
          rights_status = excluded.rights_status,
          verification_status = excluded.verification_status,
          attribution_required = excluded.attribution_required,
          attribution_text = excluded.attribution_text,
          rights_evidence = excluded.rights_evidence,
          restrictions = excluded.restrictions,
          tdm_reserved = excluded.tdm_reserved,
          updated_at = excluded.updated_at
        ''',
        [
          source.id,
          source.title,
          source.author,
          source.publisher,
          source.issue,
          source.publicationDate,
          source.originalLocale,
          source.sourceType,
          source.licenseType,
          source.licenseUrl,
          source.rightsStatus,
          source.verificationStatus,
          source.attributionRequired ? 1 : 0,
          source.attributionText,
          source.rightsEvidence,
          source.restrictions,
          source.tdmReserved ? 1 : 0,
          now,
          now,
        ],
      );

      final document = manifest.document;
      final existingId = _database.select(
        'SELECT checksum FROM documents WHERE id = ?',
        [document.id],
      );
      if (existingId.isNotEmpty) {
        throw StateError(
          'Document ID ${document.id} already exists with different bytes.',
        );
      }
      _database.execute(
        '''
        INSERT INTO documents(
          id, source_id, title, original_file_path, extracted_text_path,
          extraction_method, page_start, page_end, checksum, raw_text,
          imported_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          document.id,
          source.id,
          document.title,
          document.originalFilePath,
          document.extractedTextPath,
          document.extractionMethod,
          document.pageStart,
          document.pageEnd,
          checksum,
          manifest.extractedText,
          now,
        ],
      );

      for (var index = 0; index < fragments.length; index++) {
        final body = fragments[index];
        final normalizedHash = _checksum(
          utf8.encode(_normalizeForDeduplication(body)),
        );
        final duplicate = _database.select(
          'SELECT 1 FROM fragments WHERE normalized_hash = ? LIMIT 1',
          [normalizedHash],
        );
        if (duplicate.isNotEmpty) duplicateCount++;
        _database.execute(
          '''
          INSERT INTO fragments(
            id, document_id, ordinal, body, normalized_hash, status, created_at
          ) VALUES (?, ?, ?, ?, ?, 'imported', ?)
          ''',
          [
            '${document.id}#${(index + 1).toString().padLeft(4, '0')}',
            document.id,
            index + 1,
            body,
            normalizedHash,
            now,
          ],
        );
        _database.execute(
          'INSERT INTO fragment_search(fragment_id, body) VALUES (?, ?)',
          ['${document.id}#${(index + 1).toString().padLeft(4, '0')}', body],
        );
      }
      return WorkspaceIngestResult(
        documentInserted: true,
        fragmentsInserted: fragments.length,
        duplicatesDetected: duplicateCount,
      );
    });
  }

  WorkspaceDraftResult saveDraft(WorkspaceDraftInput input) {
    _validateDraft(input);
    final existing = _database.select(
      'SELECT version FROM drafts WHERE id = ?',
      [input.id],
    );
    if (existing.isNotEmpty) {
      final currentVersion = existing.first['version']! as int;
      if (input.version < currentVersion) {
        throw StateError(
          'Draft downgrade blocked: ${input.id} is v$currentVersion.',
        );
      }
      if (input.version == currentVersion) {
        return WorkspaceDraftResult(
          inserted: false,
          version: currentVersion,
          reviewTasks: _taskCount(input.id),
        );
      }
    }

    final now = _now();
    return _transaction(() {
      _assertIdsExist('sources', input.sourceIds);
      _assertIdsExist('fragments', input.fragmentIds);
      final inserted = existing.isEmpty;
      if (inserted) {
        _database.execute(
          '''
          INSERT INTO drafts(
            id, version, type, category, difficulty, canonical_locale,
            premium, status, created_at, updated_at
          ) VALUES (?, ?, ?, ?, ?, ?, ?, 'needsReview', ?, ?)
          ''',
          [
            input.id,
            input.version,
            input.type,
            input.category,
            input.difficulty,
            input.canonicalLocale,
            input.premium ? 1 : 0,
            now,
            now,
          ],
        );
      } else {
        _database.execute(
          '''
          UPDATE drafts SET
            version = ?, type = ?, category = ?, difficulty = ?,
            canonical_locale = ?, premium = ?, status = 'needsReview',
            updated_at = ?
          WHERE id = ?
          ''',
          [
            input.version,
            input.type,
            input.category,
            input.difficulty,
            input.canonicalLocale,
            input.premium ? 1 : 0,
            now,
            input.id,
          ],
        );
        for (final table in [
          'draft_sources',
          'draft_fragments',
          'draft_tags',
          'draft_translations',
          'review_tasks',
        ]) {
          _database.execute('DELETE FROM $table WHERE draft_id = ?', [
            input.id,
          ]);
        }
      }

      for (final sourceId in input.sourceIds) {
        _database.execute(
          'INSERT INTO draft_sources(draft_id, source_id) VALUES (?, ?)',
          [input.id, sourceId],
        );
      }
      for (final fragmentId in input.fragmentIds) {
        _database.execute(
          'INSERT INTO draft_fragments(draft_id, fragment_id) VALUES (?, ?)',
          [input.id, fragmentId],
        );
      }
      for (final tag in input.tags) {
        _database.execute(
          'INSERT INTO draft_tags(draft_id, tag_code) VALUES (?, ?)',
          [input.id, tag],
        );
      }
      for (final translation in input.translations) {
        _database.execute(
          '''
          INSERT INTO draft_translations(
            draft_id, locale, title, summary, body, method,
            search_terms_json, status, source_version
          ) VALUES (?, ?, ?, ?, ?, ?, ?, 'needsReview', ?)
          ''',
          [
            input.id,
            translation.locale,
            translation.title,
            translation.summary,
            translation.body,
            translation.method,
            jsonEncode(translation.searchTerms),
            input.version,
          ],
        );
      }

      for (final kind in _reviewKinds) {
        _insertReviewTask(
          draftId: input.id,
          version: input.version,
          kind: kind,
          now: now,
        );
      }
      for (final translation in input.translations) {
        _insertReviewTask(
          draftId: input.id,
          version: input.version,
          kind: 'languageReview',
          locale: translation.locale,
          now: now,
        );
      }
      return WorkspaceDraftResult(
        inserted: inserted,
        version: input.version,
        reviewTasks: _taskCount(input.id),
      );
    });
  }

  List<WorkspaceReviewTask> reviewQueue({String status = 'pending'}) {
    final rows = _database.select(
      '''
      SELECT id, draft_id, kind, locale, status, reviewer, note,
             created_at, decided_at
      FROM review_tasks
      WHERE status = ?
      ORDER BY created_at, draft_id, kind, locale
      ''',
      [status],
    );
    return [
      for (final row in rows)
        WorkspaceReviewTask(
          id: row['id']! as String,
          draftId: row['draft_id']! as String,
          kind: row['kind']! as String,
          locale: row['locale'] as String?,
          status: row['status']! as String,
          reviewer: row['reviewer'] as String?,
          note: row['note'] as String?,
          createdAt: row['created_at']! as String,
          decidedAt: row['decided_at'] as String?,
        ),
    ];
  }

  List<WorkspaceFragmentHit> searchFragments(String query, {int limit = 20}) {
    if (limit < 1 || limit > 100) {
      throw StateError('Search limit must be between 1 and 100.');
    }
    final terms = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((value) => value.isNotEmpty)
        .map((value) => '"${value.replaceAll('"', '""')}"')
        .toList(growable: false);
    if (terms.isEmpty) return const [];
    final rows = _database.select(
      '''
      SELECT f.id, f.document_id, d.source_id, d.title,
             snippet(fragment_search, 1, '[', ']', '…', 24) AS excerpt
      FROM fragment_search
      JOIN fragments f ON f.id = fragment_search.fragment_id
      JOIN documents d ON d.id = f.document_id
      WHERE fragment_search MATCH ?
      ORDER BY bm25(fragment_search), f.id
      LIMIT ?
      ''',
      [terms.join(' AND '), limit],
    );
    return [
      for (final row in rows)
        WorkspaceFragmentHit(
          id: row['id']! as String,
          documentId: row['document_id']! as String,
          sourceId: row['source_id']! as String,
          documentTitle: row['title']! as String,
          excerpt: row['excerpt']! as String,
        ),
    ];
  }

  void review(WorkspaceReviewDecision decision) {
    final task = _database.select(
      'SELECT draft_id, kind, locale FROM review_tasks WHERE id = ?',
      [decision.taskId],
    );
    if (task.isEmpty) {
      throw StateError('Unknown review task ${decision.taskId}.');
    }
    final now = _now();
    _transaction(() {
      _database.execute(
        '''
        UPDATE review_tasks
        SET status = ?, reviewer = ?, note = ?, decided_at = ?
        WHERE id = ?
        ''',
        [
          decision.decision,
          decision.reviewer,
          decision.note,
          now,
          decision.taskId,
        ],
      );
      final row = task.first;
      final draftId = row['draft_id']! as String;
      final locale = row['locale'] as String?;
      if (row['kind'] == 'languageReview' && locale != null) {
        _database.execute(
          '''
          UPDATE draft_translations
          SET status = ?, reviewed_at = ?
          WHERE draft_id = ? AND locale = ?
          ''',
          [
            decision.decision == 'approved' ? 'approved' : 'needsReview',
            decision.decision == 'approved' ? now : null,
            draftId,
            locale,
          ],
        );
      }
      final remaining =
          _database
                  .select(
                    '''
        SELECT COUNT(*) AS count
        FROM review_tasks
        WHERE draft_id = ? AND status != 'approved'
        ''',
                    [draftId],
                  )
                  .first['count']!
              as int;
      _database.execute(
        'UPDATE drafts SET status = ?, updated_at = ? WHERE id = ?',
        [remaining == 0 ? 'approved' : 'needsReview', now, draftId],
      );
    });
  }

  WorkspaceExportResult exportLocale({
    required String locale,
    required File output,
  }) {
    if (!EditorialValidator.supportedLocales.contains(locale)) {
      throw StateError('Unsupported export locale $locale.');
    }
    final drafts = _database.select('''
      SELECT id, version, type, category, difficulty, canonical_locale,
             premium, updated_at
      FROM drafts
      WHERE status = 'approved'
      ORDER BY id
      ''');
    final contents = <Map<String, Object?>>[];
    final sourceIds = <String>{};
    final tagCodes = <String>{};
    final locales = <String>{'en', locale};

    for (final draft in drafts) {
      final draftId = draft['id']! as String;
      final canonicalLocale = draft['canonical_locale']! as String;
      locales.add(canonicalLocale);
      final linkedSources = _strings(
        'SELECT source_id AS value FROM draft_sources WHERE draft_id = ?',
        draftId,
      );
      if (!_sourcesPublishable(linkedSources)) continue;
      final requiredLocales = {'en', locale, canonicalLocale};
      final translations = <Map<String, Object?>>[];
      var complete = true;
      for (final requiredLocale in requiredLocales) {
        final rows = _database.select(
          '''
          SELECT title, summary, body, method, search_terms_json,
                 source_version, reviewed_at
          FROM draft_translations
          WHERE draft_id = ? AND locale = ? AND status = 'approved'
          ''',
          [draftId, requiredLocale],
        );
        if (rows.isEmpty) {
          complete = false;
          break;
        }
        final translation = rows.first;
        translations.add({
          'locale': requiredLocale,
          'title': translation['title'],
          'summary': translation['summary'],
          'body': translation['body'],
          'status': 'published',
          'method': translation['method'],
          'sourceVersion': translation['source_version'],
          'reviewedAt': translation['reviewed_at'],
          'searchTerms': jsonDecode(
            translation['search_terms_json']! as String,
          ),
        });
      }
      if (!complete) continue;
      final tags = _strings(
        'SELECT tag_code AS value FROM draft_tags WHERE draft_id = ?',
        draftId,
      );
      tagCodes.addAll(tags);
      sourceIds.addAll(linkedSources);
      contents.add({
        'id': draftId,
        'type': draft['type'],
        'editorialStatus': 'published',
        'canonicalLocale': canonicalLocale,
        'version': draft['version'],
        'updatedAt': draft['updated_at'],
        'category': draft['category'],
        'difficulty': draft['difficulty'],
        'premium': (draft['premium']! as int) == 1,
        'tags': [for (final tag in tags) 'tag-$tag'],
        'sourceIds': linkedSources,
        'translations': translations,
      });
    }
    if (contents.isEmpty) {
      throw StateError(
        'No fully approved, rights-cleared content for locale $locale.',
      );
    }

    final packageVersion =
        (_database
                .select(
                  '''
              SELECT COALESCE(MAX(package_version), 0) + 1 AS next
              FROM exports WHERE locale = ?
              ''',
                  [locale],
                )
                .first['next']!
            as int);
    final generatedAt = _now();
    final root = <String, Object?>{
      'formatVersion': '1.0',
      'packageId': 'framelab-workspace-$locale',
      'packageVersion': packageVersion,
      'generatedAt': generatedAt,
      'baseLocale': 'en',
      'locales': locales.toList()..sort(),
      'sources': [for (final id in sourceIds.toList()..sort()) _sourceJson(id)],
      'tags': [
        for (final code in tagCodes.toList()..sort())
          {
            'id': 'tag-$code',
            'code': code,
            'labels': {for (final value in locales) value: code},
          },
      ],
      'assets': <Object?>[],
      'contents': contents,
    };
    const encoder = JsonEncoder.withIndent('  ');
    output.parent.createSync(recursive: true);
    output.writeAsStringSync('${encoder.convert(root)}\n');
    final checksum = _checksum(output.readAsBytesSync());
    _database.execute(
      '''
      INSERT INTO exports(
        locale, package_version, file_path, checksum, content_count, created_at
      ) VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [
        locale,
        packageVersion,
        output.absolute.path,
        checksum,
        contents.length,
        generatedAt,
      ],
    );
    return WorkspaceExportResult(
      packageVersion: packageVersion,
      contents: contents.length,
      checksum: checksum,
      file: output,
    );
  }

  Map<String, int> counts() {
    int count(String table) =>
        _database.select('SELECT COUNT(*) AS count FROM $table').first['count']!
            as int;
    return {
      'sources': count('sources'),
      'documents': count('documents'),
      'fragments': count('fragments'),
      'drafts': count('drafts'),
      'pendingReviews':
          _database
                  .select(
                    "SELECT COUNT(*) AS count FROM review_tasks WHERE status = 'pending'",
                  )
                  .first['count']!
              as int,
      'approvedDrafts':
          _database
                  .select(
                    "SELECT COUNT(*) AS count FROM drafts WHERE status = 'approved'",
                  )
                  .first['count']!
              as int,
      'exports': count('exports'),
    };
  }

  void _validateDraft(WorkspaceDraftInput input) {
    if (!EditorialValidator.contentTypes.contains(input.type)) {
      throw StateError('Unsupported content type ${input.type}.');
    }
    if (!{'beginner', 'intermediate', 'advanced'}.contains(input.difficulty)) {
      throw StateError('Unsupported difficulty ${input.difficulty}.');
    }
    for (final translation in input.translations) {
      if (!EditorialValidator.supportedLocales.contains(translation.locale)) {
        throw StateError('Unsupported locale ${translation.locale}.');
      }
      if (!{
        'original',
        'human',
        'machine',
        'machineReviewed',
      }.contains(translation.method)) {
        throw StateError('Unsupported method ${translation.method}.');
      }
    }
  }

  void _insertReviewTask({
    required String draftId,
    required int version,
    required String kind,
    required String now,
    String? locale,
  }) {
    final suffix = locale ?? 'all';
    _database.execute(
      '''
      INSERT INTO review_tasks(
        id, draft_id, kind, locale, status, created_at
      ) VALUES (?, ?, ?, ?, 'pending', ?)
      ''',
      ['$draftId:$kind:$suffix:v$version', draftId, kind, locale, now],
    );
  }

  int _taskCount(String draftId) =>
      _database.select(
            'SELECT COUNT(*) AS count FROM review_tasks WHERE draft_id = ?',
            [draftId],
          ).first['count']!
          as int;

  void _assertIdsExist(String table, List<String> ids) {
    for (final id in ids) {
      final rows = _database.select('SELECT 1 FROM $table WHERE id = ?', [id]);
      if (rows.isEmpty) throw StateError('Unknown $table ID $id.');
    }
  }

  List<String> _strings(String sql, String parameter) => [
    for (final row in _database.select(sql, [parameter]))
      row['value']! as String,
  ];

  bool _sourcesPublishable(List<String> ids) {
    for (final id in ids) {
      final source = _database
          .select(
            '''
        SELECT license_type, rights_status, verification_status,
               rights_evidence
        FROM sources WHERE id = ?
        ''',
            [id],
          )
          .first;
      final license = source['license_type']! as String;
      final evidence = source['rights_evidence'] as String?;
      if (!supportedLicenses.contains(license) ||
          source['rights_status'] != 'publishable' ||
          source['verification_status'] != 'verified' ||
          (license == 'Licensed-Agreement' &&
              (evidence == null || evidence.trim().isEmpty))) {
        return false;
      }
    }
    return ids.isNotEmpty;
  }

  Map<String, Object?> _sourceJson(String id) {
    final source = _database.select('SELECT * FROM sources WHERE id = ?', [
      id,
    ]).first;
    final publicationDate = source['publication_date'] as String?;
    final publicationYear =
        publicationDate == null || publicationDate.length < 4
        ? null
        : int.tryParse(publicationDate.substring(0, 4));
    return {
      'id': source['id'],
      'title': source['title'],
      'author': source['author'],
      'publisher': source['publisher'],
      'publicationYear': publicationYear,
      'originalLocale': source['original_locale'],
      'sourceType': source['source_type'],
      'verificationStatus': source['verification_status'],
      'editorialNote': source['issue'] == null
          ? 'Imported through the private FrameLab editorial workspace.'
          : 'Issue ${source['issue']}.',
      'licenseType': source['license_type'],
      'licenseUrl': source['license_url'],
      'attributionRequired': (source['attribution_required']! as int) == 1,
      'attributionText': source['attribution_text'],
      'rightsStatus': source['rights_status'],
      'rightsVerification': source['verification_status'],
      'restrictions': source['restrictions'],
    };
  }

  T _transaction<T>(T Function() action) {
    _database.execute('BEGIN IMMEDIATE');
    try {
      final result = action();
      _database.execute('COMMIT');
      return result;
    } on Object {
      _database.execute('ROLLBACK');
      rethrow;
    }
  }
}

List<String> _splitFragments(String source) {
  final normalized = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final paragraphs = normalized
      .split(RegExp(r'\n\s*\n'))
      .map((value) => value.replaceAll(RegExp(r'\s+'), ' ').trim())
      .where((value) => value.length >= 40);
  final result = <String>[];
  for (final paragraph in paragraphs) {
    if (paragraph.length <= 1200) {
      result.add(paragraph);
      continue;
    }
    var start = 0;
    while (start < paragraph.length) {
      var end = start + 1200;
      if (end > paragraph.length) {
        end = paragraph.length;
      }
      if (end < paragraph.length) {
        final boundary = paragraph.lastIndexOf(' ', end);
        if (boundary > start + 600) end = boundary;
      }
      result.add(paragraph.substring(start, end).trim());
      start = end;
    }
  }
  if (result.isEmpty) {
    throw const FormatException(
      'Extracted text has no usable paragraph of at least 40 characters.',
    );
  }
  return result;
}

String _normalizeForDeduplication(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^0-9A-Za-zÀ-ÖØ-öø-ÿ]+'), ' ')
    .trim();

String _checksum(List<int> bytes) {
  var hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final prime = BigInt.parse('100000001b3', radix: 16);
  final mask = BigInt.parse('ffffffffffffffff', radix: 16);
  for (final byte in bytes) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }
  return 'fnv1a64:${hash.toRadixString(16).padLeft(16, '0')}';
}

String _now() => DateTime.now().toUtc().toIso8601String();

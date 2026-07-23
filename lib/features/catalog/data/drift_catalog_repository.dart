import '../../../core/database/app_database.dart' as db;
import 'package:drift/drift.dart';
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import 'catalog_mapper.dart';

class DriftCatalogRepository implements CatalogRepository {
  DriftCatalogRepository(this._database);
  final db.AppDatabase _database;

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => _database.contentItems.select().watch().asyncMap(
    (_) => getPublished(locale: locale, filter: filter),
  );

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async =>
      (await getPage(locale: locale, filter: filter, limit: 10000)).items;

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async => (await getPublishedDetailById(id, locale: locale))?.content;

  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) async {
    assert(limit > 0 && offset >= 0);
    final candidates = LocaleCode.fallbackChain(
      locale,
    ).map((e) => e.value).toList();
    final vars = <Variable<Object>>[
      for (final value in candidates) Variable.withString(value),
    ];
    final placeholders = List.filled(candidates.length, '?').join(',');
    final where = <String>[
      "c.editorial_status = 'published'",
      "t.translation_status = 'published'",
      "t.title <> '' AND t.body <> ''",
      'EXISTS (SELECT 1 FROM content_item_sources cis JOIN content_sources s ON s.id=cis.source_id WHERE cis.content_id=c.id AND s.rights_status=\'publishable\' AND trim(s.license_type) <> \'\')',
    ];
    if (filter.type != null) {
      where.add('c.type = ?');
      vars.add(Variable.withString(filter.type!.name));
    }
    if (filter.category != null) {
      where.add('c.primary_category = ?');
      vars.add(Variable.withString(filter.category!));
    }
    if (filter.difficulty != null) {
      where.add('c.difficulty = ?');
      vars.add(Variable.withString(filter.difficulty!.name));
    }
    if (filter.premium != null) {
      where.add('c.premium = ?');
      vars.add(Variable.withBool(filter.premium!));
    }
    if (filter.tagCode != null) {
      where.add(
        'EXISTS (SELECT 1 FROM content_item_tags ct JOIN tags g ON g.id=ct.tag_id WHERE ct.content_id=c.id AND g.code=?)',
      );
      vars.add(Variable.withString(filter.tagCode!));
    }
    final hasQuery = query.trim().isNotEmpty;
    if (hasQuery) {
      where.add('content_search MATCH ?');
      vars.add(Variable.withString(_ftsQuery(query)));
    }
    vars
      ..add(Variable.withInt(limit + 1))
      ..add(Variable.withInt(offset));
    final sql =
        '''WITH resolved AS (SELECT ct.*, row_number() OVER (PARTITION BY ct.content_id ORDER BY CASE ct.locale ${List.generate(candidates.length, (i) => 'WHEN ? THEN $i').join(' ')} ELSE 99 END) rank FROM content_translations ct WHERE ct.locale IN ($placeholders)) SELECT c.id FROM content_items c JOIN resolved t ON t.content_id=c.id AND t.rank=1 ${hasQuery ? 'JOIN content_search ON content_search.content_id=c.id' : ''} WHERE ${where.join(' AND ')} ORDER BY ${hasQuery ? 'bm25(content_search), ' : ''}lower(t.title), c.id LIMIT ? OFFSET ?''';
    // Candidate values appear in the CASE before the IN predicate.
    final rows = await _database
        .customSelect(
          sql,
          variables: [...vars.sublist(0, candidates.length), ...vars],
        )
        .get();
    final ids = rows.map((r) => r.read<String>('id')).toList();
    final pageIds = ids.take(limit).toList();
    final items = await _load(pageIds, locale);
    return CatalogPage(items: items, hasMore: ids.length > limit);
  }

  String _ftsQuery(String query) => query
      .trim()
      .split(RegExp(r'\s+'))
      .map((word) => '"${word.replaceAll('"', '')}"*')
      .join(' AND ');

  Future<List<LocalizedContent>> _load(
    List<String> ids,
    LocaleCode locale,
  ) async {
    if (ids.isEmpty) return const [];
    final items = await (_database.select(
      _database.contentItems,
    )..where((t) => t.id.isIn(ids))).get();
    final translations =
        await (_database.select(_database.contentTranslations)..where(
              (t) =>
                  t.contentId.isIn(ids) &
                  t.translationStatus.equals('published'),
            ))
            .get();
    final byItem = {for (final i in items) i.id: contentItemFromRow(i)};
    final resolved = <String, ContentTranslation>{};
    for (final id in ids) {
      for (final candidate in LocaleCode.fallbackChain(locale)) {
        final row = translations
            .where((t) => t.contentId == id && t.locale == candidate.value)
            .firstOrNull;
        if (row != null) {
          resolved[id] = contentTranslationFromRow(row);
          break;
        }
      }
    }
    final tagRows = await _database
        .customSelect(
          'SELECT cit.content_id, g.id, g.code FROM content_item_tags cit JOIN tags g ON g.id=cit.tag_id WHERE cit.content_id IN (${List.filled(ids.length, '?').join(',')})',
          variables: [for (final id in ids) Variable.withString(id)],
        )
        .get();
    final tags = <String, List<Tag>>{};
    for (final r in tagRows) {
      (tags[r.read<String>('content_id')] ??= []).add(
        Tag(id: r.read<String>('id'), code: r.read<String>('code')),
      );
    }
    return [
      for (final id in ids)
        if (byItem[id] != null && resolved[id] != null)
          LocalizedContent(
            item: byItem[id]!,
            translation: resolved[id]!,
            tags: tags[id] ?? const [],
          ),
    ];
  }

  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) async {
    if (!await _isPublic(id, locale)) return null;
    final content = (await _load([id], locale)).firstOrNull;
    if (content == null) return null;
    final tagCandidates = LocaleCode.fallbackChain(
      locale,
    ).map((candidate) => candidate.value).toList();
    final tagPlaceholders = List.filled(tagCandidates.length, '?').join(',');
    final rows = await _database
        .customSelect(
          '''WITH resolved_tag_labels AS (
            SELECT tt.*, row_number() OVER (
              PARTITION BY tt.tag_id
              ORDER BY CASE tt.locale ${List.generate(tagCandidates.length, (i) => 'WHEN ? THEN $i').join(' ')} ELSE 99 END
            ) rank
            FROM tag_translations tt
            WHERE tt.locale IN ($tagPlaceholders)
          )
          SELECT g.id, g.code, rtl.label
          FROM content_item_tags ct
          JOIN tags g ON g.id = ct.tag_id
          LEFT JOIN resolved_tag_labels rtl
            ON rtl.tag_id = g.id AND rtl.rank = 1
          WHERE ct.content_id = ?
          ORDER BY lower(coalesce(rtl.label, g.code)), g.code''',
          variables: [
            for (final candidate in tagCandidates)
              Variable.withString(candidate),
            for (final candidate in tagCandidates)
              Variable.withString(candidate),
            Variable.withString(id),
          ],
        )
        .get();
    final sources = await _database
        .customSelect(
          'SELECT s.* FROM content_item_sources ct JOIN content_sources s ON s.id=ct.source_id WHERE ct.content_id=? AND s.rights_status=\'publishable\' AND trim(s.license_type) <> \'\'',
          variables: [Variable.withString(id)],
        )
        .get();
    return CatalogDetail(
      content: content,
      tags: [
        for (final r in rows)
          LocalizedTag(
            id: r.read<String>('id'),
            code: r.read<String>('code'),
            label: r.data['label'] as String?,
          ),
      ],
      sources: [
        for (final r in sources)
          contentSourceFromRow(
            db.ContentSource(
              id: r.read<String>('id'),
              title: r.read<String>('title'),
              author: r.data['author'] as String?,
              publisher: r.data['publisher'] as String?,
              publicationYear: r.data['publication_year'] as int?,
              sourceUri: r.data['source_uri'] as String?,
              originalLocale: r.read<String>('original_locale'),
              licenseType: r.read<String>('license_type'),
              licenseReference: r.data['license_reference'] as String?,
              attributionText: r.data['attribution_text'] as String?,
              rightsStatus: r.read<String>('rights_status'),
              createdAtUtcMs: r.read<int>('created_at_utc_ms'),
              updatedAtUtcMs: r.read<int>('updated_at_utc_ms'),
            ),
          ),
      ],
    );
  }

  Future<bool> _isPublic(String id, LocaleCode locale) async {
    final rows = await _database
        .customSelect(
          '''SELECT c.id FROM content_items c
          JOIN content_translations t ON t.content_id = c.id
          WHERE c.id = ?
            AND c.editorial_status = 'published'
            AND t.translation_status = 'published'
            AND t.title <> '' AND t.body <> ''
            AND t.locale IN (${List.filled(LocaleCode.fallbackChain(locale).length, '?').join(',')})
            AND EXISTS (
              SELECT 1 FROM content_item_sources cis
              JOIN content_sources s ON s.id = cis.source_id
              WHERE cis.content_id = c.id
                AND s.rights_status = 'publishable'
                AND trim(s.license_type) <> ''
            )
          LIMIT 1''',
          variables: [
            Variable.withString(id),
            for (final candidate in LocaleCode.fallbackChain(locale))
              Variable.withString(candidate.value),
          ],
        )
        .get();
    return rows.isNotEmpty;
  }
}

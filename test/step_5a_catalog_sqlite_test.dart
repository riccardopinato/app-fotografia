import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';

const _now = 1704067200000;

AppDatabase _db() => AppDatabase(NativeDatabase.memory());

AppDatabase _v2Db() => AppDatabase(
  NativeDatabase.memory(
    setup: (database) {
      database
        ..execute('''CREATE TABLE content_items (
          id TEXT NOT NULL PRIMARY KEY,
          type TEXT NOT NULL,
          primary_category TEXT NOT NULL,
          difficulty TEXT NOT NULL,
          premium INTEGER NOT NULL CHECK (premium IN (0, 1)),
          canonical_locale TEXT NOT NULL,
          editorial_status TEXT NOT NULL,
          version INTEGER NOT NULL,
          created_at_utc_ms INTEGER NOT NULL,
          updated_at_utc_ms INTEGER NOT NULL,
          published_at_utc_ms INTEGER
        )''')
        ..execute('''CREATE TABLE content_translations (
          id TEXT NOT NULL PRIMARY KEY,
          content_id TEXT NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
          locale TEXT NOT NULL CHECK (length(locale) > 0),
          title TEXT NOT NULL,
          summary TEXT NOT NULL,
          body TEXT NOT NULL,
          translation_status TEXT NOT NULL,
          translation_method TEXT NOT NULL,
          source_version INTEGER NOT NULL,
          reviewed_at_utc_ms INTEGER,
          created_at_utc_ms INTEGER NOT NULL,
          updated_at_utc_ms INTEGER NOT NULL,
          UNIQUE(content_id, locale)
        )''')
        ..execute('''CREATE TABLE content_sources (
          id TEXT NOT NULL PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT,
          publisher TEXT,
          publication_year INTEGER,
          source_uri TEXT,
          original_locale TEXT NOT NULL,
          license_type TEXT NOT NULL,
          license_reference TEXT,
          attribution_text TEXT,
          rights_status TEXT NOT NULL,
          created_at_utc_ms INTEGER NOT NULL,
          updated_at_utc_ms INTEGER NOT NULL
        )''')
        ..execute('''CREATE TABLE content_item_sources (
          content_id TEXT NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
          source_id TEXT NOT NULL REFERENCES content_sources(id) ON DELETE RESTRICT,
          PRIMARY KEY(content_id, source_id)
        )''')
        ..execute('''CREATE TABLE tags (
          id TEXT NOT NULL PRIMARY KEY,
          code TEXT NOT NULL UNIQUE
        )''')
        ..execute('''CREATE TABLE tag_translations (
          tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
          locale TEXT NOT NULL,
          label TEXT NOT NULL,
          PRIMARY KEY(tag_id, locale)
        )''')
        ..execute('''CREATE TABLE content_item_tags (
          content_id TEXT NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
          tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE RESTRICT,
          PRIMARY KEY(content_id, tag_id)
        )''')
        ..execute('''CREATE TABLE user_profiles (
          id TEXT NOT NULL PRIMARY KEY,
          skill_level TEXT NOT NULL,
          preferred_locale TEXT NOT NULL,
          language_mode TEXT NOT NULL DEFAULT 'device',
          selected_locale TEXT,
          preferred_topics TEXT NOT NULL DEFAULT '[]',
          camera_bodies TEXT NOT NULL DEFAULT '[]',
          lenses TEXT NOT NULL DEFAULT '[]',
          smartphones TEXT NOT NULL DEFAULT '[]',
          learning_goals TEXT NOT NULL DEFAULT '[]',
          theme_preference TEXT NOT NULL,
          created_at_utc_ms INTEGER NOT NULL,
          updated_at_utc_ms INTEGER NOT NULL
        )''')
        ..execute(
          "INSERT INTO content_items VALUES ('legacy', 'tip', 'light', 'beginner', 0, 'en', 'published', 1, $_now, $_now, $_now)",
        )
        ..execute(
          "INSERT INTO content_translations VALUES ('legacy-en', 'legacy', 'en', 'Golden hour legacy', 'Soft summary', 'Warm body', 'published', 'human', 1, NULL, $_now, $_now)",
        )
        ..execute(
          "INSERT INTO content_sources VALUES ('src', 'Manual', 'Author', NULL, NULL, NULL, 'en', 'CC-BY-4.0', NULL, 'Credit', 'publishable', $_now, $_now)",
        )
        ..execute("INSERT INTO content_item_sources VALUES ('legacy', 'src')")
        ..execute("INSERT INTO tags VALUES ('tag-light', 'golden-hour')")
        ..execute(
          "INSERT INTO tag_translations VALUES ('tag-light', 'en', 'Magic light')",
        )
        ..execute(
          "INSERT INTO content_item_tags VALUES ('legacy', 'tag-light')",
        )
        ..execute(
          "INSERT INTO user_profiles VALUES ('profile', 'beginner', 'en', 'manual', 'en', '[\"light\"]', '[]', '[]', '[]', '[]', 'system', $_now, $_now)",
        )
        ..execute('PRAGMA user_version = 2');
    },
  ),
);

ContentItemsCompanion _item(
  String id, {
  String titleKey = 'composition',
  ContentType type = ContentType.tip,
  Difficulty difficulty = Difficulty.beginner,
  bool premium = false,
  EditorialStatus status = EditorialStatus.published,
}) => ContentItemsCompanion.insert(
  id: id,
  type: type.name,
  primaryCategory: titleKey,
  difficulty: difficulty.name,
  premium: premium,
  canonicalLocale: 'en',
  editorialStatus: status.name,
  version: 1,
  createdAtUtcMs: _now,
  updatedAtUtcMs: _now,
  publishedAtUtcMs: const Value(_now),
);

ContentTranslationsCompanion _translation(
  String id,
  String contentId,
  String locale, {
  required String title,
  String summary = 'neutral summary',
  String body = 'neutral body',
  TranslationStatus status = TranslationStatus.published,
}) => ContentTranslationsCompanion.insert(
  id: id,
  contentId: contentId,
  locale: locale,
  title: title,
  summary: summary,
  body: body,
  translationStatus: status.name,
  translationMethod: TranslationMethod.human.name,
  sourceVersion: 1,
  createdAtUtcMs: _now,
  updatedAtUtcMs: _now,
);

Future<void> _source(
  AppDatabase db,
  String contentId, {
  String? sourceId,
  RightsStatus rights = RightsStatus.publishable,
  String license = 'CC-BY-4.0',
}) async {
  final id = sourceId ?? 'source-$contentId';
  await db
      .into(db.contentSources)
      .insert(
        ContentSourcesCompanion.insert(
          id: id,
          title: 'Source $id',
          author: const Value('Author'),
          originalLocale: 'en',
          licenseType: license,
          attributionText: const Value('Attribution'),
          rightsStatus: rights.name,
          createdAtUtcMs: _now,
          updatedAtUtcMs: _now,
        ),
      );
  await db
      .into(db.contentItemSources)
      .insert(
        ContentItemSourcesCompanion.insert(contentId: contentId, sourceId: id),
      );
}

Future<void> _tag(
  AppDatabase db,
  String contentId,
  String code, {
  String? id,
  String en = 'tag label',
  String? it,
}) async {
  final tagId = id ?? 'tag-$code';
  await db.into(db.tags).insert(TagsCompanion.insert(id: tagId, code: code));
  await db
      .into(db.tagTranslations)
      .insert(
        TagTranslationsCompanion.insert(tagId: tagId, locale: 'en', label: en),
      );
  if (it != null) {
    await db
        .into(db.tagTranslations)
        .insert(
          TagTranslationsCompanion.insert(
            tagId: tagId,
            locale: 'it',
            label: it,
          ),
        );
  }
  await db
      .into(db.contentItemTags)
      .insert(
        ContentItemTagsCompanion.insert(contentId: contentId, tagId: tagId),
      );
}

Future<void> _publicContent(
  AppDatabase db,
  String id, {
  required String title,
  String summary = 'summary',
  String body = 'body',
  String category = 'composition',
  ContentType type = ContentType.tip,
  Difficulty difficulty = Difficulty.beginner,
  bool premium = false,
  EditorialStatus status = EditorialStatus.published,
  RightsStatus rights = RightsStatus.publishable,
  String license = 'CC-BY-4.0',
}) async {
  await db
      .into(db.contentItems)
      .insert(
        _item(
          id,
          titleKey: category,
          type: type,
          difficulty: difficulty,
          premium: premium,
          status: status,
        ),
      );
  await db
      .into(db.contentTranslations)
      .insert(
        _translation(
          'tr-$id-en',
          id,
          'en',
          title: title,
          summary: summary,
          body: body,
        ),
      );
  await _source(db, id, rights: rights, license: license);
}

Future<List<String>> _ids(
  DriftCatalogRepository repo, {
  String query = '',
  CatalogFilter filter = const CatalogFilter(),
  int limit = 20,
  int offset = 0,
  LocaleCode locale = const LocaleCode('en'),
}) async => (await repo.getPage(
  locale: locale,
  query: query,
  filter: filter,
  limit: limit,
  offset: offset,
)).items.map((item) => item.item.id).toList();

void main() {
  group('Step 5A SQLite catalog foundation', () {
    test('creates schema v3 with an operational FTS5 table', () async {
      final db = _db();
      expect(db.schemaVersion, 3);
      final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(fk.data['foreign_keys'], 1);
      final tables = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='content_search'",
          )
          .get();
      expect(tables, hasLength(1));
      await _publicContent(db, 'fts', title: 'Clean schema title');
      expect(await _ids(DriftCatalogRepository(db), query: 'schema'), ['fts']);
      await db.close();
    });

    test(
      'migrates real v2 data, preserves rows, enables FK and backfills FTS',
      () async {
        final db = _v2Db();
        final repo = DriftCatalogRepository(db);
        expect((await db.select(db.userProfiles).get()).single.id, 'profile');
        expect((await db.select(db.contentItems).get()).single.id, 'legacy');
        expect(
          (await db.select(db.contentTranslations).get()).single.title,
          'Golden hour legacy',
        );
        expect(
          (await db.select(db.contentSources).get()).single.licenseType,
          'CC-BY-4.0',
        );
        expect((await db.select(db.tags).get()).single.code, 'golden-hour');
        expect(
          (await db.select(db.tagTranslations).get()).single.label,
          'Magic light',
        );
        expect(
          (await db.customSelect('PRAGMA foreign_keys').getSingle())
              .data['foreign_keys'],
          1,
        );
        expect(await _ids(repo, query: 'legacy'), ['legacy']);
        expect(await _ids(repo, query: 'Magic'), ['legacy']);
        await db.close();
      },
    );

    test(
      'searches title, summary, body, localized tags, case and diacritics',
      () async {
        final db = _db();
        final repo = DriftCatalogRepository(db);
        await _publicContent(db, 'title', title: 'Aperture ladder');
        await _publicContent(
          db,
          'summary',
          title: 'Neutral A',
          summary: 'Backlight silhouette recipe',
        );
        await _publicContent(
          db,
          'body',
          title: 'Neutral B',
          body: 'Use café shadows for depth',
        );
        await _publicContent(db, 'tagged', title: 'Neutral C');
        await _tag(
          db,
          'tagged',
          'street',
          en: 'Night reflections',
          it: 'Riflessi notturni',
        );
        expect(await _ids(repo, query: 'aperture'), ['title']);
        expect(await _ids(repo, query: 'silhouette'), ['summary']);
        expect(await _ids(repo, query: 'cafe'), ['body']);
        expect(
          await _ids(repo, query: 'RIFLESSI', locale: const LocaleCode('it')),
          ['tagged'],
        );
        expect(await _ids(repo, query: 'night'), ['tagged']);
        await db.close();
      },
    );

    test(
      'handles empty query, single and combined filters, and search plus filters',
      () async {
        final db = _db();
        final repo = DriftCatalogRepository(db);
        await _publicContent(
          db,
          'a',
          title: 'Portrait light',
          category: 'portrait',
          type: ContentType.guide,
          difficulty: Difficulty.advanced,
          premium: true,
        );
        await _tag(db, 'a', 'portrait', en: 'Portrait');
        await _publicContent(
          db,
          'b',
          title: 'Portrait basics',
          category: 'portrait',
        );
        expect(await _ids(repo), ['b', 'a']);
        expect(
          await _ids(
            repo,
            filter: const CatalogFilter(type: ContentType.guide),
          ),
          ['a'],
        );
        expect(
          await _ids(
            repo,
            filter: const CatalogFilter(
              category: 'portrait',
              difficulty: Difficulty.advanced,
              premium: true,
              tagCode: 'portrait',
            ),
          ),
          ['a'],
        );
        expect(
          await _ids(
            repo,
            query: 'portrait',
            filter: const CatalogFilter(premium: false),
          ),
          ['b'],
        );
        await db.close();
      },
    );

    test(
      'orders deterministically and paginates without duplicates, skips or false hasMore',
      () async {
        final db = _db();
        final repo = DriftCatalogRepository(db);
        for (final id in ['c', 'a', 'b', 'd', 'e']) {
          await _publicContent(
            db,
            id,
            title: 'Same rank $id',
            body: 'shared search term',
          );
        }
        final first = await repo.getPage(
          locale: const LocaleCode('en'),
          query: 'shared',
          limit: 2,
        );
        final second = await repo.getPage(
          locale: const LocaleCode('en'),
          query: 'shared',
          limit: 2,
          offset: 2,
        );
        final last = await repo.getPage(
          locale: const LocaleCode('en'),
          query: 'shared',
          limit: 2,
          offset: 4,
        );
        final all = [
          ...first.items,
          ...second.items,
          ...last.items,
        ].map((e) => e.item.id).toList();
        expect(all.toSet(), hasLength(5));
        expect(all, ['a', 'b', 'c', 'd', 'e']);
        expect(first.hasMore, isTrue);
        expect(second.hasMore, isTrue);
        expect(last.hasMore, isFalse);
        await db.close();
      },
    );

    test(
      'excludes non-public content and resolves locale fallback without mixing translations',
      () async {
        final db = _db();
        final repo = DriftCatalogRepository(db);
        await _publicContent(db, 'public', title: 'Public');
        await _publicContent(
          db,
          'draft',
          title: 'Draft',
          status: EditorialStatus.needsReview,
        );
        await _publicContent(
          db,
          'restricted',
          title: 'Restricted',
          rights: RightsStatus.restricted,
        );
        await _publicContent(
          db,
          'unlicensed',
          title: 'No license',
          license: '',
        );
        await db.into(db.contentItems).insert(_item('fallback'));
        await _source(db, 'fallback');
        await db
            .into(db.contentTranslations)
            .insert(
              _translation(
                'fallback-en',
                'fallback',
                'en',
                title: 'English title',
                summary: 'English summary',
                body: 'English body',
              ),
            );
        await db
            .into(db.contentTranslations)
            .insert(
              _translation(
                'fallback-pt',
                'fallback',
                'pt',
                title: 'Português',
                summary: 'Resumo',
                body: 'Corpo',
              ),
            );
        expect(await _ids(repo), ['fallback', 'public']);
        final resolved = (await repo.getPage(
          locale: const LocaleCode('pt-BR'),
        )).items.firstWhere((e) => e.item.id == 'fallback').translation;
        expect(resolved.locale.value, 'pt');
        expect(resolved.title, 'Português');
        await db
            .into(db.contentTranslations)
            .insert(
              _translation(
                'fallback-pt-br',
                'fallback',
                'pt-BR',
                title: 'Brasil',
                summary: 'Resumo BR',
                body: 'Corpo BR',
              ),
            );
        final exact = (await repo.getPage(
          locale: const LocaleCode('pt-BR'),
        )).items.firstWhere((e) => e.item.id == 'fallback').translation;
        expect(exact.locale.value, 'pt-BR');
        expect(exact.summary, 'Resumo BR');
        await db.close();
      },
    );

    test(
      'returns complete publishable detail and hides missing or non-public detail',
      () async {
        final db = _db();
        final repo = DriftCatalogRepository(db);
        await _publicContent(db, 'detail', title: 'Detail title');
        await _tag(
          db,
          'detail',
          'detail-tag',
          en: 'Detail tag',
          it: 'Etichetta dettaglio',
        );
        await _publicContent(
          db,
          'hidden',
          title: 'Hidden',
          status: EditorialStatus.needsReview,
        );
        final detail = await repo.getPublishedDetailById(
          'detail',
          locale: const LocaleCode('it'),
        );
        expect(detail, isNotNull);
        expect(detail!.content.item.id, 'detail');
        expect(detail.tags.single.label, 'Etichetta dettaglio');
        expect(detail.sources.single.licenseType, 'CC-BY-4.0');
        expect(detail.sources.single.attributionText, 'Attribution');
        expect(
          await repo.getPublishedDetailById(
            'missing',
            locale: const LocaleCode('en'),
          ),
          isNull,
        );
        expect(
          await repo.getPublishedDetailById(
            'hidden',
            locale: const LocaleCode('en'),
          ),
          isNull,
        );
        await db.close();
      },
    );

    test('keeps FTS synchronized after translation and tag changes', () async {
      final db = _db();
      final repo = DriftCatalogRepository(db);
      await _publicContent(
        db,
        'sync',
        title: 'Original title',
        body: 'Original body',
      );
      expect(await _ids(repo, query: 'replacement'), isEmpty);
      await (db.update(
        db.contentTranslations,
      )..where((t) => t.id.equals('tr-sync-en'))).write(
        const ContentTranslationsCompanion(
          title: Value('Replacement title'),
          body: Value('Updated searchable body'),
        ),
      );
      expect(await _ids(repo, query: 'replacement'), ['sync']);
      await _tag(db, 'sync', 'sync-tag', en: 'Fresh tag');
      expect(await _ids(repo, query: 'fresh'), ['sync']);
      await (db.update(db.tagTranslations)..where(
            (t) => t.tagId.equals('tag-sync-tag') & t.locale.equals('en'),
          ))
          .write(const TagTranslationsCompanion(label: Value('Renamed tag')));
      expect(await _ids(repo, query: 'renamed'), ['sync']);
      await (db.delete(db.tagTranslations)..where(
            (t) => t.tagId.equals('tag-sync-tag') & t.locale.equals('en'),
          ))
          .go();
      expect(await _ids(repo, query: 'renamed'), isEmpty);
      await (db.delete(db.contentItemTags)..where(
            (t) => t.contentId.equals('sync') & t.tagId.equals('tag-sync-tag'),
          ))
          .go();
      await (db.update(db.tags)..where((t) => t.id.equals('tag-sync-tag')))
          .write(const TagsCompanion(code: Value('after-removal')));
      expect(await _ids(repo, query: 'after-removal'), isEmpty);
      await db.close();
    });
  });
}

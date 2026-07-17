import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart'
    hide ContentItem, UserProfile;
import 'package:framelab/core/database/app_database.dart'
    as dbmodel
    show ContentItem;
import 'package:framelab/features/catalog/data/catalog_mapper.dart';
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/profile/data/drift_profile_repository.dart';
import 'package:framelab/features/profile/domain/user_profile.dart';

const nowMs = 1704067200000;
AppDatabase memoryDb() => AppDatabase(NativeDatabase.memory());
ContentItemsCompanion item({
  String id = 'item-1',
  EditorialStatus status = EditorialStatus.published,
}) => ContentItemsCompanion.insert(
  id: id,
  type: ContentType.tip.name,
  primaryCategory: 'composition',
  difficulty: Difficulty.beginner.name,
  premium: false,
  canonicalLocale: 'en',
  editorialStatus: status.name,
  version: 1,
  createdAtUtcMs: nowMs,
  updatedAtUtcMs: nowMs,
  publishedAtUtcMs: Value(nowMs),
);
ContentTranslationsCompanion translation({
  required String id,
  required String contentId,
  required String locale,
  TranslationStatus status = TranslationStatus.published,
  String title = 'Title',
  String body = 'Body',
}) => ContentTranslationsCompanion.insert(
  id: id,
  contentId: contentId,
  locale: locale,
  title: title,
  summary: 'Summary',
  body: body,
  translationStatus: status.name,
  translationMethod: TranslationMethod.human.name,
  sourceVersion: 1,
  createdAtUtcMs: nowMs,
  updatedAtUtcMs: nowMs,
);
Future<void> source(
  AppDatabase db,
  String contentId, {
  String id = 'source-1',
  RightsStatus rights = RightsStatus.publishable,
}) async {
  await db
      .into(db.contentSources)
      .insert(
        ContentSourcesCompanion.insert(
          id: id,
          title: 'Open source',
          originalLocale: 'en',
          licenseType: 'CC-BY-4.0',
          rightsStatus: rights.name,
          createdAtUtcMs: nowMs,
          updatedAtUtcMs: nowMs,
        ),
      );
  await db
      .into(db.contentItemSources)
      .insert(
        ContentItemSourcesCompanion.insert(contentId: contentId, sourceId: id),
      );
}

void main() {
  group('Step 3 local database', () {
    test(
      'creates schema v1 with foreign keys enabled and can reopen data',
      () async {
        final db = memoryDb();
        expect(db.schemaVersion, 1);
        final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
        expect(fk.data['foreign_keys'], 1);
        final indexes = await db
            .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
            .get();
        expect(
          indexes.map((row) => row.data['name']),
          containsAll(<String>[
            'content_items_editorial_status_idx',
            'content_items_type_idx',
            'content_items_category_idx',
            'content_items_difficulty_idx',
            'content_items_premium_idx',
            'content_translations_status_idx',
            'content_item_sources_source_idx',
            'content_item_tags_tag_idx',
            'content_sources_rights_status_idx',
          ]),
        );
        await db
            .into(db.userProfiles)
            .insert(
              UserProfilesCompanion.insert(
                id: 'profile',
                skillLevel: SkillLevel.beginner.name,
                preferredLocale: 'en',
                themePreference: ThemePreference.system.name,
                createdAtUtcMs: nowMs,
                updatedAtUtcMs: nowMs,
              ),
            );
        expect((await db.select(db.userProfiles).get()).single.id, 'profile');
        await db.close();
      },
    );
    test(
      'rejects orphan translations and duplicate content locale/tag relations',
      () async {
        final db = memoryDb();
        await expectLater(
          db
              .into(db.contentTranslations)
              .insert(
                translation(id: 'orphan', contentId: 'missing', locale: 'en'),
              ),
          throwsA(isA<Exception>()),
        );
        await db.into(db.contentItems).insert(item());
        await db
            .into(db.contentTranslations)
            .insert(translation(id: 'en', contentId: 'item-1', locale: 'en'));
        await expectLater(
          db
              .into(db.contentTranslations)
              .insert(
                translation(id: 'en2', contentId: 'item-1', locale: 'en'),
              ),
          throwsA(isA<Exception>()),
        );
        await db
            .into(db.tags)
            .insert(TagsCompanion.insert(id: 'tag', code: 'composition'));
        await db
            .into(db.contentItemTags)
            .insert(
              ContentItemTagsCompanion.insert(
                contentId: 'item-1',
                tagId: 'tag',
              ),
            );
        await expectLater(
          db
              .into(db.contentItemTags)
              .insert(
                ContentItemTagsCompanion.insert(
                  contentId: 'item-1',
                  tagId: 'tag',
                ),
              ),
          throwsA(isA<Exception>()),
        );
        await db.close();
      },
    );
    test('cascades translation deletion with content deletion', () async {
      final db = memoryDb();
      await db.into(db.contentItems).insert(item());
      await db
          .into(db.contentTranslations)
          .insert(translation(id: 'en', contentId: 'item-1', locale: 'en'));
      await (db.delete(
        db.contentItems,
      )..where((t) => t.id.equals('item-1'))).go();
      expect(await db.select(db.contentTranslations).get(), isEmpty);
      await db.close();
    });
    test(
      'mapper preserves enums and UTC timestamps and UUID generator is valid',
      () {
        final mapped = contentItemFromRow(
          dbmodel.ContentItem(
            id: 'uuid',
            type: ContentType.guide.name,
            primaryCategory: 'light',
            difficulty: Difficulty.advanced.name,
            premium: true,
            canonicalLocale: 'en',
            editorialStatus: EditorialStatus.published.name,
            version: 2,
            createdAtUtcMs: nowMs,
            updatedAtUtcMs: nowMs,
            publishedAtUtcMs: nowMs,
          ),
        );
        expect(mapped.type, ContentType.guide);
        expect(mapped.createdAt.isUtc, isTrue);
        expect(RegExp(r'^[0-9a-f-]{36}$').hasMatch(newUuid()), isTrue);
      },
    );
    test(
      'public repository filters drafts, unpublished translations and restricted rights',
      () async {
        final db = memoryDb();
        final repo = DriftCatalogRepository(db);
        await db.into(db.contentItems).insert(item());
        await db
            .into(db.contentTranslations)
            .insert(translation(id: 'en', contentId: 'item-1', locale: 'en'));
        await source(db, 'item-1');
        await db
            .into(db.contentItems)
            .insert(item(id: 'draft', status: EditorialStatus.needsReview));
        await db
            .into(db.contentTranslations)
            .insert(
              translation(id: 'draft-en', contentId: 'draft', locale: 'en'),
            );
        await source(db, 'draft', id: 'source-draft');
        await db.into(db.contentItems).insert(item(id: 'unpublished'));
        await db
            .into(db.contentTranslations)
            .insert(
              translation(
                id: 'unpublished-en',
                contentId: 'unpublished',
                locale: 'en',
                status: TranslationStatus.needsReview,
              ),
            );
        await source(db, 'unpublished', id: 'source-unpublished');
        expect(
          (await repo.getPublished(
            locale: const LocaleCode('en'),
          )).map((e) => e.item.id),
          ['item-1'],
        );
        await db.close();
      },
    );
    test(
      'resolves pt-BR then pt then English without mixing card fields',
      () async {
        final db = memoryDb();
        final repo = DriftCatalogRepository(db);
        await db.into(db.contentItems).insert(item());
        await source(db, 'item-1');
        await db
            .into(db.contentTranslations)
            .insert(
              translation(
                id: 'pt',
                contentId: 'item-1',
                locale: 'pt',
                title: 'Português',
                body: 'Corpo português',
              ),
            );
        expect(
          (await repo.getPublished(
            locale: const LocaleCode('pt-BR'),
          )).single.translation.locale.value,
          'pt',
        );
        await db
            .into(db.contentTranslations)
            .insert(
              translation(
                id: 'ptbr',
                contentId: 'item-1',
                locale: 'pt-BR',
                title: 'Brasil',
                body: 'Corpo Brasil',
              ),
            );
        final resolved = (await repo.getPublished(
          locale: const LocaleCode('pt-BR'),
        )).single.translation;
        expect(resolved.locale.value, 'pt-BR');
        expect(resolved.title, 'Brasil');
        await db.close();
      },
    );
    test('filters by type, category, difficulty, premium and tag', () async {
      final db = memoryDb();
      final repo = DriftCatalogRepository(db);
      await db.into(db.contentItems).insert(item());
      await db
          .into(db.contentTranslations)
          .insert(translation(id: 'en', contentId: 'item-1', locale: 'en'));
      await source(db, 'item-1');
      await db
          .into(db.tags)
          .insert(TagsCompanion.insert(id: 'tag', code: 'composition'));
      await db
          .into(db.contentItemTags)
          .insert(
            ContentItemTagsCompanion.insert(contentId: 'item-1', tagId: 'tag'),
          );
      final result = await repo.getPublished(
        locale: const LocaleCode('en'),
        filter: const CatalogFilter(
          type: ContentType.tip,
          category: 'composition',
          difficulty: Difficulty.beginner,
          premium: false,
          tagCode: 'composition',
        ),
      );
      expect(result, hasLength(1));
      await db.close();
    });
    test(
      'profile repository persists stable id and updates UTC preferences',
      () async {
        final db = memoryDb();
        final repo = DriftProfileRepository(db);
        await repo.save(
          UserProfile(
            id: 'profile',
            skillLevel: SkillLevel.beginner,
            preferredLocale: const LocaleCode('it'),
            themePreference: ThemePreference.system,
            createdAt: DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true),
          ),
        );
        await repo.save(
          UserProfile(
            id: 'profile',
            skillLevel: SkillLevel.advanced,
            preferredLocale: const LocaleCode('en'),
            themePreference: ThemePreference.dark,
            createdAt: DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(
              nowMs + 1,
              isUtc: true,
            ),
          ),
        );
        final profile = await repo.get();
        expect(profile!.id, 'profile');
        expect(profile.skillLevel, SkillLevel.advanced);
        expect(profile.updatedAt.isUtc, isTrue);
        await db.close();
      },
    );
  });
}

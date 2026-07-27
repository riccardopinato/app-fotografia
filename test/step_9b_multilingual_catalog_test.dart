import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/editorial/data/bundled_catalog_bootstrap.dart';
import 'package:framelab/features/editorial/data/editorial_importer.dart';
import 'package:framelab/features/editorial/domain/catalog_quality_validation.dart';
import 'package:framelab/features/editorial/domain/editorial_package.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const packagePath = 'editorial/catalog/package.json';
  late String source;
  late Map<String, dynamic> root;
  late Directory temporaryDirectory;

  setUpAll(() async {
    source = await File(packagePath).readAsString();
    root = jsonDecode(source) as Map<String, dynamic>;
  });
  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'framelab-step9b-',
    );
  });
  tearDown(() => temporaryDirectory.delete(recursive: true));

  Future<EditorialPackage> loadPackage() =>
      EditorialPackage.load(File(packagePath));
  BundledCatalogBootstrap bootstrap(AppDatabase database, [String? override]) =>
      BundledCatalogBootstrap(
        database,
        textLoader: (_) async => override ?? source,
        bytesLoader: (key) => File(key).readAsBytes(),
      );

  test(
    'real catalog passes deterministic contract and release quality gates',
    () async {
      final package = await loadPackage();
      final first = await CatalogQualityValidator().validate(package);
      final second = await CatalogQualityValidator().validate(
        await loadPackage(),
      );
      expect(first.isValid, isTrue, reason: first.render());
      expect(first.render(), second.render());
      expect(first.counts, containsPair('published', 30));
    },
  );

  test(
    'contains 30 publishable originals, seven complete locales and no placeholders or duplicate titles',
    () {
      final contents = (root['contents'] as List).cast<Map<String, dynamic>>();
      final published = contents
          .where((content) => content['editorialStatus'] == 'published')
          .toList();
      expect(published, hasLength(30));
      expect(published.map((content) => content['id']).toSet(), hasLength(30));
      final titles = <String>{};
      for (final content in published) {
        final translations = (content['translations'] as List)
            .cast<Map<String, dynamic>>();
        expect(
          translations.map((value) => value['locale']).toSet(),
          CatalogQualityValidator.requiredLocales,
        );
        for (final translation in translations) {
          final text =
              '${translation['title']} ${translation['summary']} ${translation['body']}';
          expect(
            CatalogQualityValidator.placeholderPattern.hasMatch(text),
            isFalse,
          );
          expect(
            titles.add(
              '${translation['locale']}|${translation['title']}'.toLowerCase(),
            ),
            isTrue,
          );
        }
      }
    },
  );

  test('has balanced types, levels and normalized useful tags', () {
    final published = (root['contents'] as List)
        .cast<Map<String, dynamic>>()
        .where((content) => content['editorialStatus'] == 'published');
    int count(String field, String value) =>
        published.where((content) => content[field] == value).length;
    expect(
      [count('type', 'tip'), count('type', 'curiosity'), count('type', 'idea')],
      [10, 10, 10],
    );
    expect(count('difficulty', 'beginner'), 20);
    expect(count('difficulty', 'intermediate'), 10);
    final used = published
        .expand((content) => (content['tags'] as List).cast<String>())
        .toSet();
    final declared = (root['tags'] as List).cast<Map<String, dynamic>>();
    expect(declared.map((tag) => tag['id']).toSet(), used);
    expect(
      declared.every(
        (tag) => CatalogQualityValidator.tagCodePattern.hasMatch(
          tag['code'] as String,
        ),
      ),
      isTrue,
    );
  });

  test(
    'assets are original, locally complete and include all localized alt text',
    () async {
      final assets = (root['assets'] as List).cast<Map<String, dynamic>>();
      expect(assets, hasLength(6));
      for (final asset in assets) {
        expect(asset['licenseType'], 'FrameLab-Proprietary');
        expect(asset['rightsVerification'], 'verified');
        expect(
          (asset['altTexts'] as Map).keys.toSet(),
          CatalogQualityValidator.requiredLocales,
        );
        expect(
          await File('editorial/catalog/${asset['path']}').exists(),
          isTrue,
        );
      }
      expect(
        (await CatalogQualityValidator().validate(await loadPackage())).isValid,
        isTrue,
      );
    },
  );

  test(
    'bootstrap fills an empty real database and a second launch is idempotent',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temporaryDirectory.path}/empty.sqlite')),
      );
      addTearDown(database.close);
      final first = await bootstrap(database).install();
      final second = await bootstrap(database).install();
      expect((first.inserted, second.unchanged), (31, 31));
      expect(await database.contentItems.count().getSingle(), 31);
      expect(await database.contentTranslations.count().getSingle(), 211);
      expect(
        await DriftCatalogRepository(
          database,
        ).getPublished(locale: const LocaleCode('it')),
        hasLength(30),
      );
    },
  );

  test(
    'bootstrap upgrades legacy IDs, rejects downgrade and rolls invalid input back',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temporaryDirectory.path}/versions.sqlite')),
      );
      addTearDown(database.close);
      const legacyId = 'seed-exposure-triangle-basics';
      await database
          .into(database.contentItems)
          .insert(
            ContentItemsCompanion.insert(
              id: legacyId,
              type: 'tip',
              primaryCategory: 'exposure',
              difficulty: 'beginner',
              premium: false,
              canonicalLocale: 'en',
              editorialStatus: 'published',
              version: 1,
              createdAtUtcMs: 1,
              updatedAtUtcMs: 1,
              publishedAtUtcMs: const Value(1),
            ),
          );
      expect((await bootstrap(database).install()).updated, 1);
      expect(
        (await (database.select(
          database.contentItems,
        )..where((row) => row.id.equals(legacyId))).getSingle()).version,
        2,
      );
      final downgrade = jsonDecode(source) as Map<String, dynamic>;
      ((downgrade['contents'] as List).first
              as Map<String, dynamic>)['version'] =
          1;
      await expectLater(
        bootstrap(database, jsonEncode(downgrade)).install(),
        throwsA(isA<EditorialImportException>()),
      );
      final invalid = jsonDecode(source) as Map<String, dynamic>;
      invalid['formatVersion'] = 'invalid';
      await expectLater(
        bootstrap(database, jsonEncode(invalid)).install(),
        throwsA(isA<EditorialImportException>()),
      );
      expect(await database.contentItems.count().getSingle(), 31);
    },
  );

  test(
    'catalog update preserves profile, language, save, collection, note and state',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temporaryDirectory.path}/personal.sqlite')),
      );
      addTearDown(database.close);
      await bootstrap(database).install();
      await database
          .into(database.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              id: 'profile',
              skillLevel: 'intermediate',
              preferredLocale: 'it',
              languageMode: const Value('manual'),
              selectedLocale: const Value('it'),
              themePreference: 'system',
              createdAtUtcMs: 1,
              updatedAtUtcMs: 1,
            ),
          );
      await database
          .into(database.collections)
          .insert(
            CollectionsCompanion.insert(
              id: 'collection',
              name: 'Practice',
              createdAtUtcMs: 1,
              updatedAtUtcMs: 1,
            ),
          );
      await database
          .into(database.savedItems)
          .insert(
            SavedItemsCompanion.insert(
              id: 'saved',
              contentId: 'seed-exposure-triangle-basics',
              collectionId: const Value('collection'),
              note: const Value('Keep this note'),
              status: 'completed',
              savedAtUtcMs: 1,
              updatedAtUtcMs: 1,
            ),
          );
      final update = jsonDecode(source) as Map<String, dynamic>;
      final content =
          (update['contents'] as List).first as Map<String, dynamic>;
      content['version'] = 3;
      for (final translation
          in (content['translations'] as List).cast<Map<String, dynamic>>()) {
        translation['sourceVersion'] = 3;
      }
      expect(
        (await bootstrap(database, jsonEncode(update)).install()).updated,
        1,
      );
      final profile = await database.select(database.userProfiles).getSingle();
      final saved = await database.select(database.savedItems).getSingle();
      expect((profile.languageMode, profile.selectedLocale), ('manual', 'it'));
      expect(
        (saved.collectionId, saved.note, saved.status),
        ('collection', 'Keep this note', 'completed'),
      );
    },
  );

  test(
    'multilingual FTS, filters and deterministic pagination use the bundled catalog',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temporaryDirectory.path}/search.sqlite')),
      );
      addTearDown(database.close);
      await bootstrap(database).install();
      final repository = DriftCatalogRepository(database);
      Future<CatalogPage> search(String query) => repository.getPage(
        locale: const LocaleCode('it'),
        query: query,
        limit: 50,
      );
      expect((await search('istogramma')).items, isNotEmpty); // title
      expect((await search('fotogrammi')).items, isNotEmpty); // body
      expect((await search('esposizione')).items, isNotEmpty); // localized tag
      final tips = await repository.getPage(
        locale: const LocaleCode('de'),
        filter: const CatalogFilter(
          type: ContentType.tip,
          difficulty: Difficulty.beginner,
        ),
        limit: 50,
      );
      expect(tips.items, isNotEmpty);
      expect(
        tips.items.every(
          (item) =>
              item.item.type == ContentType.tip &&
              item.item.difficulty == Difficulty.beginner,
        ),
        isTrue,
      );
      final first = await repository.getPage(
        locale: const LocaleCode('en'),
        limit: 7,
      );
      final second = await repository.getPage(
        locale: const LocaleCode('en'),
        limit: 7,
        offset: 7,
      );
      expect(first.hasMore, isTrue);
      expect(
        first.items
            .map((item) => item.item.id)
            .toSet()
            .intersection(second.items.map((item) => item.item.id).toSet()),
        isEmpty,
      );
    },
  );

  test(
    'fallback remains available and draft is excluded from catalog, search and Home input',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temporaryDirectory.path}/gate.sqlite')),
      );
      addTearDown(database.close);
      await bootstrap(database).install();
      final repository = DriftCatalogRepository(database);
      final fallback = await repository.getPublishedById(
        'seed-exposure-triangle-basics',
        locale: const LocaleCode('nl'),
      );
      expect(fallback?.translation.locale.value, 'en');
      expect(
        await repository.getPublishedById(
          'editorial-draft-reflection-study',
          locale: const LocaleCode('en'),
        ),
        isNull,
      );
      expect(
        (await repository.getPage(
          locale: const LocaleCode('en'),
          query: 'Reflection study',
        )).items,
        isEmpty,
      );
      expect(
        await repository.getPublished(locale: const LocaleCode('en')),
        hasLength(30),
      );
    },
  );
}

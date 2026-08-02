import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/editorial/data/editorial_importer.dart';
import 'package:framelab/features/editorial/domain/editorial_package.dart';
import 'package:framelab/features/editorial/domain/editorial_validation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temp;
  late File packageFile;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('framelab-editorial-');
    await Directory('${temp.path}/assets').create();
    await File(
      'editorial/example/assets/exposure.svg',
    ).copy('${temp.path}/assets/exposure.svg');
    packageFile = await File(
      'editorial/example/package.json',
    ).copy('${temp.path}/package.json');
  });
  tearDown(() => temp.delete(recursive: true));

  Future<Map<String, dynamic>> json() async =>
      jsonDecode(await packageFile.readAsString()) as Map<String, dynamic>;
  Future<EditorialReport> validate(Map<String, dynamic> value) async {
    await packageFile.writeAsString(jsonEncode(value));
    return EditorialValidator().validate(
      await EditorialPackage.load(packageFile),
    );
  }

  test('valid package and deterministic human-readable report', () async {
    final reportA = await EditorialValidator().validate(
      await EditorialPackage.load(packageFile),
    );
    final reportB = await EditorialValidator().validate(
      await EditorialPackage.load(packageFile),
    );
    expect(reportA.isValid, isTrue);
    expect(reportA.render(), reportB.render());
    expect(
      reportA.render(),
      contains('contents=2, translations=3, sources=1, assets=1'),
    );
  });

  test(
    'reports required fields, duplicate IDs and duplicate translations',
    () async {
      final value = await json();
      value.remove('generatedAt');
      final contents = value['contents'] as List;
      contents.add(jsonDecode(jsonEncode(contents.first)));
      ((contents.first as Map)['translations'] as List).add(
        jsonDecode(
          jsonEncode(((contents.first as Map)['translations'] as List).first),
        ),
      );
      final codes = (await validate(value)).issues.map((issue) => issue.code);
      expect(
        codes,
        containsAll([
          'field.required',
          'id.duplicate',
          'translation.duplicate',
        ]),
      );
    },
  );

  test(
    'reports orphan and partial translations and unsupported locale',
    () async {
      final value = await json();
      final translation =
          (((value['contents'] as List).first as Map)['translations'] as List)
                  .first
              as Map;
      translation['locale'] = 'xx';
      translation['body'] = '';
      value['translations'] = [
        {'contentId': 'missing', 'locale': 'en'},
      ];
      final codes = (await validate(value)).issues.map((issue) => issue.code);
      expect(
        codes,
        containsAll([
          'locale.unsupported',
          'translation.partial',
          'translation.orphan',
          'translation.required',
        ]),
      );
    },
  );

  test('rejects a translation targeting a different content version', () async {
    final value = await json();
    final translation =
        (((value['contents'] as List).first as Map)['translations'] as List)
                .first
            as Map;
    translation['sourceVersion'] = 1;
    expect(
      (await validate(value)).issues.map((issue) => issue.code),
      contains('translation.outdated'),
    );
  });

  test(
    'reports missing source and insufficient license or attribution',
    () async {
      final value = await json();
      final source = (value['sources'] as List).first as Map;
      source['licenseType'] = 'public-url';
      source['attributionRequired'] = true;
      source['attributionText'] = '';
      (((value['contents'] as List).first as Map)['sourceIds'] as List).add(
        'missing',
      );
      final codes = (await validate(value)).issues.map((issue) => issue.code);
      expect(
        codes,
        containsAll([
          'rights.license',
          'rights.attribution',
          'reference.source',
        ]),
      );
    },
  );

  test('reports absent asset, unsafe path and checksum mismatch', () async {
    final value = await json();
    final asset = (value['assets'] as List).first as Map;
    asset['path'] = '../outside.svg';
    expect(
      (await validate(value)).issues.map((i) => i.code),
      contains('asset.path'),
    );
    asset['path'] = 'assets/missing.svg';
    expect(
      (await validate(value)).issues.map((i) => i.code),
      contains('asset.missing'),
    );
    asset['path'] = 'assets/exposure.svg';
    asset['checksum'] = 'fnv1a64:0000000000000000';
    expect(
      (await validate(value)).issues.map((i) => i.code),
      contains('asset.checksum'),
    );
  });

  test(
    'imports repeatedly, upgrades, rejects downgrade and preserves personal data',
    () async {
      final dbFile = File('${temp.path}/database.sqlite');
      final database = AppDatabase(NativeDatabase(dbFile));
      addTearDown(database.close);
      final importer = EditorialImporter(database);
      var package = await EditorialPackage.load(packageFile);
      final first = await importer.import(package);
      final second = await importer.import(package);
      expect((first.inserted, second.unchanged), (2, 2));
      expect(await database.contentItems.count().getSingle(), 2);
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
              contentId: 'editorial-exposure-practice',
              collectionId: const Value('collection'),
              note: const Value('personal note'),
              status: 'tried',
              savedAtUtcMs: 1,
              updatedAtUtcMs: 1,
            ),
          );
      final value = await json();
      final content = (value['contents'] as List).first as Map;
      content['version'] = 3;
      final translations = content['translations'] as List;
      final translation = translations.cast<Map>().firstWhere(
        (value) => value['locale'] == 'en',
      );
      translations
        ..clear()
        ..add(translation);
      translation['sourceVersion'] = 3;
      translation['title'] = 'Updated title';
      await packageFile.writeAsString(jsonEncode(value));
      package = await EditorialPackage.load(packageFile);
      expect((await importer.import(package)).updated, 1);
      final outdatedItalian =
          await (database.select(database.contentTranslations)..where(
                (row) =>
                    row.contentId.equals('editorial-exposure-practice') &
                    row.locale.equals('it'),
              ))
              .getSingle();
      expect(
        (outdatedItalian.translationStatus, outdatedItalian.sourceVersion),
        ('outdated', 2),
      );
      expect(
        (await DriftCatalogRepository(database).getPublishedById(
          'editorial-exposure-practice',
          locale: const LocaleCode('it'),
        ))?.translation.title,
        'Updated title',
      );
      final saved = await database.select(database.savedItems).getSingle();
      expect(
        (saved.note, saved.status, saved.collectionId),
        ('personal note', 'tried', 'collection'),
      );
      content['version'] = 2;
      translation['sourceVersion'] = 2;
      await packageFile.writeAsString(jsonEncode(value));
      await expectLater(
        importer.import(await EditorialPackage.load(packageFile)),
        throwsA(isA<EditorialImportException>()),
      );
      expect((await database.select(database.contentItems).get()).length, 2);
    },
  );

  test(
    'validation failure writes nothing and transaction rolls back on SQLite error',
    () async {
      final database = AppDatabase(
        NativeDatabase(File('${temp.path}/atomic.sqlite')),
      );
      addTearDown(database.close);
      final invalid = await json();
      invalid['formatVersion'] = 'bad';
      await packageFile.writeAsString(jsonEncode(invalid));
      await expectLater(
        EditorialImporter(
          database,
        ).import(await EditorialPackage.load(packageFile)),
        throwsA(isA<EditorialImportException>()),
      );
      expect(await database.contentItems.count().getSingle(), 0);
      final valid = await json();
      valid['formatVersion'] = '1.0';
      await packageFile.writeAsString(jsonEncode(valid));
      await database.customStatement(
        "CREATE TRIGGER abort_second BEFORE INSERT ON content_items WHEN NEW.id='editorial-review-only' BEGIN SELECT RAISE(ABORT, 'test rollback'); END",
      );
      await expectLater(
        EditorialImporter(
          database,
        ).import(await EditorialPackage.load(packageFile)),
        throwsA(anything),
      );
      expect(await database.contentItems.count().getSingle(), 0);
      expect(await database.contentSources.count().getSingle(), 0);
    },
  );

  test('catalog fallback works and review-only content is excluded', () async {
    final database = AppDatabase(
      NativeDatabase(File('${temp.path}/catalog.sqlite')),
    );
    addTearDown(database.close);
    await EditorialImporter(
      database,
    ).import(await EditorialPackage.load(packageFile));
    final repository = DriftCatalogRepository(database);
    final italian = await repository.getPublishedById(
      'editorial-exposure-practice',
      locale: const LocaleCode('it-IT'),
    );
    final germanFallback = await repository.getPublishedById(
      'editorial-exposure-practice',
      locale: const LocaleCode('de'),
    );
    expect(italian?.translation.locale.value, 'it');
    expect(germanFallback?.translation.locale.value, 'en');
    expect(
      await repository.getPublishedById(
        'editorial-review-only',
        locale: const LocaleCode('en'),
      ),
      isNull,
    );
  });

  test(
    'validator CLI returns zero for valid and non-zero for invalid',
    () async {
      final flutterRoot = Platform.environment['FLUTTER_ROOT'];
      final dartExecutable =
          Platform.environment['DART_EXECUTABLE'] ??
          (flutterRoot == null
              ? 'dart'
              : [
                  flutterRoot,
                  'bin',
                  'cache',
                  'dart-sdk',
                  'bin',
                  Platform.isWindows ? 'dart.exe' : 'dart',
                ].join(Platform.pathSeparator));
      final valid = await Process.run(dartExecutable, [
        'run',
        'bin/framelab_editorial.dart',
        'validate',
        packageFile.path,
      ]);
      final invalid = await Process.run(dartExecutable, [
        'run',
        'bin/framelab_editorial.dart',
        'validate',
        'editorial/invalid/package.json',
      ]);
      expect(valid.exitCode, 0);
      expect(invalid.exitCode, isNonZero);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

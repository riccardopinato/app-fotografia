import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/catalog/data/seed/catalog_seed.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart'
    hide ContentTranslation;

AppDatabase _db() => AppDatabase(NativeDatabase.memory());

Future<Map<String, List<ContentTranslation>>> _translationsByContent(
  AppDatabase db,
) async {
  final rows = await db.select(db.contentTranslations).get();
  final grouped = <String, List<ContentTranslation>>{};
  for (final row in rows) {
    (grouped[row.contentId] ??= []).add(row);
  }
  return grouped;
}

void main() {
  group('Step 5B localized catalog seed set', () {
    test('installs seven locales on all ten seed contents', () async {
      final db = _db();
      await CatalogSeedInstaller(db).install();

      final grouped = await _translationsByContent(db);
      expect(await db.select(db.contentItems).get(), hasLength(10));
      for (final id in localizedCatalogSeedContentIds) {
        final translations = grouped[id] ?? const <ContentTranslation>[];
        expect(
          translations.map((row) => row.locale).toSet(),
          catalogSeedLocales.toSet(),
        );
        expect(translations, hasLength(catalogSeedLocales.length));
        for (final translation in translations) {
          expect(translation.title.trim(), isNotEmpty);
          expect(translation.summary.trim(), isNotEmpty);
          expect(translation.body.trim(), isNotEmpty);
          expect(
            translation.translationStatus,
            TranslationStatus.published.name,
          );
          expect(
            translation.translationMethod,
            translation.locale == 'en'
                ? TranslationMethod.original.name
                : TranslationMethod.machine.name,
          );
          expect(translation.createdAtUtcMs, greaterThan(0));
          expect(translation.updatedAtUtcMs, greaterThan(0));
        }
      }
      await db.close();
    });

    test(
      'keeps one translation per content-locale and remains idempotent',
      () async {
        final db = _db();
        final installer = CatalogSeedInstaller(db);
        await installer.install();
        await installer.install();

        expect(await db.select(db.contentItems).get(), hasLength(10));
        expect(await db.select(db.contentSources).get(), hasLength(1));
        expect(await db.select(db.contentTranslations).get(), hasLength(70));
        expect(await db.select(db.contentItemSources).get(), hasLength(10));
        expect(await db.select(db.contentItemTags).get(), hasLength(10));

        final duplicates = await db.customSelect('''
        SELECT content_id, locale, count(*) AS total
        FROM content_translations
        GROUP BY content_id, locale
        HAVING total <> 1
      ''').get();
        expect(duplicates, isEmpty);
        final ids = (await db.select(db.contentItems).get())
            .map((row) => row.id)
            .toList();
        expect(ids.toSet(), catalogSeedContentIds.toSet());
        await db.close();
      },
    );

    test(
      'resolves pt-BR exactly, falls back to pt, then to English without mixing fields',
      () async {
        final db = _db();
        await CatalogSeedInstaller(db).install();
        final repo = DriftCatalogRepository(db);
        const id = 'seed-exposure-triangle-basics';

        final exact = await repo.getPublishedById(
          id,
          locale: const LocaleCode('pt-BR'),
        );
        expect(exact!.translation.locale.value, 'pt-BR');
        expect(exact.translation.title, contains('triângulo'));
        expect(exact.translation.summary, contains('Equilibre'));
        expect(exact.translation.body, contains('Comece'));

        await (db.delete(
          db.contentTranslations,
        )..where((table) => table.id.equals('$id-pt-BR'))).go();
        final base = await repo.getPublishedById(
          id,
          locale: const LocaleCode('pt-BR'),
        );
        expect(base!.translation.locale.value, 'pt');
        expect(base.translation.summary, contains('Equilibra'));
        expect(base.translation.body, contains('Começa'));
        expect(base.translation.body, isNot(contains('Comece')));

        await (db.delete(
          db.contentTranslations,
        )..where((table) => table.id.equals('$id-pt'))).go();
        final english = await repo.getPublishedById(
          id,
          locale: const LocaleCode('pt-BR'),
        );
        expect(english!.translation.locale.value, 'en');
        expect(english.translation.title, 'Exposure triangle basics');
        expect(english.translation.summary, startsWith('Balance aperture'));
        expect(english.translation.body, contains('Start with'));
        await db.close();
      },
    );

    test(
      'indexes localized translations for FTS search and backfills current seed data',
      () async {
        final db = _db();
        await CatalogSeedInstaller(db).install();
        final repo = DriftCatalogRepository(db);
        final cases = <String, String>{
          'diaframma': 'seed-exposure-triangle-basics',
          'obturación': 'seed-exposure-triangle-basics',
          'déclencheur': 'seed-low-light-stability',
          'Verschlusszeit': 'seed-exposure-triangle-basics',
          'fotómetro': 'seed-exposure-triangle-basics',
          'assunto': 'seed-leading-lines-composition',
          'sfondo': 'seed-background-separation',
          'histograma': 'seed-histogram-check',
          'tiers': 'seed-rule-of-thirds-practice',
          'Mitzieher': 'seed-motion-shutter-speed',
          'objetiva': 'seed-lens-cleaning-checklist',
          'bombinha': 'seed-lens-cleaning-checklist',
        };

        for (final entry in cases.entries) {
          final page = await repo.getPage(
            locale: const LocaleCode('en'),
            query: entry.key,
            limit: 10,
          );
          expect(page.items.map((item) => item.item.id), contains(entry.value));
        }

        await (db.update(db.contentTranslations)..where(
              (table) => table.id.equals('seed-golden-hour-portraits-it'),
            ))
            .write(
              const ContentTranslationsCompanion(
                body: Value(
                  'Ritratto aggiornato con riflettore naturale e luce calda.',
                ),
              ),
            );
        final updated = await repo.getPage(
          locale: const LocaleCode('it'),
          query: 'riflettore',
        );
        expect(
          updated.items.map((item) => item.item.id),
          contains('seed-golden-hour-portraits'),
        );
        await db.close();
      },
    );

    test(
      'indexes localized tag labels and keeps publishability rules',
      () async {
        final db = _db();
        await CatalogSeedInstaller(db).install();
        final repo = DriftCatalogRepository(db);

        expect(
          (await repo.getPage(
            locale: const LocaleCode('it'),
            query: 'manutenzione',
          )).items.map((item) => item.item.id),
          contains('seed-lens-cleaning-checklist'),
        );
        final restrictedSource =
            await (db.select(db.contentSources)..where(
                  (table) => table.id.equals('source-framelab-editorial-seed'),
                ))
                .getSingle();
        await (db.update(
          db.contentSources,
        )..where((table) => table.id.equals(restrictedSource.id))).write(
          const ContentSourcesCompanion(rightsStatus: Value('restricted')),
        );
        expect(
          await repo.getPublished(locale: const LocaleCode('en')),
          isEmpty,
        );
        await db.close();
      },
    );

    test(
      'keeps the first five stable and localizes the remaining five',
      () async {
        final db = _db();
        await CatalogSeedInstaller(db).install();
        final grouped = await _translationsByContent(db);
        for (final id in catalogSeedContentIds) {
          expect(
            grouped[id]!.map((row) => row.locale).toSet(),
            catalogSeedLocales.toSet(),
          );
        }
        final firstFiveEnglishTitles = {
          for (final id in catalogSeedContentIds.take(5))
            id: grouped[id]!.singleWhere((row) => row.locale == 'en').title,
        };
        expect(firstFiveEnglishTitles, {
          'seed-exposure-triangle-basics': 'Exposure triangle basics',
          'seed-golden-hour-portraits': 'Use golden hour for gentle portraits',
          'seed-leading-lines-composition': 'Guide the eye with leading lines',
          'seed-low-light-stability': 'Keep low-light shots stable',
          'seed-white-balance-color': 'Set white balance for believable colour',
        });
        for (final id in catalogSeedContentIds.skip(5)) {
          final translations = grouped[id]!;
          expect(translations, hasLength(catalogSeedLocales.length));
          expect(
            translations
                .where((row) => row.locale == 'en')
                .single
                .translationMethod,
            TranslationMethod.original.name,
          );
          expect(
            translations
                .where((row) => row.locale != 'en')
                .every(
                  (row) =>
                      row.translationMethod == TranslationMethod.machine.name,
                ),
            isTrue,
          );
        }
        await db.close();
      },
    );
  });
}

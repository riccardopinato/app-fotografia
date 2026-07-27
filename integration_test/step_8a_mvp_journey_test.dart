import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/core/database/app_database.dart' hide UserProfile;
import 'package:framelab/features/catalog/data/drift_catalog_repository.dart';
import 'package:framelab/features/editorial/data/bundled_catalog_bootstrap.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/library/data/drift_library_repository.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/presentation/library_controller.dart';
import 'package:framelab/features/profile/data/drift_profile_repository.dart';
import 'package:framelab/features/profile/domain/user_profile.dart';

void main() {
  test(
    'critical offline journey persists across repository and app rebuilds',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'framelab-step8a-',
      );
      final file = File('${directory.path}/framelab.sqlite');
      addTearDown(() => directory.delete(recursive: true));

      var database = AppDatabase(NativeDatabase(file));
      var profiles = DriftProfileRepository(database);
      var catalog = DriftCatalogRepository(database);
      var library = DriftLibraryRepository(database);
      await BundledCatalogBootstrap(database).install();

      final createdAt = DateTime.utc(2026, 7, 26);
      await profiles.save(
        UserProfile(
          id: 'local-user',
          skillLevel: SkillLevel.beginner,
          languageMode: LanguageMode.manual,
          selectedLocale: const LocaleCode('it'),
          preferredTopics: const ['portrait'],
          learningGoals: const ['composition'],
          themePreference: ThemePreference.system,
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );
      expect((await profiles.get())?.selectedLocale, const LocaleCode('it'));

      final homeCatalog = await catalog.getPublished(
        locale: const LocaleCode('it'),
      );
      expect(homeCatalog, isNotEmpty);
      final contentId = homeCatalog.first.item.id;
      final detail = await catalog.getPublishedDetailById(
        contentId,
        locale: const LocaleCode('it'),
      );
      expect(detail?.content.translation.locale, const LocaleCode('it'));

      await library.save(contentId);
      final collection = await library.createCollection('Da praticare');
      await library.updateDetails(
        contentId,
        note: 'Provare al tramonto',
        status: SavedItemStatus.completed,
        collectionId: collection.id,
      );

      final archive = LibraryController(
        library,
        catalog,
        const LocaleCode('it'),
      )..start();
      await _waitFor(() => !archive.isLoading && archive.entries.length == 1);
      archive.setQuery('tramonto');
      archive.setStatusFilter(SavedItemStatus.completed);
      archive.setCollectionFilter(collection.id);
      expect(archive.entries.single.savedItem.contentId, contentId);
      archive.dispose();

      await database.close();
      database = AppDatabase(NativeDatabase(file));
      profiles = DriftProfileRepository(database);
      catalog = DriftCatalogRepository(database);
      library = DriftLibraryRepository(database);
      addTearDown(database.close);

      final persisted = (await library.getSavedItems()).single;
      expect(persisted.note, 'Provare al tramonto');
      expect(persisted.status, SavedItemStatus.completed);
      expect(persisted.collectionId, collection.id);
      expect((await profiles.get())?.selectedLocale, const LocaleCode('it'));

      final profile = (await profiles.get())!;
      await profiles.save(
        UserProfile(
          id: profile.id,
          skillLevel: profile.skillLevel,
          languageMode: LanguageMode.manual,
          selectedLocale: const LocaleCode('de'),
          preferredTopics: profile.preferredTopics,
          cameraBodies: profile.cameraBodies,
          lenses: profile.lenses,
          smartphones: profile.smartphones,
          learningGoals: profile.learningGoals,
          themePreference: profile.themePreference,
          createdAt: profile.createdAt,
          updatedAt: DateTime.utc(2026, 7, 27),
        ),
      );
      final german = await catalog.getPublishedById(
        contentId,
        locale: const LocaleCode('de'),
      );
      expect(german?.translation.locale, const LocaleCode('de'));
      expect(
        (await library.getSavedItems()).single.note,
        'Provare al tramonto',
      );
      expect((await profiles.get())?.selectedLocale, const LocaleCode('de'));
      expect(database.schemaVersion, 4);
    },
  );
}

Future<void> _waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 100 && !condition(); attempt++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  expect(condition(), isTrue);
}

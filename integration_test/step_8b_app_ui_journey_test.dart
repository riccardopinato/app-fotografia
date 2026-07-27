import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/app/frame_lab_app.dart';
import 'package:framelab/app/router/app_router.dart';
import 'package:framelab/core/database/app_database.dart';
import 'package:framelab/features/catalog/data/seed/catalog_seed.dart';
import 'package:framelab/features/library/data/drift_library_repository.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/profile/data/drift_profile_repository.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  registerStep8bAppUiJourney();
}

void registerStep8bAppUiJourney() {
  testWidgets('critical user journey survives a complete app reconstruction', (
    tester,
  ) async {
    final directory = (await tester.runAsync(
      () => Directory.systemTemp.createTemp('framelab-ui-'),
    ))!;
    final file = File('${directory.path}/framelab.sqlite');
    addTearDown(() async {
      appRouter.go('/home');
      if (await directory.exists()) await directory.delete(recursive: true);
    });
    appRouter.go('/home');

    var database = AppDatabase(NativeDatabase(file));
    await tester.runAsync(() => CatalogSeedInstaller(database).install());
    await tester.pumpWidget(FrameLabApp(database: database));

    // Onboarding and bootstrap are exercised through the real app tree.
    await _pumpUntilFound(tester, find.text('Set up your photography profile'));
    await _tapVisible(tester, find.text('Save preferences'));
    await _pumpUntilFound(tester, find.text('Your photography, at your pace'));

    // Real shell navigation, catalog, detail route, and local save toggle.
    await tester.tap(find.text('Explore').last);
    await _pumpUntilFound(tester, find.text('Explore catalog'));
    await _pumpUntilFound(
      tester,
      find.text('Check the histogram after difficult light'),
    );
    await _tapVisible(
      tester,
      find
          .bySemanticsLabel('Open Check the histogram after difficult light')
          .first,
    );
    await _pumpUntilFound(tester, find.text('Content detail'));
    expect(find.text('Available offline'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('catalog-detail-save-toggle')));
    await _pumpUntilFound(tester, find.text('Saved'));

    // Archive collection CRUD and the atomic personal-item editor.
    await tester.tap(find.text('Library').last);
    await _pumpUntilFound(tester, find.text('Search saved content and notes'));
    await _pumpUntilFound(
      tester,
      find.text('Check the histogram after difficult light'),
    );
    await tester.tap(find.text('Manage collections'));
    await _pumpUntilFound(tester, find.text('No collections yet.'));
    await tester.tap(find.text('New collection'));
    await _pumpUntilFound(tester, find.text('Collection name'));
    await tester.enterText(find.byType(TextFormField).last, 'Field practice');
    await tester.tap(find.text('Save').last);
    await _pumpUntilFound(tester, find.text('Field practice'));
    await _pumpTransition(tester);
    await _tapVisible(tester, find.text('Done'));
    await _pumpTransition(tester);

    await tester.tap(
      find.byTooltip('Edit Check the histogram after difficult light'),
    );
    await _pumpUntilFound(tester, find.text('Personal note'));
    await _tapVisible(tester, find.text('To try'));
    await _pumpTransition(tester);
    await tester.tap(find.text('Completed').last);
    await _tapVisible(tester, find.text('No collection'));
    await _pumpTransition(tester);
    await tester.tap(find.text('Field practice').last);
    await tester.enterText(find.byType(TextFormField).last, 'Sunset checklist');
    await tester.tap(find.text('Save').last);
    await _pumpUntilFound(tester, find.text('Sunset checklist'));

    // Search and both filters are applied and removed via Archive controls.
    final search = find.widgetWithText(
      TextField,
      'Search saved content and notes',
    );
    await tester.enterText(search, 'Sunset');
    await tester.pump();
    expect(
      find.text('Check the histogram after difficult light'),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('All statuses'));
    await _pumpTransition(tester);
    await tester.tap(find.text('Completed').last);
    await _tapVisible(tester, find.text('All collections'));
    await _pumpTransition(tester);
    await tester.tap(find.text('Field practice').last);
    expect(
      find.text('Check the histogram after difficult light'),
      findsOneWidget,
    );
    await tester.enterText(search, 'not present');
    await tester.pump();
    await _pumpUntilFound(tester, find.text('No saved content found'));
    await _tapVisible(tester, find.text('Clear search and filters'));
    await _pumpUntilFound(
      tester,
      find.text('Check the histogram after difficult light'),
    );

    // Dispose the whole application and rebuild all scopes and repositories
    // against the same persistent SQLite database.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump();
    await tester.runAsync(database.close);
    database = AppDatabase(NativeDatabase(file));
    await tester.pumpWidget(FrameLabApp(database: database));
    await _pumpUntilFound(
      tester,
      find.text('Check the histogram after difficult light'),
    );
    expect(find.text('Sunset checklist'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    // Change locale through the real Profile UI and return to the localized
    // Archive. Personal data must remain attached to the conceptual content.
    await tester.tap(find.text('Profile').last);
    await _pumpUntilFound(tester, find.text('Your profile'));
    await _tapVisible(tester, find.text('Choose a language'));
    await _pumpUntilFound(tester, find.text('Language'));
    await tester.tap(find.text('English').last);
    await _pumpTransition(tester);
    await tester.tap(find.text('German').last);
    await _tapVisible(tester, find.text('Save changes'));
    await _pumpUntilFound(tester, find.text('Änderungen speichern'));
    await tester.tap(find.text('Archiv').last);
    await _pumpUntilFound(
      tester,
      find.text('Prüfe nach schwierigem Licht das Histogramm'),
    );
    expect(find.text('Sunset checklist'), findsOneWidget);

    // Direct data reads are limited to final persisted-state assertions.
    final persisted = (await tester.runAsync(
      () async =>
          (await DriftLibraryRepository(database).getSavedItems()).single,
    ))!;
    expect(persisted.note, 'Sunset checklist');
    expect(persisted.status, SavedItemStatus.completed);
    expect(persisted.collectionId, isNotNull);
    expect(
      (await tester.runAsync(
        () => DriftProfileRepository(database).get(),
      ))?.selectedLocale?.value,
      'de',
    );
    expect(database.schemaVersion, 4);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump();
    await tester.runAsync(database.close);
  });
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder.last);
  await tester.pump();
  await tester.tap(finder.last);
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 100 && finder.evaluate().isEmpty; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

Future<void> _pumpTransition(WidgetTester tester) async {
  // Material route and menu transitions are finite; a bounded pump avoids
  // waiting on unrelated progress indicators elsewhere in the real app tree.
  await tester.pump(const Duration(milliseconds: 400));
}

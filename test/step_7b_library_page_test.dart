import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/app/router/app_routes.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/catalog/presentation/catalog_scope.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/domain/library_repository.dart';
import 'package:framelab/features/library/presentation/library_page.dart';
import 'package:framelab/features/library/presentation/library_scope.dart';
import 'package:framelab/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows saved cards in repository order and opens the detail', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    final catalog = _FakeCatalogRepository();
    addTearDown(library.dispose);

    await _pumpLibrary(tester, library: library, catalog: catalog);
    library.emit([_saved('b', 2), _saved('a', 1)]);
    await _flush(tester);

    expect(find.text('Title b').evaluate().single, isNotNull);
    expect(
      tester.getTopLeft(find.text('Title b')).dy,
      lessThan(tester.getTopLeft(find.text('Title a')).dy),
    );

    await tester.tap(
      find.bySemanticsLabel(
        RegExp(
          r'^Open saved content: Title b\. Status: To try\. '
          r'Personal note: No note$',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('detail:b'), findsOneWidget);
  });

  testWidgets('shows localized empty and recoverable error states', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    final catalog = _FakeCatalogRepository();
    addTearDown(library.dispose);

    await _pumpLibrary(
      tester,
      library: library,
      catalog: catalog,
      locale: const Locale('it'),
    );
    library.emit(const []);
    await _flush(tester);

    expect(find.text('Nessun contenuto salvato'), findsOneWidget);
    expect(
      find.text('Salva un contenuto dal catalogo per ritrovarlo qui.'),
      findsOneWidget,
    );

    catalog.failuresRemaining = 1;
    library.emit([_saved('a', 1)]);
    await _flush(tester);
    expect(find.text('Archivio non disponibile'), findsOneWidget);

    await tester.tap(find.text('Riprova'));
    await _flush(tester);
    expect(find.text('Titolo a'), findsOneWidget);
  });

  testWidgets('keeps Italian semantics usable with large text', (tester) async {
    final semantics = tester.ensureSemantics();
    final library = _FakeLibraryRepository();
    final catalog = _FakeCatalogRepository();
    addTearDown(library.dispose);

    await _pumpLibrary(
      tester,
      library: library,
      catalog: catalog,
      locale: const Locale('it'),
      textScaler: const TextScaler.linear(2),
    );
    library.emit([
      _saved(
        'a',
        1,
        note: 'Provare con luce laterale',
        status: SavedItemStatus.completed,
        collectionId: 'portraits',
      ),
    ]);
    library.emitCollections([_collection('portraits', 'Ritratti')]);
    await _flush(tester);

    expect(find.text('Archivio'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp(
          r'^Apri contenuto salvato: Titolo a\. Stato: Completato\. '
          r'Nota personale: Provare con luce laterale\. Raccolta: Ritratti$',
        ),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('fits long German copy in a compact dark viewport at 2x', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 960);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final library = _FakeLibraryRepository();
    final catalog = _FakeCatalogRepository();
    addTearDown(library.dispose);

    await _pumpLibrary(
      tester,
      library: library,
      catalog: catalog,
      locale: const Locale('de'),
      textScaler: const TextScaler.linear(2),
      themeMode: ThemeMode.dark,
    );
    library.emit([_saved('a', 1, note: 'Eine hilfreiche persönliche Notiz')]);
    await _flush(tester);

    expect(
      find.text('Gespeicherte Inhalte und Notizen durchsuchen'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('searches the library and opens the personal item editor', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    final catalog = _FakeCatalogRepository();
    addTearDown(library.dispose);

    await _pumpLibrary(tester, library: library, catalog: catalog);
    library.emit([_saved('a', 1), _saved('b', 2)]);
    await _flush(tester);

    await tester.enterText(find.byType(TextField).first, 'Title b');
    await tester.pump();
    expect(find.text('Title a'), findsNothing);
    expect(find.text('Title b'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Edit Title b'));
    await tester.pumpAndSettle();
    expect(find.text('Personal note'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Collection'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Personal reminder');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(library.detailUpdateCalls, 1);
    expect(library.lastNote, 'Personal reminder');
  });
}

Future<void> _pumpLibrary(
  WidgetTester tester, {
  required _FakeLibraryRepository library,
  required _FakeCatalogRepository catalog,
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  final router = GoRouter(
    initialLocation: '/library',
    routes: [
      GoRoute(
        path: '/library',
        builder: (context, state) => const Scaffold(body: LibraryPage()),
      ),
      GoRoute(
        path: '/explore/content/:contentId',
        name: AppRoutes.exploreContentName,
        builder: (context, state) =>
            Text('detail:${state.pathParameters['contentId']}'),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: CatalogScope(
          repository: catalog,
          child: LibraryScope(repository: library, child: child!),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _flush(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

SavedItem _saved(
  String contentId,
  int order, {
  String? note,
  String? collectionId,
  SavedItemStatus status = SavedItemStatus.toTry,
}) => SavedItem(
  id: 'saved-$contentId',
  contentId: contentId,
  note: note,
  collectionId: collectionId,
  status: status,
  savedAtUtc: DateTime.utc(2026, 1, order),
  updatedAtUtc: DateTime.utc(2026, 1, order),
);

CollectionWithCount _collection(String id, String name) => CollectionWithCount(
  collection: Collection(
    id: id,
    name: name,
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
  ),
  savedItemCount: 1,
);

LocalizedContent _content(String id, LocaleCode locale) => LocalizedContent(
  item: ContentItem(
    id: id,
    type: ContentType.tip,
    primaryCategory: 'exposure',
    difficulty: Difficulty.beginner,
    premium: false,
    canonicalLocale: const LocaleCode('en'),
    editorialStatus: EditorialStatus.published,
    version: 1,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  ),
  translation: ContentTranslation(
    id: '$id-${locale.value}',
    contentId: id,
    locale: locale,
    title: locale.language == 'it' ? 'Titolo $id' : 'Title $id',
    summary: locale.language == 'it' ? 'Sommario $id' : 'Summary $id',
    body: 'Body $id',
    status: TranslationStatus.published,
    method: TranslationMethod.human,
    sourceVersion: 1,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  ),
  tags: const [],
);

class _FakeCatalogRepository implements CatalogRepository {
  int failuresRemaining = 0;

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async {
    if (failuresRemaining > 0) {
      failuresRemaining -= 1;
      throw StateError('catalog failed');
    }
    return _content(id, locale);
  }

  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) async => null;

  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) async => const CatalogPage(items: [], hasMore: false);

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async => const [];

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => const Stream.empty();
}

class _FakeLibraryRepository implements LibraryRepository {
  final _savedItems = StreamController<List<SavedItem>>.broadcast(sync: true);
  final _collections = StreamController<List<CollectionWithCount>>.broadcast(
    sync: true,
  );
  int detailUpdateCalls = 0;
  String? lastNote;

  void emit(List<SavedItem> items) => _savedItems.add(items);
  void emitCollections(List<CollectionWithCount> items) =>
      _collections.add(items);

  Future<void> dispose() async {
    await _savedItems.close();
    await _collections.close();
  }

  @override
  Stream<List<SavedItem>> watchSavedItems() => _savedItems.stream;

  @override
  Stream<SavedItem?> watchSavedItem(String contentId) => const Stream.empty();

  @override
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  }) async => const [];

  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) =>
      throw UnsupportedError('not used');

  @override
  Future<void> remove(String contentId) async {}

  @override
  Future<void> assignCollection(String contentId, String? collectionId) async {}

  @override
  Future<Collection> createCollection(String name) =>
      throw UnsupportedError('not used');

  @override
  Future<void> deleteCollection(String id) async {}

  @override
  Future<void> renameCollection(String id, String name) async {}

  @override
  Future<void> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  }) async {
    detailUpdateCalls += 1;
    lastNote = note;
  }

  @override
  Future<void> updateNote(String contentId, String? note) async {}

  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) async {}

  @override
  Stream<List<CollectionWithCount>> watchCollections() => _collections.stream;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/catalog/presentation/catalog_detail_page.dart';
import 'package:framelab/features/catalog/presentation/catalog_scope.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/domain/library_repository.dart';
import 'package:framelab/features/library/presentation/library_scope.dart';
import 'package:framelab/l10n/app_localizations.dart';

const _toggleKey = ValueKey('catalog-detail-save-toggle');

void main() {
  testWidgets('shows the toggle for a loaded detail with LibraryScope', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    addTearDown(library.dispose);

    await _pumpDetail(tester, library: library);
    library.emit(null);
    await tester.pump();

    expect(find.byKey(_toggleKey), findsOneWidget);
  });

  testWidgets('omits the toggle when LibraryScope is unavailable', (
    tester,
  ) async {
    await _pumpDetail(tester);

    expect(find.byKey(_toggleKey), findsNothing);
    expect(find.text('Titolo dettaglio'), findsOneWidget);
  });

  testWidgets(
    'renders localized unsaved label, outline icon, tooltip and semantics',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final library = _FakeLibraryRepository();
      addTearDown(library.dispose);

      await _pumpDetail(tester, library: library);
      library.emit(null);
      await tester.pump();

      expect(find.text('Salva'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      expect(find.byTooltip('Salva'), findsOneWidget);
      expect(find.bySemanticsLabel('Salva'), findsOneWidget);
      semantics.dispose();
    },
  );

  testWidgets('renders the localized saved label and filled icon', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    addTearDown(library.dispose);

    await _pumpDetail(tester, library: library);
    library.emit(_savedItem());
    await tester.pump();

    expect(find.text('Salvato'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsNothing);
  });

  testWidgets('tapping Save invokes exactly one save operation', (
    tester,
  ) async {
    final library = _FakeLibraryRepository();
    addTearDown(library.dispose);

    await _pumpDetail(tester, library: library);
    library.emit(null);
    await tester.pump();
    await tester.tap(find.byKey(_toggleKey));
    await tester.pump();

    expect(library.saveCalls, 1);
    expect(library.removeCalls, 0);
  });

  testWidgets('tapping Saved invokes removal', (tester) async {
    final library = _FakeLibraryRepository();
    addTearDown(library.dispose);

    await _pumpDetail(tester, library: library);
    library.emit(_savedItem());
    await tester.pump();
    await tester.tap(find.byKey(_toggleKey));
    await tester.pump();

    expect(library.saveCalls, 0);
    expect(library.removeCalls, 1);
  });

  testWidgets('disables the control while saving and removing', (tester) async {
    final library = _FakeLibraryRepository();
    addTearDown(library.dispose);
    final save = Completer<SavedItem>();
    library.saveCompleter = save;

    await _pumpDetail(tester, library: library);
    library.emit(null);
    await tester.pump();
    await tester.tap(find.byKey(_toggleKey));
    await tester.pump();

    expect(_toggle(tester).onPressed, isNull);
    expect(find.text('Salva'), findsOneWidget);

    final saved = _savedItem();
    save.complete(saved);
    await tester.pump();
    library.emit(saved);
    await tester.pump();

    final remove = Completer<void>();
    library.removeCompleter = remove;
    await tester.tap(find.byKey(_toggleKey));
    await tester.pump();

    expect(_toggle(tester).onPressed, isNull);
    expect(find.text('Salvato'), findsOneWidget);

    remove.complete();
    await tester.pump();
    library.emit(null);
    await tester.pump();
    expect(_toggle(tester).onPressed, isNotNull);
  });

  testWidgets(
    'keeps the unsaved state after an error and allows a successful retry',
    (tester) async {
      final library = _FakeLibraryRepository()
        ..saveFailuresRemaining = 1
        ..emitOnSuccessfulSave = true;
      addTearDown(library.dispose);

      await _pumpDetail(tester, library: library);
      library.emit(null);
      await tester.pump();
      await tester.tap(find.byKey(_toggleKey));
      await tester.pumpAndSettle();

      expect(library.saveCalls, 1);
      expect(find.text('Salva'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      expect(
        find.text('Impossibile aggiornare il salvataggio. Riprova.'),
        findsOneWidget,
      );
      expect(_toggle(tester).onPressed, isNotNull);

      await tester.tap(find.byKey(_toggleKey));
      await tester.pumpAndSettle();

      expect(library.saveCalls, 2);
      expect(find.text('Salvato'), findsOneWidget);
      expect(
        find.text('Impossibile aggiornare il salvataggio. Riprova.'),
        findsNothing,
      );
    },
  );
}

OutlinedButton _toggle(WidgetTester tester) =>
    tester.widget<OutlinedButton>(find.byKey(_toggleKey));

Future<void> _pumpDetail(
  WidgetTester tester, {
  _FakeLibraryRepository? library,
}) async {
  Widget home = CatalogScope(
    repository: _FakeCatalogRepository(),
    child: const CatalogDetailPage(contentId: 'detail'),
  );
  if (library != null) {
    home = LibraryScope(repository: library, child: home);
  }
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

SavedItem _savedItem() => SavedItem(
  id: 'saved-detail',
  contentId: 'detail',
  savedAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
);

CatalogDetail _detail() => CatalogDetail(
  content: LocalizedContent(
    item: ContentItem(
      id: 'detail',
      type: ContentType.guide,
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
      id: 'detail-it',
      contentId: 'detail',
      locale: const LocaleCode('it'),
      title: 'Titolo dettaglio',
      summary: 'Sommario dettaglio',
      body: 'Corpo completo del dettaglio',
      status: TranslationStatus.published,
      method: TranslationMethod.human,
      sourceVersion: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    tags: const [],
  ),
  tags: const [],
  sources: const [],
);

class _FakeCatalogRepository implements CatalogRepository {
  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) async => _detail();

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
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async => null;

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => const Stream.empty();
}

class _FakeLibraryRepository implements LibraryRepository {
  final _savedItem = StreamController<SavedItem?>.broadcast(sync: true);

  int saveCalls = 0;
  int removeCalls = 0;
  int saveFailuresRemaining = 0;
  bool emitOnSuccessfulSave = false;
  Completer<SavedItem>? saveCompleter;
  Completer<void>? removeCompleter;

  void emit(SavedItem? item) => _savedItem.add(item);

  Future<void> dispose() => _savedItem.close();

  @override
  Stream<SavedItem?> watchSavedItem(String contentId) => _savedItem.stream;

  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) async {
    saveCalls += 1;
    if (saveFailuresRemaining > 0) {
      saveFailuresRemaining -= 1;
      throw StateError('save failed');
    }
    final pending = saveCompleter;
    final saved = pending == null ? _savedItemValue() : await pending.future;
    if (emitOnSuccessfulSave) emit(saved);
    return saved;
  }

  SavedItem _savedItemValue() => SavedItem(
    id: 'saved-detail',
    contentId: 'detail',
    savedAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
  );

  @override
  Future<void> remove(String contentId) async {
    removeCalls += 1;
    final pending = removeCompleter;
    if (pending != null) await pending.future;
  }

  @override
  Stream<List<SavedItem>> watchSavedItems() => const Stream.empty();

  @override
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  }) async => const [];

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
  Future<void> updateNote(String contentId, String? note) async {}

  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) async {}

  @override
  Stream<List<CollectionWithCount>> watchCollections() => const Stream.empty();
}

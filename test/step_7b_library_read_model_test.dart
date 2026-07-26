import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/domain/library_repository.dart';
import 'package:framelab/features/library/presentation/library_controller.dart';

void main() {
  test(
    'joins saved items to localized content without changing their order',
    () async {
      final library = _FakeLibraryRepository();
      final catalog = _FakeCatalogRepository();
      final controller = LibraryController(
        library,
        catalog,
        const LocaleCode('it'),
      )..start();
      addTearDown(() async {
        controller.dispose();
        await library.dispose();
      });

      final settled = _whenSettled(controller);
      library.emit([_saved('b'), _saved('missing'), _saved('a')]);
      await settled;

      expect(controller.entries.map((entry) => entry.savedItem.contentId), [
        'b',
        'a',
      ]);
      expect(
        controller.entries.map((entry) => entry.content.translation.title),
        ['Titolo b', 'Titolo a'],
      );
      expect(catalog.locales, everyElement(const LocaleCode('it')));
    },
  );

  test('ignores stale catalog results after a locale change', () async {
    final library = _FakeLibraryRepository();
    final catalog = _ControlledCatalogRepository();
    final controller = LibraryController(
      library,
      catalog,
      const LocaleCode('en'),
    )..start();
    addTearDown(() async {
      controller.dispose();
      await library.dispose();
    });

    library.emit([_saved('a')]);
    controller.setLocale(const LocaleCode('it'));
    final settled = _whenSettled(controller);

    catalog.italian.complete(_content('a', const LocaleCode('it')));
    await settled;
    catalog.english.complete(_content('a', const LocaleCode('en')));
    await Future<void>.value();
    await Future<void>.value();

    expect(controller.entries.single.content.translation.locale.value, 'it');
    expect(controller.entries.single.content.translation.title, 'Titolo a');
  });

  test(
    'surfaces catalog errors and retries the latest saved snapshot',
    () async {
      final library = _FakeLibraryRepository();
      final catalog = _FakeCatalogRepository()..failuresRemaining = 1;
      final controller = LibraryController(
        library,
        catalog,
        const LocaleCode('en'),
      )..start();
      addTearDown(() async {
        controller.dispose();
        await library.dispose();
      });

      final failed = _whenSettled(controller);
      library.emit([_saved('a')]);
      await failed;
      expect(controller.error, isA<StateError>());
      expect(controller.entries, isEmpty);

      await controller.retry();
      expect(controller.error, isNull);
      expect(controller.entries.single.savedItem.contentId, 'a');
    },
  );
}

Future<void> _whenSettled(LibraryController controller) {
  if (!controller.isLoading) return Future<void>.value();
  final completer = Completer<void>();
  late VoidCallback listener;
  listener = () {
    if (controller.isLoading || completer.isCompleted) return;
    controller.removeListener(listener);
    completer.complete();
  };
  controller.addListener(listener);
  return completer.future;
}

SavedItem _saved(String contentId) => SavedItem(
  id: 'saved-$contentId',
  contentId: contentId,
  savedAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
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
    summary: 'Summary $id',
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
  final locales = <LocaleCode>[];
  int failuresRemaining = 0;

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async {
    locales.add(locale);
    if (failuresRemaining > 0) {
      failuresRemaining -= 1;
      throw StateError('catalog failed');
    }
    return id == 'missing' ? null : _content(id, locale);
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

class _ControlledCatalogRepository extends _FakeCatalogRepository {
  final english = Completer<LocalizedContent?>();
  final italian = Completer<LocalizedContent?>();

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) => locale.language == 'it' ? italian.future : english.future;
}

class _FakeLibraryRepository implements LibraryRepository {
  final _savedItems = StreamController<List<SavedItem>>.broadcast(sync: true);

  void emit(List<SavedItem> items) => _savedItems.add(items);

  Future<void> dispose() => _savedItems.close();

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
  Future<void> updateNote(String contentId, String? note) async {}

  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) async {}

  @override
  Stream<List<CollectionWithCount>> watchCollections() => const Stream.empty();
}

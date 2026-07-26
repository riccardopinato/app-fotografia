import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/domain/library_repository.dart';
import 'package:framelab/features/library/presentation/library_controller.dart';

void main() {
  test(
    'searches titles, summaries, and notes and combines library filters',
    () async {
      final library = _LibraryFake();
      final controller = LibraryController(
        library,
        _CatalogFake(),
        const LocaleCode('en'),
      )..start();
      addTearDown(() async {
        controller.dispose();
        await library.dispose();
      });

      library.emitCollections([_collection('portraits')]);
      library.emitSaved([
        _saved('light', note: 'Practice outdoors'),
        _saved(
          'portrait',
          status: SavedItemStatus.completed,
          collectionId: 'portraits',
        ),
      ]);
      await _flush();

      controller.setQuery('outdoors');
      expect(controller.entries.single.savedItem.contentId, 'light');

      controller.setQuery('summary portrait');
      expect(controller.entries.single.savedItem.contentId, 'portrait');

      controller.setStatusFilter(SavedItemStatus.completed);
      controller.setCollectionFilter('portraits');
      expect(controller.entries.single.savedItem.contentId, 'portrait');

      controller.setCollectionFilter('missing');
      expect(controller.entries, isEmpty);
      controller.clearFilters();
      expect(controller.entries, hasLength(2));
    },
  );

  test(
    'runs recoverable non-optimistic mutations and exposes failures',
    () async {
      final library = _LibraryFake();
      final controller = LibraryController(
        library,
        _CatalogFake(),
        const LocaleCode('en'),
      )..start();
      addTearDown(() async {
        controller.dispose();
        await library.dispose();
      });
      library.emitSaved([_saved('light')]);
      await _flush();

      library.failure = StateError('write failed');
      expect(
        await controller.updateStatus('light', SavedItemStatus.completed),
        isFalse,
      );
      expect(controller.mutationError, isA<StateError>());
      expect(controller.entries.single.savedItem.status, SavedItemStatus.toTry);

      library.failure = null;
      expect(
        await controller.updateDetails(
          'light',
          note: 'remember',
          status: SavedItemStatus.completed,
          collectionId: 'portraits',
        ),
        isTrue,
      );
      expect(library.lastNote, 'remember');
      expect(library.lastStatus, SavedItemStatus.completed);
      expect(library.lastCollectionId, 'portraits');
      controller.clearMutationError();
      expect(controller.mutationError, isNull);
    },
  );

  test(
    'blocks concurrent collection mutations until Drift write completes',
    () async {
      final library = _LibraryFake();
      final controller = LibraryController(
        library,
        _CatalogFake(),
        const LocaleCode('en'),
      )..start();
      addTearDown(() async {
        controller.dispose();
        await library.dispose();
      });
      library.collectionWrite = Completer<void>();

      final first = controller.createCollection('Street');
      expect(controller.isCollectionBusy, isTrue);
      final duplicate = await controller.createCollection('Street');
      final competing = await controller.renameCollection('id', 'Portraits');

      expect(duplicate, isFalse);
      expect(competing, isFalse);
      expect(library.collectionWriteCalls, 1);
      library.collectionWrite!.complete();
      expect(await first, isTrue);
      expect(controller.isCollectionBusy, isFalse);
    },
  );
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

CollectionWithCount _collection(String id) => CollectionWithCount(
  collection: Collection(
    id: id,
    name: 'Portraits',
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
  ),
  savedItemCount: 1,
);

SavedItem _saved(
  String id, {
  String? note,
  String? collectionId,
  SavedItemStatus status = SavedItemStatus.toTry,
}) => SavedItem(
  id: 'saved-$id',
  contentId: id,
  note: note,
  collectionId: collectionId,
  status: status,
  savedAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
);

class _CatalogFake implements CatalogRepository {
  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async => LocalizedContent(
    item: ContentItem(
      id: id,
      type: ContentType.tip,
      primaryCategory: 'practice',
      difficulty: Difficulty.beginner,
      premium: false,
      canonicalLocale: const LocaleCode('en'),
      editorialStatus: EditorialStatus.published,
      version: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    translation: ContentTranslation(
      id: '$id-en',
      contentId: id,
      locale: locale,
      title: 'Title $id',
      summary: 'Summary $id',
      body: 'Body',
      status: TranslationStatus.published,
      method: TranslationMethod.human,
      sourceVersion: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    tags: const [],
  );

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

class _LibraryFake implements LibraryRepository {
  final saved = StreamController<List<SavedItem>>.broadcast(sync: true);
  final collections = StreamController<List<CollectionWithCount>>.broadcast(
    sync: true,
  );
  Object? failure;
  String? lastNote;
  SavedItemStatus? lastStatus;
  String? lastCollectionId;
  Completer<void>? collectionWrite;
  int collectionWriteCalls = 0;

  void emitSaved(List<SavedItem> value) => saved.add(value);
  void emitCollections(List<CollectionWithCount> value) =>
      collections.add(value);
  Future<void> dispose() async {
    await saved.close();
    await collections.close();
  }

  Future<void> _write() async {
    if (failure case final error?) throw error;
  }

  @override
  Stream<List<SavedItem>> watchSavedItems() => saved.stream;
  @override
  Stream<List<CollectionWithCount>> watchCollections() => collections.stream;
  @override
  Future<void> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  }) async {
    await _write();
    lastNote = note;
    lastStatus = status;
    lastCollectionId = collectionId;
  }

  @override
  Future<void> updateNote(String contentId, String? note) async {
    await _write();
    lastNote = note;
  }

  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) =>
      _write();
  @override
  Future<void> assignCollection(String contentId, String? collectionId) =>
      _write();
  @override
  Future<void> remove(String contentId) => _write();
  @override
  Future<Collection> createCollection(String name) async {
    collectionWriteCalls += 1;
    await collectionWrite?.future;
    return Collection(
      id: 'collection',
      name: name,
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026),
    );
  }

  @override
  Future<void> renameCollection(String id, String name) => _write();
  @override
  Future<void> deleteCollection(String id) => _write();
  @override
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  }) async => const [];
  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) =>
      throw UnimplementedError();
  @override
  Stream<SavedItem?> watchSavedItem(String contentId) => const Stream.empty();
}

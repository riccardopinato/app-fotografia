import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/library/domain/library_models.dart';
import 'package:framelab/features/library/domain/library_repository.dart';
import 'package:framelab/features/library/presentation/saved_item_controller.dart';

void main() {
  test(
    'follows the stream and chooses save or remove from current state',
    () async {
      final repository = _FakeLibraryRepository();
      final controller = SavedItemController(repository, 'content')..start();
      addTearDown(() async {
        controller.dispose();
        await repository.dispose();
      });

      repository.emit(null);
      expect(controller.isSaved, isFalse);
      expect(controller.canToggle, isTrue);

      await controller.toggle();
      expect(repository.saveCalls, 1);
      expect(repository.removeCalls, 0);

      repository.emit(_savedItem());
      expect(controller.isSaved, isTrue);
      await controller.toggle();
      expect(repository.saveCalls, 1);
      expect(repository.removeCalls, 1);
    },
  );

  test('prevents concurrent mutations while an operation is pending', () async {
    final repository = _FakeLibraryRepository();
    final controller = SavedItemController(repository, 'content')..start();
    addTearDown(() async {
      controller.dispose();
      await repository.dispose();
    });
    final pending = Completer<SavedItem>();
    repository.pendingSave = pending;
    repository.emit(null);

    final first = controller.toggle();
    final duplicate = controller.toggle();

    expect(controller.isMutating, isTrue);
    expect(controller.canToggle, isFalse);
    expect(repository.saveCalls, 1);

    pending.complete(_savedItem());
    await Future.wait([first, duplicate]);
    expect(controller.isMutating, isFalse);
    expect(repository.saveCalls, 1);
  });

  test(
    'preserves the streamed state after errors and remains retryable',
    () async {
      final repository = _FakeLibraryRepository()..removeFailuresRemaining = 1;
      final controller = SavedItemController(repository, 'content')..start();
      addTearDown(() async {
        controller.dispose();
        await repository.dispose();
      });
      repository.emit(_savedItem());

      await controller.toggle();

      expect(repository.removeCalls, 1);
      expect(controller.error, isA<StateError>());
      expect(controller.isSaved, isTrue);
      expect(controller.canToggle, isTrue);

      await controller.toggle();
      repository.emit(null);

      expect(repository.removeCalls, 2);
      expect(controller.error, isNull);
      expect(controller.isSaved, isFalse);
    },
  );
}

SavedItem _savedItem() => SavedItem(
  id: 'saved-content',
  contentId: 'content',
  savedAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
);

class _FakeLibraryRepository implements LibraryRepository {
  final _savedItem = StreamController<SavedItem?>.broadcast(sync: true);

  int saveCalls = 0;
  int removeCalls = 0;
  int removeFailuresRemaining = 0;
  Completer<SavedItem>? pendingSave;

  void emit(SavedItem? item) => _savedItem.add(item);

  Future<void> dispose() => _savedItem.close();

  @override
  Stream<SavedItem?> watchSavedItem(String contentId) => _savedItem.stream;

  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) async {
    saveCalls += 1;
    final pending = pendingSave;
    return pending == null ? _savedItemValue(contentId) : pending.future;
  }

  SavedItem _savedItemValue(String contentId) => SavedItem(
    id: 'saved-$contentId',
    contentId: contentId,
    savedAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
  );

  @override
  Future<void> remove(String contentId) async {
    removeCalls += 1;
    if (removeFailuresRemaining > 0) {
      removeFailuresRemaining -= 1;
      throw StateError('remove failed');
    }
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
  Future<void> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  }) async {}

  @override
  Future<void> updateNote(String contentId, String? note) async {}

  @override
  Future<void> updateStatus(String contentId, SavedItemStatus status) async {}

  @override
  Stream<List<CollectionWithCount>> watchCollections() => const Stream.empty();
}

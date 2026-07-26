import 'library_models.dart';

abstract interface class LibraryRepository {
  Stream<List<SavedItem>> watchSavedItems();
  Stream<SavedItem?> watchSavedItem(String contentId);
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  });
  Future<SavedItem> save(String contentId, {String? collectionId});
  Future<void> remove(String contentId);
  Future<void> updateNote(String contentId, String? note);
  Future<void> updateStatus(String contentId, SavedItemStatus status);
  Future<void> assignCollection(String contentId, String? collectionId);
  Future<void> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  });
  Stream<List<CollectionWithCount>> watchCollections();
  Future<Collection> createCollection(String name);
  Future<void> renameCollection(String id, String name);
  Future<void> deleteCollection(String id);
}

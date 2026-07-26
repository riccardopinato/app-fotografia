import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../catalog/domain/catalog_models.dart';
import '../../catalog/domain/catalog_repository.dart';
import '../domain/library_models.dart';
import '../domain/library_repository.dart';

class LibraryEntry {
  const LibraryEntry({required this.savedItem, required this.content});

  final SavedItem savedItem;
  final LocalizedContent content;
}

class LibraryController extends ChangeNotifier {
  LibraryController(
    this._libraryRepository,
    this._catalogRepository,
    this._locale,
  );

  final LibraryRepository _libraryRepository;
  final CatalogRepository _catalogRepository;
  LocaleCode _locale;

  StreamSubscription<List<SavedItem>>? _savedSubscription;
  StreamSubscription<List<CollectionWithCount>>? _collectionSubscription;
  List<SavedItem> _savedItems = const [];
  List<LibraryEntry> _allEntries = const [];
  List<CollectionWithCount> _collections = const [];
  String _query = '';
  SavedItemStatus? _statusFilter;
  String? _collectionFilter;
  Object? _error;
  Object? _mutationError;
  bool _isLoading = true;
  bool _disposed = false;
  bool _collectionBusy = false;
  int _requestSerial = 0;
  final Set<String> _busyContentIds = {};

  List<LibraryEntry> get entries {
    final normalizedQuery = _query.trim().toLowerCase();
    return List.unmodifiable(
      _allEntries.where((entry) {
        final item = entry.savedItem;
        if (_statusFilter != null && item.status != _statusFilter) return false;
        if (_collectionFilter != null &&
            item.collectionId != _collectionFilter) {
          return false;
        }
        if (normalizedQuery.isEmpty) return true;
        return entry.content.translation.title.toLowerCase().contains(
              normalizedQuery,
            ) ||
            entry.content.translation.summary.toLowerCase().contains(
              normalizedQuery,
            ) ||
            (item.note?.toLowerCase().contains(normalizedQuery) ?? false);
      }),
    );
  }

  List<CollectionWithCount> get collections => _collections;
  String get query => _query;
  SavedItemStatus? get statusFilter => _statusFilter;
  String? get collectionFilter => _collectionFilter;
  Object? get error => _error;
  Object? get mutationError => _mutationError;
  bool get isLoading => _isLoading;
  bool get hasSavedItems => _allEntries.isNotEmpty;
  bool get isCollectionBusy => _collectionBusy;
  bool get hasActiveFilters =>
      _query.trim().isNotEmpty ||
      _statusFilter != null ||
      _collectionFilter != null;
  bool isBusy(String contentId) => _busyContentIds.contains(contentId);

  void start() {
    if (_savedSubscription != null) return;
    _savedSubscription = _libraryRepository.watchSavedItems().listen((items) {
      _savedItems = List.unmodifiable(items);
      unawaited(_resolve(items));
    }, onError: _onStreamError);
    _collectionSubscription = _libraryRepository.watchCollections().listen((
      collections,
    ) {
      _collections = List.unmodifiable(collections);
      if (_collectionFilter != null &&
          !_collections.any(
            (entry) => entry.collection.id == _collectionFilter,
          )) {
        _collectionFilter = null;
      }
      _notify();
    }, onError: _onStreamError);
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    _error = error;
    _isLoading = false;
    _notify();
  }

  void setLocale(LocaleCode locale) {
    if (_locale == locale) return;
    _locale = locale;
    unawaited(_resolve(_savedItems));
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    _notify();
  }

  void setStatusFilter(SavedItemStatus? value) {
    if (_statusFilter == value) return;
    _statusFilter = value;
    _notify();
  }

  void setCollectionFilter(String? value) {
    if (_collectionFilter == value) return;
    _collectionFilter = value;
    _notify();
  }

  void clearFilters() {
    _query = '';
    _statusFilter = null;
    _collectionFilter = null;
    _notify();
  }

  void clearMutationError() {
    if (_mutationError == null) return;
    _mutationError = null;
    _notify();
  }

  Future<void> retry() => _resolve(_savedItems);

  Future<bool> updateNote(String contentId, String? note) =>
      _mutate(contentId, () => _libraryRepository.updateNote(contentId, note));

  Future<bool> updateStatus(String contentId, SavedItemStatus status) =>
      _mutate(
        contentId,
        () => _libraryRepository.updateStatus(contentId, status),
      );

  Future<bool> assignCollection(String contentId, String? collectionId) =>
      _mutate(
        contentId,
        () => _libraryRepository.assignCollection(contentId, collectionId),
      );

  Future<bool> updateDetails(
    String contentId, {
    required String? note,
    required SavedItemStatus status,
    required String? collectionId,
  }) => _mutate(
    contentId,
    () => _libraryRepository.updateDetails(
      contentId,
      note: note,
      status: status,
      collectionId: collectionId,
    ),
  );

  Future<bool> remove(String contentId) =>
      _mutate(contentId, () => _libraryRepository.remove(contentId));

  Future<bool> _mutate(
    String contentId,
    Future<void> Function() operation,
  ) async {
    if (_busyContentIds.contains(contentId)) return false;
    _busyContentIds.add(contentId);
    _mutationError = null;
    _notify();
    try {
      await operation();
      return true;
    } catch (error) {
      _mutationError = error;
      return false;
    } finally {
      _busyContentIds.remove(contentId);
      _notify();
    }
  }

  Future<bool> createCollection(String name) =>
      _collectionMutation(() => _libraryRepository.createCollection(name));

  Future<bool> renameCollection(String id, String name) =>
      _collectionMutation(() => _libraryRepository.renameCollection(id, name));

  Future<bool> deleteCollection(String id) =>
      _collectionMutation(() => _libraryRepository.deleteCollection(id));

  Future<bool> _collectionMutation(Future<Object?> Function() operation) async {
    if (_collectionBusy) return false;
    _collectionBusy = true;
    _mutationError = null;
    _notify();
    try {
      await operation();
      return true;
    } catch (error) {
      _mutationError = error;
      return false;
    } finally {
      _collectionBusy = false;
      _notify();
    }
  }

  Future<void> _resolve(List<SavedItem> items) async {
    final serial = ++_requestSerial;
    _isLoading = true;
    _error = null;
    _notify();
    try {
      final resolved = await Future.wait(
        items.map((savedItem) async {
          final content = await _catalogRepository.getPublishedById(
            savedItem.contentId,
            locale: _locale,
          );
          return content == null
              ? null
              : LibraryEntry(savedItem: savedItem, content: content);
        }),
      );
      if (serial != _requestSerial) return;
      _allEntries = List.unmodifiable(resolved.whereType<LibraryEntry>());
    } catch (error) {
      if (serial != _requestSerial) return;
      _error = error;
    } finally {
      if (serial == _requestSerial) {
        _isLoading = false;
        _notify();
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_savedSubscription?.cancel());
    unawaited(_collectionSubscription?.cancel());
    super.dispose();
  }
}

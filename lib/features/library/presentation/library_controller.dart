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

  StreamSubscription<List<SavedItem>>? _subscription;
  List<SavedItem> _savedItems = const [];
  List<LibraryEntry> _entries = const [];
  Object? _error;
  bool _isLoading = true;
  bool _disposed = false;
  int _requestSerial = 0;

  List<LibraryEntry> get entries => _entries;
  Object? get error => _error;
  bool get isLoading => _isLoading;

  void start() {
    if (_subscription != null) return;
    _subscription = _libraryRepository.watchSavedItems().listen(
      (items) {
        _savedItems = List.unmodifiable(items);
        unawaited(_resolve(items));
      },
      onError: (Object error, StackTrace stackTrace) {
        _error = error;
        _isLoading = false;
        _notify();
      },
    );
  }

  void setLocale(LocaleCode locale) {
    if (_locale == locale) return;
    _locale = locale;
    unawaited(_resolve(_savedItems));
  }

  Future<void> retry() => _resolve(_savedItems);

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
      _entries = List.unmodifiable(resolved.whereType<LibraryEntry>());
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
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}

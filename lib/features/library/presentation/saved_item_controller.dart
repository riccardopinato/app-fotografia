import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/library_models.dart';
import '../domain/library_repository.dart';

class SavedItemController extends ChangeNotifier {
  SavedItemController(this._repository, this.contentId);

  final LibraryRepository _repository;
  final String contentId;

  StreamSubscription<SavedItem?>? _subscription;
  SavedItem? _savedItem;
  Object? _error;
  bool _hasSnapshot = false;
  bool _isMutating = false;
  bool _disposed = false;

  SavedItem? get savedItem => _savedItem;
  Object? get error => _error;
  bool get isSaved => _savedItem != null;
  bool get isMutating => _isMutating;
  bool get canToggle => _hasSnapshot && !_isMutating;

  void start() {
    if (_subscription != null) return;
    _subscription = _repository
        .watchSavedItem(contentId)
        .listen(
          (item) {
            _savedItem = item;
            _error = null;
            _hasSnapshot = true;
            _notify();
          },
          onError: (Object error, StackTrace stackTrace) {
            _error = error;
            _hasSnapshot = true;
            _notify();
          },
        );
  }

  Future<void> toggle() async {
    if (!canToggle) return;
    _isMutating = true;
    _error = null;
    _notify();
    try {
      if (_savedItem == null) {
        await _repository.save(contentId);
      } else {
        await _repository.remove(contentId);
      }
    } catch (error) {
      _error = error;
    } finally {
      _isMutating = false;
      _notify();
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

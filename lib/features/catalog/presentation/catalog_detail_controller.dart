import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';

class CatalogDetailController extends ChangeNotifier {
  CatalogDetailController(this._repository, this._contentId, this._locale);

  final CatalogRepository _repository;
  final String _contentId;
  LocaleCode _locale;
  CatalogDetail? _detail;
  bool _isLoading = false;
  bool _notFound = false;
  Object? _error;
  int _requestSerial = 0;

  String get contentId => _contentId;
  LocaleCode get locale => _locale;
  CatalogDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  bool get notFound => _notFound;
  Object? get error => _error;

  Future<void> load() => _load();
  Future<void> retry() => _load();

  void setLocale(LocaleCode locale) {
    if (_locale == locale) return;
    _locale = locale;
    unawaited(_load());
  }

  Future<void> _load() async {
    final serial = ++_requestSerial;
    _isLoading = true;
    _error = null;
    _notFound = false;
    _detail = null;
    notifyListeners();
    try {
      final result = await _repository.getPublishedDetailById(
        _contentId,
        locale: _locale,
      );
      if (serial != _requestSerial) return;
      _detail = result;
      _notFound = result == null;
    } catch (error) {
      if (serial != _requestSerial) return;
      _error = error;
      _detail = null;
    } finally {
      if (serial == _requestSerial) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}

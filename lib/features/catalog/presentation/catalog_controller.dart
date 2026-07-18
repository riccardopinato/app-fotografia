import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';

const catalogPageSize = 6;
const catalogSearchDebounce = Duration(milliseconds: 300);

class CatalogController extends ChangeNotifier {
  CatalogController(
    this._repository,
    this._locale, {
    this._debounce = catalogSearchDebounce,
    this._pageSize = catalogPageSize,
  });

  final CatalogRepository _repository;
  final Duration _debounce;
  final int _pageSize;

  LocaleCode _locale;
  String _query = '';
  CatalogFilter _filter = const CatalogFilter();
  List<LocalizedContent> _items = const [];
  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  Object? _initialError;
  Object? _nextPageError;
  int _requestSerial = 0;
  Timer? _debounceTimer;

  LocaleCode get locale => _locale;
  String get query => _query;
  CatalogFilter get filter => _filter;
  List<LocalizedContent> get items => _items;
  bool get isInitialLoading => _isInitialLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  Object? get initialError => _initialError;
  Object? get nextPageError => _nextPageError;
  int get activeFilterCount => [
    _filter.type,
    _filter.category,
    _filter.difficulty,
    _filter.premium,
    _filter.tagCode,
  ].where((value) => value != null).length;

  bool get hasActiveFilters => activeFilterCount > 0;
  bool get isEmpty =>
      !_isInitialLoading && _initialError == null && _items.isEmpty;

  Future<void> loadInitial() => _load(reset: true);

  void setLocale(LocaleCode locale) {
    if (_locale == locale) return;
    _locale = locale;
    unawaited(_load(reset: true));
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => _load(reset: true));
    notifyListeners();
  }

  void clearQuery() => setQuery('');

  void setFilter(CatalogFilter filter) {
    if (_sameFilter(_filter, filter)) return;
    _filter = filter;
    unawaited(_load(reset: true));
    notifyListeners();
  }

  void clearFilters() => setFilter(const CatalogFilter());

  void removeFilter(String key) {
    setFilter(
      CatalogFilter(
        type: key == 'type' ? null : _filter.type,
        category: key == 'category' ? null : _filter.category,
        difficulty: key == 'difficulty' ? null : _filter.difficulty,
        premium: key == 'premium' ? null : _filter.premium,
        tagCode: key == 'tag' ? null : _filter.tagCode,
      ),
    );
  }

  Future<void> loadNextPage() {
    if (!_hasMore || _isInitialLoading || _isLoadingMore) return Future.value();
    return _load(reset: false);
  }

  Future<void> retryInitial() => _load(reset: true);
  Future<void> retryNextPage() => _load(reset: false);
  Future<void> refresh() => _load(reset: true);

  Future<void> _load({required bool reset}) async {
    if (!reset && _isLoadingMore) return;
    final serial = ++_requestSerial;
    if (reset) {
      _isInitialLoading = true;
      _initialError = null;
      _nextPageError = null;
      _hasMore = false;
    } else {
      _isLoadingMore = true;
      _nextPageError = null;
    }
    notifyListeners();

    try {
      final page = await _repository.getPage(
        locale: _locale,
        query: _query,
        filter: _filter,
        limit: _pageSize,
        offset: reset ? 0 : _items.length,
      );
      if (serial != _requestSerial) return;
      final merged = reset ? page.items : [..._items, ...page.items];
      final seen = <String>{};
      _items = [
        for (final item in merged)
          if (seen.add(item.item.id)) item,
      ];
      _hasMore = page.hasMore;
    } catch (error) {
      if (serial != _requestSerial) return;
      if (reset) {
        _items = const [];
        _initialError = error;
      } else {
        _nextPageError = error;
      }
    } finally {
      if (serial == _requestSerial) {
        _isInitialLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  bool _sameFilter(CatalogFilter a, CatalogFilter b) =>
      a.type == b.type &&
      a.category == b.category &&
      a.difficulty == b.difficulty &&
      a.premium == b.premium &&
      a.tagCode == b.tagCode;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

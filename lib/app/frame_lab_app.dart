import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';
import '../core/database/app_database.dart'
    hide Collection, SavedItem, UserProfile;
import '../features/catalog/data/drift_catalog_repository.dart';
import '../features/catalog/data/seed/catalog_seed.dart';
import '../features/catalog/domain/catalog_models.dart';
import '../features/catalog/domain/catalog_repository.dart';
import '../features/catalog/presentation/catalog_scope.dart';
import '../features/library/data/drift_library_repository.dart';
import '../features/library/domain/library_models.dart';
import '../features/library/domain/library_repository.dart';
import '../features/library/presentation/library_scope.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/profile/data/drift_profile_repository.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/profile/domain/user_profile.dart';
import '../features/profile/presentation/profile_scope.dart';
import 'router/app_router.dart';
import 'theme/frame_lab_theme.dart';

class FrameLabApp extends StatefulWidget {
  const FrameLabApp({this.locale, this.profileRepository, super.key});

  final Locale? locale;
  final ProfileRepository? profileRepository;

  @override
  State<FrameLabApp> createState() => _FrameLabAppState();
}

class _FrameLabAppState extends State<FrameLabApp> {
  late final AppDatabase? _database;
  late final ProfileRepository _repository;
  late final CatalogRepository _catalogRepository;
  late final LibraryRepository _libraryRepository;
  late final Stream<UserProfile?> _profileStream;

  @override
  void initState() {
    super.initState();
    if (widget.profileRepository == null) {
      final database = AppDatabase();
      _database = database;
      _repository = DriftProfileRepository(database);
      final driftCatalogRepository = DriftCatalogRepository(database);
      _catalogRepository = _SeededCatalogRepository(
        driftCatalogRepository,
        CatalogSeedInstaller(database).install(),
      );
      _libraryRepository = DriftLibraryRepository(database);
    } else {
      _database = null;
      _repository = widget.profileRepository!;
      _catalogRepository = _EmptyCatalogRepository();
      _libraryRepository = _EmptyLibraryRepository();
    }
    _profileStream = _repository.watch();
  }

  @override
  void dispose() {
    unawaited(_database?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: _profileStream,
      builder: (context, snapshot) => MaterialApp.router(
        title: 'FrameLab',
        debugShowCheckedModeBanner: false,
        theme: FrameLabTheme.light,
        darkTheme: FrameLabTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        locale: _selectedLocale(snapshot.data),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => CatalogScope(
          repository: _catalogRepository,
          child: LibraryScope(
            repository: _libraryRepository,
            child: ProfileScope(
              repository: _repository,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : snapshot.data == null
                  ? OnboardingPage(repository: _repository)
                  : child!,
            ),
          ),
        ),
      ),
    );
  }

  Locale? _selectedLocale(UserProfile? profile) {
    if (widget.locale != null) return widget.locale;
    if (profile?.languageMode != LanguageMode.manual ||
        profile?.selectedLocale == null) {
      return null;
    }
    final code = profile!.selectedLocale!.value.split('-');
    return Locale(code.first, code.length > 1 ? code.last : null);
  }
}

class _EmptyLibraryRepository implements LibraryRepository {
  @override
  Future<void> assignCollection(String contentId, String? collectionId) async {}
  @override
  Future<Collection> createCollection(String name) =>
      throw UnsupportedError('Library is unavailable');
  @override
  Future<void> deleteCollection(String id) async {}
  @override
  Future<List<SavedItem>> getSavedItems({
    SavedItemStatus? status,
    String? collectionId,
  }) async => const [];
  @override
  Future<void> remove(String contentId) async {}
  @override
  Future<void> renameCollection(String id, String name) async {}
  @override
  Future<SavedItem> save(String contentId, {String? collectionId}) =>
      throw UnsupportedError('Library is unavailable');
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
  Stream<List<CollectionWithCount>> watchCollections() =>
      Stream.value(const []);
  @override
  Stream<SavedItem?> watchSavedItem(String contentId) => Stream.value(null);
  @override
  Stream<List<SavedItem>> watchSavedItems() => Stream.value(const []);
}

class _EmptyCatalogRepository implements CatalogRepository {
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
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) async => null;

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => const Stream.empty();
}

class _SeededCatalogRepository implements CatalogRepository {
  _SeededCatalogRepository(this._delegate, this._seedReady);

  final CatalogRepository _delegate;
  final Future<void> _seedReady;

  Future<T> _afterSeed<T>(Future<T> Function() action) async {
    await _seedReady;
    return action();
  }

  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) => _afterSeed(
    () => _delegate.getPage(
      locale: locale,
      query: query,
      filter: filter,
      limit: limit,
      offset: offset,
    ),
  );

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) =>
      _afterSeed(() => _delegate.getPublished(locale: locale, filter: filter));

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) => _afterSeed(() => _delegate.getPublishedById(id, locale: locale));

  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) => _afterSeed(() => _delegate.getPublishedDetailById(id, locale: locale));

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async* {
    await _seedReady;
    yield* _delegate.watchPublished(locale: locale, filter: filter);
  }
}

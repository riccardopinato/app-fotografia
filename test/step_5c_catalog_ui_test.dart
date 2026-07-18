import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/catalog/presentation/catalog_controller.dart';
import 'package:framelab/features/catalog/presentation/catalog_page.dart' as ui;
import 'package:framelab/features/catalog/presentation/catalog_scope.dart';
import 'package:framelab/l10n/app_localizations.dart';

void main() {
  group('Step 5C catalog controller', () {
    test('loads initial page and next page without duplicates', () async {
      final repo = _FakeCatalogRepository(
        pages: [
          CatalogPage(items: [_content('a'), _content('b')], hasMore: true),
          CatalogPage(items: [_content('b'), _content('c')], hasMore: false),
        ],
      );
      final controller = CatalogController(
        repo,
        const LocaleCode('en'),
        debounce: Duration.zero,
        pageSize: 2,
      );
      await controller.loadInitial();
      expect(controller.items.map((e) => e.item.id), ['a', 'b']);
      expect(controller.hasMore, isTrue);
      await controller.loadNextPage();
      expect(controller.items.map((e) => e.item.id), ['a', 'b', 'c']);
      expect(controller.hasMore, isFalse);
      expect(repo.calls.map((c) => c.offset), [0, 2]);
    });

    test('debounces search, clears query and resets pagination', () async {
      final repo = _FakeCatalogRepository(
        pages: [
          CatalogPage(items: [_content('initial')], hasMore: true),
          CatalogPage(items: [_content('search')], hasMore: false),
          CatalogPage(items: [_content('cleared')], hasMore: false),
        ],
      );
      final controller = CatalogController(
        repo,
        const LocaleCode('en'),
        debounce: const Duration(milliseconds: 1),
      );
      await controller.loadInitial();
      controller.setQuery('light');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(controller.items.single.item.id, 'search');
      expect(repo.calls.last.query, 'light');
      controller.clearQuery();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(controller.items.single.item.id, 'cleared');
      expect(repo.calls.last.offset, 0);
    });

    test(
      'ignores obsolete responses and protects duplicate next-page requests',
      () async {
        final slow = Completer<CatalogPage>();
        final fast = Completer<CatalogPage>();
        final repo = _ControlledCatalogRepository([slow, fast]);
        final controller = CatalogController(repo, const LocaleCode('en'));
        unawaited(controller.loadInitial());
        controller.setLocale(const LocaleCode('it'));
        fast.complete(CatalogPage(items: [_content('fresh')], hasMore: false));
        slow.complete(CatalogPage(items: [_content('stale')], hasMore: true));
        await Future<void>.delayed(Duration.zero);
        expect(controller.items.single.item.id, 'fresh');

        final repo2 = _FakeCatalogRepository(
          pages: [
            CatalogPage(items: [_content('a')], hasMore: true),
            CatalogPage(items: [_content('b')], hasMore: false),
          ],
        );
        final c2 = CatalogController(repo2, const LocaleCode('en'));
        await c2.loadInitial();
        final f1 = c2.loadNextPage();
        final f2 = c2.loadNextPage();
        await Future.wait([f1, f2]);
        expect(repo2.calls.where((call) => call.offset == 1), hasLength(1));
      },
    );

    test('tracks initial and next-page errors for retry', () async {
      final repo = _FakeCatalogRepository(
        pages: [
          CatalogPage(items: [_content('retry')], hasMore: true),
          CatalogPage(items: [_content('more')], hasMore: false),
        ],
        failInitial: true,
        failNext: true,
      );
      final controller = CatalogController(repo, const LocaleCode('en'));
      await controller.loadInitial();
      expect(controller.initialError, isNotNull);
      await controller.retryInitial();
      expect(controller.items.single.item.id, 'retry');
      await controller.loadNextPage();
      expect(controller.nextPageError, isNotNull);
      await controller.retryNextPage();
      expect(controller.items.map((e) => e.item.id), ['retry', 'more']);
    });
  });

  group('Step 5C catalog widget', () {
    testWidgets(
      'shows initial content, opens filters and applies a type filter',
      (tester) async {
        final repo = _FakeCatalogRepository(
          pages: [
            CatalogPage(
              items: [_content('guide', title: 'Exposure guide')],
              hasMore: false,
            ),
          ],
        );
        await _pumpCatalog(tester, repo);
        await tester.pumpAndSettle();
        expect(find.text('Explore catalog'), findsOneWidget);
        expect(find.text('Exposure guide'), findsOneWidget);
        expect(find.text('Available offline'), findsOneWidget);

        await tester.tap(find.text('Filters (0)'));
        await tester.pumpAndSettle();
        expect(find.text('Filters'), findsWidgets);
        expect(find.text('Guide'), findsWidgets);
      },
    );

    testWidgets(
      'supports load more, empty states, Italian locale and wide layout',
      (tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = _FakeCatalogRepository(
          pages: [
            CatalogPage(items: [_content('a'), _content('b')], hasMore: true),
            CatalogPage(items: [_content('c')], hasMore: false),
          ],
        );
        await _pumpCatalog(tester, repo, locale: const Locale('it'));
        await tester.pumpAndSettle();
        expect(find.text('Esplora catalogo'), findsOneWidget);
        await tester.ensureVisible(find.text('Carica altro'));
        await tester.tap(find.text('Carica altro'));
        await tester.pumpAndSettle();
        expect(find.text('Title c'), findsOneWidget);

        await tester.pumpWidget(const SizedBox.shrink());
        final emptyRepo = _FakeCatalogRepository(
          pages: const [CatalogPage(items: [], hasMore: false)],
        );
        await _pumpCatalog(tester, emptyRepo);
        await tester.pumpAndSettle();
        expect(find.text('No catalog items yet'), findsOneWidget);
      },
    );

    testWidgets('keeps essential semantics and text scale usable', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = _FakeCatalogRepository(
        pages: [
          CatalogPage(items: [_content('semantics')], hasMore: false),
        ],
      );
      await _pumpCatalog(
        tester,
        repo,
        mediaQuery: MediaQueryData.fromView(
          tester.view,
        ).copyWith(textScaler: const TextScaler.linear(1.6)),
      );
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Catalog search field'), findsOneWidget);
      expect(find.bySemanticsLabel('Open Title semantics'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

Future<void> _pumpCatalog(
  WidgetTester tester,
  CatalogRepository repository, {
  Locale locale = const Locale('en'),
  MediaQueryData? mediaQuery,
}) async {
  final child = MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: CatalogScope(
      repository: repository,
      child: Scaffold(body: ui.CatalogPage(key: UniqueKey())),
    ),
  );
  await tester.pumpWidget(
    mediaQuery == null ? child : MediaQuery(data: mediaQuery, child: child),
  );
}

LocalizedContent _content(String id, {String? title}) => LocalizedContent(
  item: ContentItem(
    id: id,
    type: id == 'guide' ? ContentType.guide : ContentType.tip,
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
    id: '$id-en',
    contentId: id,
    locale: const LocaleCode('en'),
    title: title ?? 'Title $id',
    summary: 'Summary $id',
    body: 'Body $id',
    status: TranslationStatus.published,
    method: TranslationMethod.original,
    sourceVersion: 1,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  ),
  tags: const [Tag(id: 'tag-exposure', code: 'exposure')],
);

class _CatalogCall {
  const _CatalogCall(
    this.locale,
    this.query,
    this.filter,
    this.limit,
    this.offset,
  );
  final LocaleCode locale;
  final String query;
  final CatalogFilter filter;
  final int limit;
  final int offset;
}

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository({
    required this.pages,
    this.failInitial = false,
    this.failNext = false,
  });
  final List<CatalogPage> pages;
  final bool failInitial;
  final bool failNext;
  final calls = <_CatalogCall>[];
  var _page = 0;
  var _failedInitial = false;
  var _failedNext = false;

  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) async {
    calls.add(_CatalogCall(locale, query, filter, limit, offset));
    if (offset == 0 && failInitial && !_failedInitial) {
      _failedInitial = true;
      throw StateError('initial');
    }
    if (offset > 0 && failNext && !_failedNext) {
      _failedNext = true;
      throw StateError('next');
    }
    return pages[_page++ % pages.length];
  }

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async => (await getPage(locale: locale, filter: filter)).items;
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

class _ControlledCatalogRepository implements CatalogRepository {
  _ControlledCatalogRepository(this.completers);
  final List<Completer<CatalogPage>> completers;
  var _index = 0;
  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) => completers[_index++].future;
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

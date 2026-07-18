import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:framelab/app/router/app_routes.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/catalog/domain/catalog_repository.dart';
import 'package:framelab/features/catalog/presentation/catalog_detail_controller.dart';
import 'package:framelab/features/catalog/presentation/catalog_detail_page.dart';
import 'package:framelab/features/catalog/presentation/catalog_page.dart' as ui;
import 'package:framelab/features/catalog/presentation/catalog_scope.dart';
import 'package:framelab/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'opens detail from Explore card through named GoRouter route and preserves catalog state',
    (tester) async {
      final repo = _FakeDetailRepository();
      await _pumpRouter(tester, repo);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'exposure');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.tap(find.bySemanticsLabel('Open Detail title'));
      await tester.pumpAndSettle();
      expect(find.text('Content detail'), findsOneWidget);
      expect(find.text('Detail title'), findsWidgets);
      expect(repo.detailIds, ['detail']);
      expect(find.textContaining('CC-BY-4.0'), findsWidgets);
      expect(find.text('Premium'), findsWidgets);
      await tester.tap(find.byTooltip('Back to catalog'));
      await tester.pumpAndSettle();
      expect(find.text('Explore catalog'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'exposure'), findsOneWidget);
    },
  );

  testWidgets(
    'supports direct deep link, localized tags, multiple sources and wide text scale',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = _FakeDetailRepository();
      await _pumpRouter(
        tester,
        repo,
        initialLocation: '/explore/content/detail',
        locale: const Locale('it'),
        textScale: 1.5,
      );
      await tester.pumpAndSettle();
      expect(find.text('Dettaglio contenuto'), findsOneWidget);
      expect(find.text('Etichetta localizzata'), findsOneWidget);
      expect(find.text('Second source'), findsOneWidget);
      expect(find.textContaining('Attribuzione:'), findsWidgets);
      expect(find.textContaining('Licenza:'), findsWidgets);
      await tester.tap(find.byTooltip('Torna al catalogo'));
      await tester.pumpAndSettle();
      expect(find.text('Esplora catalogo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('shows unavailable for missing and non-publishable content', (
    tester,
  ) async {
    final repo = _FakeDetailRepository(
      notFound: {'missing', 'draft', 'restricted', 'unlicensed'},
    );
    for (final id in ['missing', 'draft', 'restricted', 'unlicensed']) {
      await _pumpRouter(tester, repo, initialLocation: '/explore/content/$id');
      await tester.pumpAndSettle();
      expect(find.text('Content unavailable'), findsOneWidget);
    }
  });

  testWidgets('shows repository error and retries', (tester) async {
    final repo = _FakeDetailRepository(failFirstDetail: true);
    await _pumpRouter(tester, repo, initialLocation: '/explore/content/detail');
    await tester.pumpAndSettle();
    expect(find.text('Detail unavailable'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Detail title'), findsWidgets);
  });

  testWidgets(
    'shows localized German UI and omits Premium badge for free content',
    (tester) async {
      final repo = _FakeDetailRepository();
      await _pumpRouter(
        tester,
        repo,
        initialLocation: '/explore/content/free',
        locale: const Locale('de'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Inhaltsdetails'), findsOneWidget);
      expect(find.text('Detail title'), findsWidgets);
      expect(find.text('Premium'), findsNothing);
      expect(repo.detailIds, contains('free'));
    },
  );

  test(
    'detail controller ignores stale responses on locale change and supports fallback-shaped data',
    () async {
      final slow = Completer<CatalogDetail?>();
      final fast = Completer<CatalogDetail?>();
      final repo = _ControlledDetailRepository([slow, fast]);
      final controller = CatalogDetailController(
        repo,
        'detail',
        const LocaleCode('pt-BR'),
      );
      unawaited(controller.load());
      controller.setLocale(const LocaleCode('de'));
      fast.complete(_detail(locale: const LocaleCode('de'), title: 'Deutsch'));
      slow.complete(
        _detail(locale: const LocaleCode('pt'), title: 'Português'),
      );
      await Future<void>.delayed(Duration.zero);
      expect(controller.detail!.content.translation.locale.value, 'de');
      expect(controller.detail!.content.translation.title, 'Deutsch');
    },
  );
}

Future<void> _pumpRouter(
  WidgetTester tester,
  CatalogRepository repo, {
  String initialLocation = '/explore',
  Locale locale = const Locale('en'),
  double textScale = 1,
}) async {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/explore',
        name: AppDestination.explore.routeName,
        builder: (context, state) => const Scaffold(body: ui.CatalogPage()),
        routes: [
          GoRoute(
            path: 'content/:contentId',
            name: AppRoutes.exploreContentName,
            builder: (context, state) =>
                CatalogDetailPage(contentId: state.pathParameters['contentId']),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: MaterialApp.router(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) =>
            CatalogScope(repository: repo, child: child!),
      ),
    ),
  );
}

CatalogDetail _detail({
  LocaleCode locale = const LocaleCode('en'),
  String title = 'Detail title',
  bool premium = true,
}) => CatalogDetail(
  content: LocalizedContent(
    item: ContentItem(
      id: 'detail',
      type: ContentType.guide,
      primaryCategory: 'exposure',
      difficulty: Difficulty.beginner,
      premium: premium,
      canonicalLocale: const LocaleCode('en'),
      editorialStatus: EditorialStatus.published,
      version: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    translation: ContentTranslation(
      id: 'detail-${locale.value}',
      contentId: 'detail',
      locale: locale,
      title: title,
      summary: 'Detail summary',
      body: 'Complete detail body',
      status: TranslationStatus.published,
      method: TranslationMethod.machine,
      sourceVersion: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    tags: const [Tag(id: 'tag-exposure', code: 'exposure')],
  ),
  tags: const [
    LocalizedTag(
      id: 'tag-exposure',
      code: 'exposure',
      label: 'Etichetta localizzata',
    ),
  ],
  sources: [
    ContentSource(
      id: 's1',
      title: 'Primary source',
      author: 'Author',
      originalLocale: const LocaleCode('en'),
      licenseType: 'CC-BY-4.0',
      attributionText: 'FrameLab',
      rightsStatus: RightsStatus.publishable,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    ContentSource(
      id: 's2',
      title: 'Second source',
      originalLocale: const LocaleCode('en'),
      licenseType: 'CC-BY-4.0',
      rightsStatus: RightsStatus.publishable,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
  ],
);

class _FakeDetailRepository implements CatalogRepository {
  _FakeDetailRepository({
    this.failFirstDetail = false,
    this.notFound = const {},
  });
  final bool failFirstDetail;
  final Set<String> notFound;
  final detailIds = <String>[];
  var _failed = false;

  @override
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  }) async => CatalogPage(items: [(_detail().content)], hasMore: false);

  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) async {
    detailIds.add(id);
    if (failFirstDetail && !_failed) {
      _failed = true;
      throw StateError('detail');
    }
    if (notFound.contains(id)) return null;
    return _detail(locale: locale, premium: id != 'free');
  }

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async => [(_detail().content)];
  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) async => _detail().content;
  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => const Stream.empty();
}

class _ControlledDetailRepository implements CatalogRepository {
  _ControlledDetailRepository(this.completers);
  final List<Completer<CatalogDetail?>> completers;
  var _index = 0;
  @override
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  }) => completers[_index++].future;
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
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => const Stream.empty();
}

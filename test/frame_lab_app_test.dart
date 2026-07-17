import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:framelab/app/frame_lab_app.dart';
import 'package:framelab/app/router/app_router.dart';
import 'package:framelab/app/router/app_routes.dart';
import 'package:framelab/l10n/app_localizations.dart';

void main() {
  setUp(() => appRouter.go(AppDestination.home.path));

  testWidgets('starts with the localized Home placeholder', (tester) async {
    await tester.pumpWidget(const FrameLabApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsAtLeastNWidgets(1));
    expect(find.text('Your photography space is taking shape'), findsOneWidget);
  });

  testWidgets('shows and navigates between all five destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const FrameLabApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(5));

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Explore is coming soon'), findsOneWidget);

    await tester.tap(find.text('Ideas'));
    await tester.pumpAndSettle();
    expect(find.text('Ideas are coming soon'), findsOneWidget);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Your library is coming soon'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your profile is coming soon'), findsOneWidget);
  });

  testWidgets('uses the dark theme when the system requests it', (
    tester,
  ) async {
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.view.platformDispatcher.clearPlatformBrightnessTestValue,
    );

    await tester.pumpWidget(const FrameLabApp());
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('uses a navigation rail on wide layouts', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FrameLabApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('loads Italian strings without overflowing at large text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData.fromView(
          tester.view,
        ).copyWith(textScaler: const TextScaler.linear(2)),
        child: const FrameLabApp(locale: Locale('it')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Esplora'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('supports the planned locales', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const [
        Locale('en'),
        Locale('it'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('pt', 'BR'),
      ]),
    );
  });
}

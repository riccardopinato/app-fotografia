import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:framelab/app/frame_lab_app.dart';
import 'package:framelab/app/router/app_router.dart';
import 'package:framelab/app/router/app_routes.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/profile/domain/profile_repository.dart';
import 'package:framelab/features/profile/domain/user_profile.dart';
import 'package:framelab/features/profile/presentation/profile_editor.dart';
import 'package:framelab/l10n/app_localizations.dart';

void main() {
  setUp(() => appRouter.go(AppDestination.home.path));

  testWidgets('starts with the localized Home placeholder', (tester) async {
    await tester.pumpWidget(
      FrameLabApp(profileRepository: _ProfileRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsAtLeastNWidgets(1));
    expect(find.text('Your photography space is taking shape'), findsOneWidget);
  });

  testWidgets('shows onboarding before a local profile exists', (tester) async {
    await tester.pumpWidget(
      FrameLabApp(profileRepository: _EmptyProfileRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set up your photography profile'), findsOneWidget);
  });

  testWidgets(
    'waits for the profile stream before deciding to show onboarding',
    (tester) async {
      final repository = _ControlledProfileRepository();
      addTearDown(repository.dispose);
      await tester.pumpWidget(FrameLabApp(profileRepository: repository));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Set up your photography profile'), findsNothing);

      repository.emit(null);
      await tester.pumpAndSettle();
      expect(find.text('Set up your photography profile'), findsOneWidget);
    },
  );

  testWidgets('uses a saved manual locale and returns to the device locale', (
    tester,
  ) async {
    final repository = _ControlledProfileRepository();
    addTearDown(repository.dispose);
    await tester.pumpWidget(FrameLabApp(profileRepository: repository));
    repository.emit(_profile(languageMode: LanguageMode.manual, locale: 'it'));
    await tester.pumpAndSettle();
    expect(find.text('Esplora'), findsOneWidget);

    repository.emit(_profile(languageMode: LanguageMode.device));
    await tester.pumpAndSettle();
    expect(find.text('Explore'), findsOneWidget);
  });

  testWidgets('keeps the editor usable and reports a failed atomic save', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProfileEditor(
            profile: _profile(),
            onSave: (_) async => throw StateError('database unavailable'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final save = find.ancestor(
      of: find.text('Save changes'),
      matching: find.byType(FilledButton),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(
      find.text('Your preferences could not be saved. Try again.'),
      findsOneWidget,
    );
  });

  testWidgets('shows and navigates between all five destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      FrameLabApp(profileRepository: _ProfileRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(5));

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Explore catalog'), findsOneWidget);

    await tester.tap(find.text('Ideas'));
    await tester.pumpAndSettle();
    expect(find.text('Ideas are coming soon'), findsOneWidget);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Your library is coming soon'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your profile'), findsOneWidget);
  });

  testWidgets('uses the dark theme when the system requests it', (
    tester,
  ) async {
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.view.platformDispatcher.clearPlatformBrightnessTestValue,
    );

    await tester.pumpWidget(
      FrameLabApp(profileRepository: _ProfileRepository()),
    );
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

    await tester.pumpWidget(
      FrameLabApp(profileRepository: _ProfileRepository()),
    );
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
        child: FrameLabApp(
          locale: const Locale('it'),
          profileRepository: _ProfileRepository(),
        ),
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

class _ProfileRepository implements ProfileRepository {
  final UserProfile _profile = UserProfile(
    id: 'profile',
    skillLevel: SkillLevel.beginner,
    languageMode: LanguageMode.device,
    themePreference: ThemePreference.system,
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  );
  @override
  Future<UserProfile?> get() async => _profile;
  @override
  Future<void> save(UserProfile profile) async {}
  @override
  Stream<UserProfile?> watch() => Stream.value(_profile);
}

class _EmptyProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile?> get() async => null;
  @override
  Future<void> save(UserProfile profile) async {}
  @override
  Stream<UserProfile?> watch() => Stream.value(null);
}

UserProfile _profile({
  LanguageMode languageMode = LanguageMode.device,
  String? locale,
}) => UserProfile(
  id: 'profile',
  skillLevel: SkillLevel.beginner,
  languageMode: languageMode,
  selectedLocale: locale == null ? null : LocaleCode(locale),
  themePreference: ThemePreference.system,
  createdAt: DateTime.utc(2025),
  updatedAt: DateTime.utc(2025),
);

class _ControlledProfileRepository implements ProfileRepository {
  final _controller = StreamController<UserProfile?>.broadcast();

  void emit(UserProfile? profile) => _controller.add(profile);
  Future<void> dispose() => _controller.close();

  @override
  Future<UserProfile?> get() async => null;

  @override
  Future<void> save(UserProfile profile) async => emit(profile);

  @override
  Stream<UserProfile?> watch() => _controller.stream;
}

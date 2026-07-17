import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';
import '../core/database/app_database.dart' hide UserProfile;
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

  @override
  void initState() {
    super.initState();
    _database = widget.profileRepository == null ? AppDatabase() : null;
    _repository =
        widget.profileRepository ?? DriftProfileRepository(_database!);
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: _repository.watch(),
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
        builder: (context, child) => ProfileScope(
          repository: _repository,
          child: snapshot.connectionState == ConnectionState.waiting
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : snapshot.data == null
              ? OnboardingPage(repository: _repository)
              : child!,
        ),
      ),
    );
  }

  Locale? _selectedLocale(UserProfile? profile) {
    if (widget.locale != null) return widget.locale;
    if (profile?.languageMode != LanguageMode.manual) return null;
    final code = profile!.selectedLocale!.value.split('-');
    return Locale(code.first, code.length > 1 ? code.last : null);
  }
}

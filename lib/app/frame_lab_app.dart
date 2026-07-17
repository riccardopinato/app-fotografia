import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/frame_lab_theme.dart';

class FrameLabApp extends StatelessWidget {
  const FrameLabApp({this.locale, super.key});

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FrameLab',
      debugShowCheckedModeBanner: false,
      theme: FrameLabTheme.light,
      darkTheme: FrameLabTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

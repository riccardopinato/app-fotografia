import 'package:flutter/material.dart';

import '../../core/design/frame_lab_tokens.dart';

abstract final class FrameLabTheme {
  static final light = _build(Brightness.light);
  static final dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colors = FrameLabColors.scheme(brightness);
    final typography = FrameLabTypography.textTheme(colors.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      textTheme: typography,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: colors.surface,
        elevation: FrameLabElevation.none,
        scrolledUnderElevation: FrameLabElevation.none,
        titleTextStyle: typography.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainerLow,
        elevation: FrameLabElevation.card,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: FrameLabLayout.navigationBarHeight,
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        labelTextStyle: WidgetStatePropertyAll(typography.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        labelType: NavigationRailLabelType.all,
        useIndicator: true,
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
    );
  }
}

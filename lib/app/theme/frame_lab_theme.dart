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
          borderRadius: BorderRadius.circular(FrameLabRadii.container),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FrameLabSpacing.medium,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainerLow,
        selectedColor: colors.secondaryContainer,
        side: BorderSide(color: colors.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: typography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: FrameLabSpacing.xSmall),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            FrameLabLayout.minInteractiveSize,
            FrameLabLayout.minInteractiveSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FrameLabRadii.card),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            FrameLabLayout.minInteractiveSize,
            FrameLabLayout.minInteractiveSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FrameLabRadii.card),
          ),
          side: BorderSide(color: colors.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: FrameLabLayout.navigationBarHeight,
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        elevation: FrameLabElevation.none,
        surfaceTintColor: colors.surface,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FrameLabRadii.card),
        ),
        labelTextStyle: WidgetStatePropertyAll(typography.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        labelType: NavigationRailLabelType.all,
        useIndicator: true,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FrameLabRadii.container),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
    );
  }
}

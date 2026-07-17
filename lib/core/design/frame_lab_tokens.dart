import 'package:flutter/material.dart';

abstract final class FrameLabColors {
  static ColorScheme scheme(Brightness brightness) {
    return brightness == Brightness.light ? _light : _dark;
  }

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF386A5A),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFB9F0D4),
    onPrimaryContainer: Color(0xFF002116),
    secondary: Color(0xFF50655B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD3E8DA),
    onSecondaryContainer: Color(0xFF0E2118),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFF7F7F4),
    onSurface: Color(0xFF1A1C1B),
    surfaceContainerLow: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF424944),
    outline: Color(0xFF727973),
    outlineVariant: Color(0xFFC1C8C1),
  );

  static const _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8CC9B0),
    onPrimary: Color(0xFF003828),
    primaryContainer: Color(0xFF1F513E),
    onPrimaryContainer: Color(0xFFB9F0D4),
    secondary: Color(0xFFB7CCBD),
    onSecondary: Color(0xFF22382D),
    secondaryContainer: Color(0xFF394E43),
    onSecondaryContainer: Color(0xFFD3E8DA),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF121313),
    onSurface: Color(0xFFF2F1EC),
    surfaceContainerLow: Color(0xFF1B1D1C),
    onSurfaceVariant: Color(0xFFC1C8C1),
    outline: Color(0xFF8B938B),
    outlineVariant: Color(0xFF424944),
  );
}

abstract final class FrameLabTypography {
  static TextTheme textTheme(Color color) => TextTheme(
    headlineMedium: TextStyle(
      color: color,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    titleLarge: TextStyle(
      color: color,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: color, fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(color: color, fontSize: 14, height: 1.45),
    labelMedium: TextStyle(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );
}

abstract final class FrameLabSpacing {
  static const xSmall = 4.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const xLarge = 32.0;
  static const xxLarge = 48.0;
}

abstract final class FrameLabRadii {
  static const card = 12.0;
  static const container = 16.0;
}

abstract final class FrameLabElevation {
  static const none = 0.0;
  static const card = 1.0;
}

abstract final class FrameLabLayout {
  static const minInteractiveSize = 48.0;
  static const navigationBarHeight = 80.0;
  static const railBreakpoint = 840.0;
  static const contentMaxWidth = 560.0;
}

abstract final class FrameLabMotion {
  static const feedback = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 220);
  static const standardCurve = Curves.easeInOut;
}

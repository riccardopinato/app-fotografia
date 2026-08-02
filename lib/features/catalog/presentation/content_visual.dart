import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/catalog_models.dart';

/// A local, deterministic editorial cover used while photographic assets are
/// not yet part of the persisted catalog contract.
class ContentVisual extends StatelessWidget {
  const ContentVisual({
    required this.item,
    this.height = 144,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  final ContentItem item;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tone = _toneFor(item.primaryCategory);
    final background = brightness == Brightness.dark ? tone.dark : tone.light;
    final foreground = brightness == Brightness.dark
        ? tone.darkInk
        : tone.lightInk;

    return ExcludeSemantics(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: ColoredBox(
            color: background,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _EditorialPatternPainter(
                    color: foreground,
                    category: item.primaryCategory,
                  ),
                ),
                PositionedDirectional(
                  top: 18,
                  end: 18,
                  child: Icon(
                    _iconFor(item.type),
                    size: height * 0.32,
                    color: foreground.withAlpha(210),
                  ),
                ),
                PositionedDirectional(
                  start: 18,
                  bottom: 16,
                  child: Container(
                    width: 34,
                    height: 5,
                    decoration: BoxDecoration(
                      color: foreground,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorialPatternPainter extends CustomPainter {
  const _EditorialPatternPainter({required this.color, required this.category});

  final Color color;
  final String category;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withAlpha(42)
      ..strokeWidth = 1;
    for (final fraction in const [1 / 3, 2 / 3]) {
      canvas.drawLine(
        Offset(size.width * fraction, 0),
        Offset(size.width * fraction, size.height),
        grid,
      );
      canvas.drawLine(
        Offset(0, size.height * fraction),
        Offset(size.width, size.height * fraction),
        grid,
      );
    }

    final stroke = Paint()
      ..color = color.withAlpha(115)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2, size.shortestSide * 0.018);
    final fill = Paint()
      ..color = color.withAlpha(24)
      ..style = PaintingStyle.fill;

    switch (category) {
      case 'exposure':
      case 'light':
        final triangle = Path()
          ..moveTo(size.width * 0.17, size.height * 0.82)
          ..lineTo(size.width * 0.48, size.height * 0.18)
          ..lineTo(size.width * 0.72, size.height * 0.82)
          ..close();
        canvas.drawPath(triangle, fill);
        canvas.drawPath(triangle, stroke);
        break;
      case 'focus':
      case 'macro':
      case 'portrait':
        final center = Offset(size.width * 0.35, size.height * 0.54);
        for (final radius in [0.13, 0.25, 0.39]) {
          canvas.drawCircle(center, size.shortestSide * radius, stroke);
        }
        break;
      case 'motion':
      case 'urban':
        for (var index = -1; index < 4; index++) {
          final start = size.width * (index * 0.22);
          canvas.drawLine(
            Offset(start, size.height),
            Offset(start + size.width * 0.44, 0),
            stroke,
          );
        }
        break;
      case 'night':
        canvas.drawCircle(
          Offset(size.width * 0.32, size.height * 0.48),
          size.shortestSide * 0.3,
          fill,
        );
        canvas.drawCircle(
          Offset(size.width * 0.39, size.height * 0.4),
          size.shortestSide * 0.3,
          Paint()..color = color.withAlpha(50),
        );
        break;
      case 'composition':
      case 'workflow':
        final rect = Rect.fromLTWH(
          size.width * 0.12,
          size.height * 0.2,
          size.width * 0.5,
          size.height * 0.62,
        );
        canvas.drawRect(rect, stroke);
        canvas.drawRect(
          Rect.fromLTWH(
            size.width * 0.22,
            size.height * 0.32,
            size.width * 0.5,
            size.height * 0.5,
          ),
          stroke,
        );
        break;
      default:
        final wave = Path()..moveTo(0, size.height * 0.72);
        for (var index = 0; index <= 4; index++) {
          final x = size.width * index / 4;
          final y = size.height * (index.isEven ? 0.48 : 0.76);
          wave.lineTo(x, y);
        }
        canvas.drawPath(wave, stroke);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _EditorialPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.category != category;
}

IconData _iconFor(ContentType type) => switch (type) {
  ContentType.tip => Icons.lightbulb_outline_rounded,
  ContentType.technique => Icons.tune_rounded,
  ContentType.curiosity => Icons.visibility_outlined,
  ContentType.idea => Icons.camera_outlined,
  ContentType.commonMistake => Icons.report_gmailerrorred_rounded,
  ContentType.guide => Icons.menu_book_outlined,
  ContentType.checklist => Icons.checklist_rounded,
  ContentType.challenge => Icons.flag_outlined,
  ContentType.glossary => Icons.translate_rounded,
  ContentType.photographicHistory => Icons.history_edu_outlined,
};

_VisualTone _toneFor(String category) => switch (category) {
  'exposure' => const _VisualTone(
    light: Color(0xFFF2D7A7),
    lightInk: Color(0xFF5C3B08),
    dark: Color(0xFF4B3518),
    darkInk: Color(0xFFF3CD87),
  ),
  'light' => const _VisualTone(
    light: Color(0xFFD7E9DF),
    lightInk: Color(0xFF235846),
    dark: Color(0xFF203F35),
    darkInk: Color(0xFF9ED3BC),
  ),
  'composition' => const _VisualTone(
    light: Color(0xFFDCE4EB),
    lightInk: Color(0xFF304D63),
    dark: Color(0xFF263944),
    darkInk: Color(0xFFAFC8D7),
  ),
  'focus' || 'macro' => const _VisualTone(
    light: Color(0xFFE0DFC5),
    lightInk: Color(0xFF4E5221),
    dark: Color(0xFF383A21),
    darkInk: Color(0xFFD3D69B),
  ),
  'motion' || 'urban' => const _VisualTone(
    light: Color(0xFFE8D6CD),
    lightInk: Color(0xFF6A392A),
    dark: Color(0xFF493029),
    darkInk: Color(0xFFE1AF9C),
  ),
  'portrait' => const _VisualTone(
    light: Color(0xFFEAD8D9),
    lightInk: Color(0xFF633A40),
    dark: Color(0xFF493033),
    darkInk: Color(0xFFE4B1B7),
  ),
  'landscape' => const _VisualTone(
    light: Color(0xFFD8E2CE),
    lightInk: Color(0xFF38502B),
    dark: Color(0xFF2C3D27),
    darkInk: Color(0xFFB7CDA7),
  ),
  'night' => const _VisualTone(
    light: Color(0xFFD8D9EB),
    lightInk: Color(0xFF3E416E),
    dark: Color(0xFF2D304E),
    darkInk: Color(0xFFBFC2F0),
  ),
  'color' => const _VisualTone(
    light: Color(0xFFE8D7C7),
    lightInk: Color(0xFF684527),
    dark: Color(0xFF493629),
    darkInk: Color(0xFFE4BB91),
  ),
  _ => const _VisualTone(
    light: Color(0xFFDDE3DF),
    lightInk: Color(0xFF3C5148),
    dark: Color(0xFF2D3934),
    darkInk: Color(0xFFB7CBC1),
  ),
};

class _VisualTone {
  const _VisualTone({
    required this.light,
    required this.lightInk,
    required this.dark,
    required this.darkInk,
  });

  final Color light;
  final Color lightInk;
  final Color dark;
  final Color darkInk;
}

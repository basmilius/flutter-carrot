import 'dart:math' as math;
import 'dart:ui';

extension CarrotCanvasExtension on Canvas {
  void drawDashedLine(Offset p1, Offset p2, double width, double gutter, Paint paint) {
    final delta = p2 - p1;
    final angle = math.atan2(delta.dy, delta.dx);
    final length = math.sqrt(math.pow(delta.dx, 2) + math.pow(delta.dy, 2));

    double drawnLength = .0;
    final cos = math.cos(angle);
    final sin = math.sin(angle);

    while ((drawnLength + width) < length) {
      drawLine(
        Offset(p1.dx + cos * drawnLength, p1.dy + sin * drawnLength),
        Offset(p1.dx + cos * (drawnLength + width), p1.dy + sin * (drawnLength + width)),
        paint,
      );

      drawnLength += width + gutter;
    }
  }
}

final class CarrotPaintingSweepGradient extends Gradient {
  final Offset center;
  final List<Color> colors;
  final List<double> stops;
  final TileMode tileMode;
  final double startAngle;
  final double endAngle;

  CarrotPaintingSweepGradient({
    required this.center,
    required this.colors,
    required this.stops,
    required this.startAngle,
    required this.endAngle,
    this.tileMode = TileMode.clamp,
  }) : super.sweep(
          center,
          colors,
          stops,
          tileMode,
          startAngle,
          endAngle,
        );

  Color getColorAtPosition(double position) {
    for (int s = 0; s < stops.length - 1; ++s) {
      final stopBefore = stops[s], stopAfter = stops[s + 1];
      final colorBefore = colors[s], colorAfter = colors[s + 1];

      if (position <= stopBefore) {
        return colorBefore;
      }

      if (position < stopAfter) {
        final stopPosition = (position - stopBefore) / (stopAfter - stopBefore);
        return Color.lerp(colorBefore, colorAfter, stopPosition)!;
      }
    }

    return colors.last;
  }
}

import 'dart:ui';

class CarrotPaintingSweepGradient extends Gradient {
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

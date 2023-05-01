import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import '../utils/mulberry32.dart';
import './primitive/primitive.dart';

class CarrotAnimatedColors extends StatelessWidget {
  final List<CarrotColor> colors;
  final double opacity;
  final int seed;

  const CarrotAnimatedColors({
    super.key,
    this.colors = const [
      CarrotColors.blue,
      CarrotColors.fuchsia,
      CarrotColors.pink,
    ],
    this.opacity = .5,
    this.seed = 1,
  }) : assert(opacity >= 0);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        clipper: CarrotAnimatedColorsClipper(),
        child: CarrotContinuousAnimationBuilder(
          builder: (context, notifier) => CustomPaint(
            painter: CarrotAnimatedColorsPainter(
              colors: colors,
              opacity: opacity,
              seed: seed,
              repaint: notifier,
            ),
          ),
        ),
      ),
    );
  }
}

class CarrotAnimatedColorsClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CarrotAnimatedColorsClipper oldClipper) {
    return false;
  }
}

class CarrotAnimatedColorsPainter extends CustomPainter {
  final List<CarrotColor> colors;
  final double opacity;
  final int seed;

  final List<_Polygon> _polygons;
  int _tick = 0;

  CarrotAnimatedColorsPainter({
    required this.colors,
    required this.opacity,
    required this.seed,
    required super.repaint,
  }) : _polygons = _generatePolygons(colors, seed);

  @override
  void paint(Canvas canvas, Size size) {
    ++_tick;

    double widthBasedOpacity = opacity * math.min(1, math.max(.15, 360 / size.width));

    for (final polygon in _polygons) {
      canvas.save();
      canvas.translate(polygon.centerX * size.width, polygon.centerY * size.height);

      final path = Path();

      for (int i = 0; i < polygon.points.length; ++i) {
        final point = polygon.points[i];

        final x = math.cos(point.x * math.pi * 2 + _tick / (point.multiplier * 200 + 300)) * (size.width * .8);
        final y = math.sin(point.y * math.pi * 2 + _tick / (point.multiplier * 100 + 300)) * (size.height * .8);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      path.close();

      final paint = Paint()
        ..colorFilter = ColorFilter.matrix(_colorFilterSaturationMatrix(1.8))
        ..color = polygon.color.withOpacity(widthBasedOpacity)
        ..imageFilter = ImageFilter.blur(
          sigmaX: 60,
          sigmaY: 60,
        );

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CarrotAnimatedColorsPainter oldDelegate) {
    return false;
  }
}

class _Polygon {
  final double centerX;
  final double centerY;
  final CarrotColor color;
  final List<_PolygonPoint> points;

  const _Polygon({
    required this.centerX,
    required this.centerY,
    required this.color,
    required this.points,
  });
}

class _PolygonPoint {
  final double x;
  final double y;
  final double multiplier;

  const _PolygonPoint({
    required this.x,
    required this.y,
    required this.multiplier,
  });
}

List<double> _colorFilterSaturationMatrix(double value) {
  value = value * 100;

  if (value == 0) {
    return [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  var x = ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
  var lumR = 0.3086;
  var lumG = 0.6094;
  var lumB = 0.082;

  return List<double>.from(<double>[
    (lumR * (1 - x)) + x,
    lumG * (1 - x),
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    (lumG * (1 - x)) + x,
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    lumG * (1 - x),
    (lumB * (1 - x)) + x,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]).map((i) => i.toDouble()).toList();
}

List<_Polygon> _generatePolygons(List<CarrotColor> colors, int seed) {
  final mulberry = Mulberry32(seed: seed);
  final polygons = <_Polygon>[];

  for (final color in colors) {
    final localMulberry = mulberry.fork();

    final x = colors.length == 1 ? .5 : localMulberry.next();
    final y = colors.length == 1 ? .5 : localMulberry.next();
    final count = localMulberry.nextBetween(6, 9).toInt();
    final points = <_PolygonPoint>[];

    for (int p = 0; p < count; ++p) {
      points.add(_PolygonPoint(
        x: localMulberry.next(),
        y: localMulberry.next(),
        multiplier: localMulberry.next(),
      ));
    }

    polygons.add(_Polygon(
      centerX: x,
      centerY: y,
      color: color,
      points: points,
    ));
  }

  return polygons;
}

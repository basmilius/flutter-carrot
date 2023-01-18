import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'mark/mark.dart';
import 'range/range.dart';

abstract class CarrotChartPaintable {
  void layout(BuildContext context, CarrotChartPainter painter);

  void paint(BuildContext context, Canvas canvas, CarrotChartPainter painter);
}

class CarrotChartPainter extends CustomPainter {
  final BuildContext context;
  final List<CarrotChartMark<dynamic, dynamic>> marks;
  final List<CarrotChartPaintable> painters;
  final CarrotChartRanges ranges;

  late final List<CarrotChartRangeSegment<dynamic>> xSegments;

  late Rect availableArea;
  late Rect usableArea;

  CarrotChartPainter({
    required this.context,
    required this.marks,
    required this.painters,
    required this.ranges,
  });

  @override
  void paint(Canvas canvas, Size size) {
    availableArea = Offset.zero & size;
    usableArea = Offset.zero & size;

    for (var painter in painters) {
      painter.layout(context, this);
    }

    for (var painter in painters) {
      painter.paint(context, canvas, this);
    }

    for (int x = 0; x < ranges.segments.x.length; ++x) {
      final xSegment = ranges.segments.x[x];

      for (int y = 0; y < ranges.segments.y.length; ++y) {
        final ySegment = ranges.segments.y[y];

        final complied = marks.where((mark) {
          if (!xSegment.complies(mark.x!.value)) {
            return false;
          }

          if (!ySegment.complies(mark.y!.value)) {
            return false;
          }

          return true;
        });

        for (final mark in complied) {
          mark.paint(
            canvas,
            this,
            CarrotChartRangePositionedSegment(
              x: xSegment,
              y: ySegment,
              coords: math.Point(x, y),
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CarrotChartPainter oldDelegate) {
    return false;
  }
}

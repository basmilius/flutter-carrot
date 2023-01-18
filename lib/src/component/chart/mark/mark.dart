import 'dart:ui';

import '../../../ui/ui.dart';
import '../painting.dart';
import '../plottable_value.dart';
import '../range/range.dart';

part 'area_mark.dart';

part 'bar_mark.dart';

part 'line_mark.dart';

part 'point_mark.dart';

part 'rectangle_mark.dart';

part 'rule_mark.dart';

class CarrotChartMark<X, Y> {
  final double? height;
  final double? width;
  final CarrotChartPlottableValue<X>? x;
  final CarrotChartPlottableValue<X>? xEnd;
  final CarrotChartPlottableValue<X>? xStart;
  final CarrotChartPlottableValue<Y>? y;
  final CarrotChartPlottableValue<Y>? yEnd;
  final CarrotChartPlottableValue<Y>? yStart;
  final bool isPoint;
  final bool isRange;

  const CarrotChartMark.custom({
    this.height,
    this.width,
    this.x,
    this.xEnd,
    this.xStart,
    this.y,
    this.yEnd,
    this.yStart,
  })  : isPoint = false,
        isRange = false;

  const CarrotChartMark.range({
    required this.xEnd,
    required this.xStart,
    required this.yEnd,
    required this.yStart,
    this.height,
    this.width,
  })  : x = null,
        y = null,
        isRange = true,
        isPoint = false;

  const CarrotChartMark.value({
    required this.x,
    required this.y,
    this.height,
    this.width,
  })  : xEnd = null,
        xStart = null,
        yEnd = null,
        yStart = null,
        isRange = false,
        isPoint = true;

  void paint(Canvas canvas, CarrotChartPainter painter, CarrotChartRangePositionedSegment<X, Y> segments) {}

  static CarrotChartMark<RX, RY> lerp<RX, RY>(CarrotChartMark<RX, RY> a, CarrotChartMark<RX, RY> b, double t) {
    return CarrotChartMark.custom(
      height: lerpDouble(a.height, b.height, t),
      width: lerpDouble(a.width, b.width, t),
      x: CarrotChartPlottableValue.lerp(a.x, b.x, t),
      xEnd: CarrotChartPlottableValue.lerp(a.xEnd, b.xEnd, t),
      xStart: CarrotChartPlottableValue.lerp(a.xStart, b.xStart, t),
      y: CarrotChartPlottableValue.lerp(a.y, b.y, t),
      yEnd: CarrotChartPlottableValue.lerp(a.yEnd, b.yEnd, t),
      yStart: CarrotChartPlottableValue.lerp(a.yStart, b.yStart, t),
    );
  }
}

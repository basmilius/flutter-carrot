part of 'mark.dart';

class CarrotChartRectangleMark<X, Y> extends CarrotChartMark<X, Y> {
  const CarrotChartRectangleMark.range({
    required super.xEnd,
    required super.xStart,
    required super.yEnd,
    required super.yStart,
  }) : super.range();

  const CarrotChartRectangleMark.x({
    required super.yEnd,
    required super.yStart,
    required CarrotChartPlottableValue<X> x,
  }) : super.range(
          xEnd: x,
          xStart: x,
        );

  const CarrotChartRectangleMark.y({
    required super.xEnd,
    required super.xStart,
    required CarrotChartPlottableValue<Y> y,
  }) : super.range(
          yEnd: y,
          yStart: y,
        );
}

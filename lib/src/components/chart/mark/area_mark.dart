part of 'mark.dart';

class CarrotChartAreaMark<X, Y, S> extends CarrotChartMark<X, Y> {
  final CarrotChartPlottableValue<S>? series;

  const CarrotChartAreaMark.range({
    required super.xEnd,
    required super.xStart,
    required super.yEnd,
    required super.yStart,
    super.height,
    super.width,
  })  : series = null,
        super.range();

  const CarrotChartAreaMark.rangeSeries({
    required super.xEnd,
    required super.xStart,
    required super.yEnd,
    required super.yStart,
    required this.series,
    super.height,
    super.width,
  }) : super.range();

  const CarrotChartAreaMark.value({
    required super.x,
    required super.y,
  })  : series = null,
        super.value();

  const CarrotChartAreaMark.valueSeries({
    required super.x,
    required super.y,
    required this.series,
  }) : super.value();
}

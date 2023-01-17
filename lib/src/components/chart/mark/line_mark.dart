part of 'mark.dart';

class CarrotChartLineMark<X, Y, S> extends CarrotChartMark<X, Y> {
  final CarrotChartPlottableValue<S>? series;

  const CarrotChartLineMark.value({
    required super.x,
    required super.y,
  })  : series = null,
        super.value();

  const CarrotChartLineMark.valueSeries({
    required super.x,
    required super.y,
    required this.series,
  }) : super.value();
}

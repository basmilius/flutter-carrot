part of 'mark.dart';

class CarrotChartRuleMark<X, Y> extends CarrotChartMark<X, Y> {
  const CarrotChartRuleMark.horizontal({
    required super.y,
  }) : super.custom();

  const CarrotChartRuleMark.vertical({
    required super.x,
  }) : super.custom();

  const CarrotChartRuleMark.x({
    required super.yEnd,
    required super.yStart,
    required CarrotChartPlottableValue<X> x,
  }) : super.range(
    xEnd: x,
    xStart: x,
  );

  const CarrotChartRuleMark.y({
    required super.xEnd,
    required super.xStart,
    required CarrotChartPlottableValue<Y> y,
  }) : super.range(
    yEnd: y,
    yStart: y,
  );
}

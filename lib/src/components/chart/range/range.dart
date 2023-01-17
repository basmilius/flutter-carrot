import 'dart:math' as math;

part 'integer_range.dart';

part 'string_range.dart';

abstract class CarrotChartRange<V> {
  const CarrotChartRange();

  Iterable<CarrotChartRangeSegment<V>> getSegments();
}

abstract class CarrotChartIterableRange<V> extends CarrotChartRange<V> {
  final Iterable<V> values;

  const CarrotChartIterableRange({
    required this.values,
  });
}

abstract class CarrotChartSequenceRange<V extends num> extends CarrotChartRange<V> {
  final V lower;
  final V upper;

  const CarrotChartSequenceRange({
    required this.lower,
    required this.upper,
  });
}

class CarrotChartRangeSegment<V> {
  final V value;

  const CarrotChartRangeSegment({
    required this.value,
  });

  bool complies(V value) => value == this.value;

  @override
  String toString() {
    return '$value';
  }
}

class CarrotChartRangeSequenceSegment<V extends num> extends CarrotChartRangeSegment<V> {
  final V lower;
  final V upper;

  String get lowerText => '$lower';

  String get upperText => '$upper';

  const CarrotChartRangeSequenceSegment({
    required this.lower,
    required this.upper,
  }) : super(
          value: lower,
        );

  @override
  bool complies(V value) => lower <= value && value < upper;

  @override
  String toString() {
    return '$lower..<$upper';
  }
}

class CarrotChartRanges<X, Y> {
  final CarrotChartRange<X> x;
  final CarrotChartRange<Y> y;

  late final CarrotChartRangeSegments<X, Y> segments;

  CarrotChartRanges({
    required this.x,
    required this.y,
  }) : segments = CarrotChartRangeSegments(
          x: x.getSegments().toList(),
          y: y.getSegments().toList(),
        );
}

class CarrotChartRangeSegments<X, Y> {
  final List<CarrotChartRangeSegment<X>> x;
  final List<CarrotChartRangeSegment<Y>> y;

  const CarrotChartRangeSegments({
    required this.x,
    required this.y,
  });
}

class CarrotChartRangePositionedSegment<X, Y> {
  final CarrotChartRangeSegment<X> x;
  final CarrotChartRangeSegment<Y> y;
  final math.Point<int> coords;

  const CarrotChartRangePositionedSegment({
    required this.x,
    required this.y,
    required this.coords,
  });
}

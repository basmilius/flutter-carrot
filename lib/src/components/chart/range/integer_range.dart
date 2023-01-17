part of 'range.dart';

class CarrotChartIntegerRange extends CarrotChartSequenceRange<int> {
  static const _sizes = [1, 5, 10, 25, 50, 100, 250, 500, 1000];
  static const _target = 5;

  const CarrotChartIntegerRange({
    required super.lower,
    required super.upper,
  });

  @override
  Iterable<CarrotChartRangeIntegerSegment> getSegments() sync* {
    final delta = upper - lower;

    for (final size in _sizes) {
      final count = delta / size;

      if (count > _target) {
        continue;
      }

      for (int s = 0; s < count; ++s) {
        yield CarrotChartRangeIntegerSegment(
          lower: s * size,
          upper: s * size + size,
        );
      }

      return;
    }

    final digits = delta.toString().length - 1;
    final power = math.pow(10, digits).toInt();

    for (int s = 0; s < delta; s += power) {
      yield CarrotChartRangeIntegerSegment(
        lower: s,
        upper: s + power,
      );
    }
  }

  static CarrotChartIntegerRange parse(Set<int> values) => CarrotChartIntegerRange(
        lower: values.reduce(math.min),
        upper: values.reduce(math.max),
      );
}

class CarrotChartRangeIntegerSegment extends CarrotChartRangeSequenceSegment<int> {
  const CarrotChartRangeIntegerSegment({
    required super.lower,
    required super.upper,
  });
}

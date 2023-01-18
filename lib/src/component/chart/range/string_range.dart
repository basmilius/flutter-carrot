part of 'range.dart';

class CarrotChartStringRange extends CarrotChartIterableRange<String> {
  const CarrotChartStringRange({
    required super.values,
  });

  @override
  Iterable<CarrotChartRangeSegment<String>> getSegments() sync* {
    for (final value in values) {
      yield CarrotChartRangeSegment<String>(
        value: value,
      );
    }
  }

  static CarrotChartStringRange parse(Set<String> values) => CarrotChartStringRange(
        values: values,
      );
}

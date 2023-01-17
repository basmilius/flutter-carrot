import 'dart:ui';

class CarrotChartPlottableValue<V> {
  final String label;
  final V value;

  const CarrotChartPlottableValue({
    required this.label,
    required this.value,
  });

  @override
  String toString() => '$value';

  static CarrotChartPlottableValue<R>? lerp<R>(CarrotChartPlottableValue<R>? a, CarrotChartPlottableValue<R>? b, double t) {
    if (a == b) {
      return a;
    }

    if (a == null || b == null) {
      return t < .5 ? a : b;
    }

    if (a.value is! num) {
      return t < .5 ? a : b;
    }

    if (R is int) {
      return CarrotChartPlottableValue<R>(
        label: t < .5 ? a.label : b.label,
        value: lerpDouble(a.value as int, b.value as int, t)!.toInt() as R,
      );
    }

    return CarrotChartPlottableValue<R>(
      label: t < .5 ? a.label : b.label,
      value: lerpDouble(a.value as double, b.value as double, t)! as R,
    );
  }
}

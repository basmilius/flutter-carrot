import 'package:flutter/widgets.dart';

import '../../extension/extension.dart';
import 'axis.dart';
import 'grid.dart';
import 'mark/mark.dart';
import 'painting.dart';
import 'range/range.dart';

export 'mark/mark.dart';
export 'plottable_value.dart';
export 'range/range.dart';

class CarrotChart<X, Y> extends StatefulWidget {
  final List<CarrotChartMark<X, Y>> marks;

  const CarrotChart({
    super.key,
    required this.marks,
  });

  @override
  createState() => _CarrotChartState<X, Y>();
}

class _CarrotChartState<X, Y> extends State<CarrotChart<X, Y>> {
  final _xUniqueValues = <X>{};
  final _yUniqueValues = <Y>{};

  late CarrotChartRanges ranges;

  @override
  void didUpdateWidget(CarrotChart<X, Y> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.marks != oldWidget.marks) {
      _updateMarks();
    }
  }

  @override
  void initState() {
    super.initState();

    ranges = CarrotChartRanges(
      x: const CarrotChartIntegerRange(lower: 0, upper: 10),
      y: const CarrotChartIntegerRange(lower: 0, upper: 10),
    );

    _updateMarks();
  }

  CarrotChartRange<V> _determineSegments<V>(Set<V> values) {
    if (V == int) {
      return CarrotChartIntegerRange.parse(values as Set<int>) as CarrotChartRange<V>;
    }

    if (V == String) {
      return CarrotChartStringRange.parse(values as Set<String>) as CarrotChartRange<V>;
    }

    throw Exception('A range could not be determined for type $V.');
  }

  void _determineUniqueValues() {
    _xUniqueValues.clear();
    _yUniqueValues.clear();

    for (final mark in widget.marks) {
      _xUniqueValues.add(mark.x!.value);
      _yUniqueValues.add(mark.y!.value);
    }
  }

  void _updateMarks() {
    _determineUniqueValues();

    ranges = CarrotChartRanges(
      x: _determineSegments<X>(_xUniqueValues),
      y: _determineSegments<Y>(_yUniqueValues),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CarrotChartPainter(
        context: context,
        marks: widget.marks,
        ranges: ranges,
        painters: [
          CarrotChartAxisXPainter(
            segments: ranges.segments.x,
          ),
          CarrotChartAxisYPainter(
            segments: ranges.segments.y,
          ),
          CarrotChartGridPainter(
            color: context.carrotTheme.gray[200],
            columns: ranges.segments.x.length,
            rows: ranges.segments.y.length,
          ),
        ],
      ),
    );
  }
}

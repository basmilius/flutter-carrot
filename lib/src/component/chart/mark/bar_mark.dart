part of 'mark.dart';

class CarrotChartBarMark<X, Y> extends CarrotChartMark<X, Y> {
  const CarrotChartBarMark.range({
    required super.xEnd,
    required super.xStart,
    required super.yEnd,
    required super.yStart,
    super.height,
    super.width,
  }) : super.range();

  const CarrotChartBarMark.value({
    required super.x,
    required super.y,
    super.height,
    super.width,
  }) : super.value();

  @override
  void paint(Canvas canvas, CarrotChartPainter painter, CarrotChartRangePositionedSegment segments) {
    final paint = Paint()..color = CarrotColors.blueDark;

    final height = painter.usableArea.height / painter.ranges.segments.y.length;
    final width = painter.usableArea.width / painter.ranges.segments.x.length;

    final segment = Rect.fromLTWH(
      segments.coords.x * width,
      segments.coords.y * height,
      width,
      height,
    );

    double x1 = 0, x2 = 0, y1 = 0, y2 = 0, gutter = 6;

    if (X == String) {
      x1 = segment.left + gutter;
      x2 = segment.right - gutter;
    }

    if (Y == String) {
      y1 = segment.top + gutter;
      y2 = segment.bottom - gutter;
    }

    if (X == int) {
      final xSegment = segments.x as CarrotChartRangeSequenceSegment<int>;
      final delta = (x!.value as int) - xSegment.lower;
      final p = delta / (xSegment.upper - xSegment.lower);

      if (x != null) {
        x1 = painter.usableArea.width - (segment.left + p * segment.width);
        x2 = painter.usableArea.left;
      }
    }

    if (Y == int) {
      final ySegment = segments.y as CarrotChartRangeSequenceSegment<int>;
      final delta = (y!.value as int) - ySegment.lower;
      final p = delta / (ySegment.upper - ySegment.lower);

      if (y != null) {
        y1 = painter.usableArea.height - (segment.top + p * segment.height);
        y2 = painter.usableArea.bottom;
      }
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(x1, y1, x2, y2), const Radius.circular(3)),
      paint,
    );
  }
}

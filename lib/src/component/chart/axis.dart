import 'package:flutter/widgets.dart';

import '../../extension/extension.dart';
import 'painting.dart';
import 'range/range.dart';

abstract class CarrotChartAxisPainter implements CarrotChartPaintable {
  final List<CarrotChartRangeSegment<dynamic>> segments;

  const CarrotChartAxisPainter({
    required this.segments,
  });
}

class CarrotChartAxisXPainter extends CarrotChartAxisPainter {
  const CarrotChartAxisXPainter({
    required super.segments,
  });

  @override
  void layout(BuildContext context, CarrotChartPainter painter) {
    painter.usableArea = Rect.fromLTRB(
      painter.usableArea.left,
      painter.usableArea.top,
      painter.usableArea.right,
      painter.usableArea.bottom - 21,
    );
  }

  @override
  void paint(BuildContext context, Canvas canvas, CarrotChartPainter painter) {
    final style = context.carrotTypography.body1.copyWith(
      fontSize: 10,
    );

    final size = Size(
      painter.usableArea.width / segments.length,
      21,
    );

    for (int i = 0; i < segments.length; ++i) {
      final segment = segments[i];
      final x = i * size.width;

      if (segment is CarrotChartRangeSequenceSegment) {
        _paintText(
          canvas,
          style,
          segment.lowerText,
          size,
          Offset(x, painter.availableArea.bottom - 17),
        );
      } else {
        _paintText(
          canvas,
          style,
          '$segment',
          size,
          Offset(x, painter.availableArea.bottom - 17),
          TextAlign.center,
        );
      }
    }

    if (segments.length == 1 && segments.last is CarrotChartRangeSequenceSegment) {
      _paintText(
        canvas,
        style,
        (segments.last as CarrotChartRangeSequenceSegment).upperText,
        size,
        Offset(painter.usableArea.right, painter.availableArea.bottom - 17),
        TextAlign.right,
      );
    }
  }
}

class CarrotChartAxisYPainter extends CarrotChartAxisPainter {
  const CarrotChartAxisYPainter({
    required super.segments,
  });

  @override
  void layout(BuildContext context, CarrotChartPainter painter) {
    painter.usableArea = Rect.fromLTRB(
      painter.usableArea.left,
      painter.usableArea.top,
      painter.usableArea.right - 30,
      painter.usableArea.bottom,
    );
  }

  @override
  void paint(BuildContext context, Canvas canvas, CarrotChartPainter painter) {
    final style = context.carrotTypography.body1.copyWith(
      fontSize: 10,
    );

    final size = Size(
      30,
      painter.usableArea.height / segments.length,
    );

    for (int i = 0; i < segments.length; ++i) {
      final segment = segments[i];
      final height = painter.usableArea.height / segments.length;
      final y = painter.usableArea.height - i * height;

      if (segment is CarrotChartRangeSequenceSegment) {
        _paintText(
          canvas,
          style,
          segment.lowerText,
          size,
          Offset(painter.availableArea.right - size.width, y - 7),
          TextAlign.left,
          Axis.vertical,
        );
      } else {
        _paintText(
          canvas,
          style,
          '$segment',
          size,
          Offset(painter.availableArea.right - size.width, y - height),
          TextAlign.center,
          Axis.vertical,
        );
      }
    }

    if (segments.isNotEmpty && segments.last is CarrotChartRangeSequenceSegment) {
      _paintText(
        canvas,
        style,
        (segments.last as CarrotChartRangeSequenceSegment).upperText,
        size,
        Offset(painter.availableArea.right - size.width, painter.usableArea.top - 7),
        TextAlign.left,
        Axis.vertical,
      );
    }
  }
}

void _paintText(
  Canvas canvas,
  TextStyle style,
  String text,
  Size size,
  Offset position, [
  TextAlign align = TextAlign.left,
  Axis axis = Axis.horizontal,
]) {
  final span = TextSpan(
    style: style,
    text: text,
  );

  final painter = TextPainter(
    text: span,
    textDirection: TextDirection.ltr,
  );

  painter.layout(
    minWidth: 0,
    maxWidth: size.width,
  );

  if (axis == Axis.horizontal) {
    switch (align) {
      case TextAlign.left:
        painter.paint(canvas, position + const Offset(6, 0));
        break;

      case TextAlign.right:
        painter.paint(canvas, position + Offset(-painter.width - 6, 0));
        break;

      default:
        painter.paint(canvas, position + Offset(size.width / 2 - painter.width / 2, 0));
        break;
    }
  } else {
    switch (align) {
      case TextAlign.left:
        painter.paint(canvas, position + const Offset(6, 0));
        break;

      case TextAlign.right:
        painter.paint(canvas, position + const Offset(6, 0));
        break;

      default:
        painter.paint(canvas, position + Offset(6, size.width / 2 - painter.width / 2));
        break;
    }
  }
}

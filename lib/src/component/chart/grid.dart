import 'package:flutter/widgets.dart';

import '../../utils/utils.dart';
import 'painting.dart';

class CarrotChartGridPainter implements CarrotChartPaintable {
  final Color color;
  final int columns;
  final int rows;
  final double width;
  final Paint _paint;

  CarrotChartGridPainter({
    required this.color,
    this.columns = 1,
    this.rows = 1,
    this.width = 1.0,
  }) : _paint = Paint()
          ..blendMode = BlendMode.src
          ..color = color
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.square
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

  @override
  void layout(BuildContext context, CarrotChartPainter painter) {}

  @override
  void paint(BuildContext context, Canvas canvas, CarrotChartPainter painter) {
    // Horizontal lines; top and bottom.
    canvas.drawLine(painter.usableArea.topLeft, painter.usableArea.topRight, _paint);
    canvas.drawLine(painter.usableArea.bottomLeft, painter.usableArea.bottomRight, _paint);

    // Vertical lines; left and right.
    canvas.drawDashedLine(painter.availableArea.topLeft, painter.availableArea.bottomLeft, 1, 2, _paint);
    canvas.drawDashedLine(painter.usableArea.topRight, Offset(painter.usableArea.width, painter.availableArea.height), 1, 2, _paint);

    // Columns
    if (columns > 1) {
      final size = painter.usableArea.width / columns;

      for (int column = 1; column < columns; ++column) {
        canvas.drawDashedLine(Offset(column * size, painter.usableArea.top), Offset(column * size, painter.availableArea.bottom), 1, 2, _paint);
      }
    }

    // Rows
    if (rows > 1) {
      final size = painter.usableArea.height / rows;

      for (int row = 1; row < rows; ++row) {
        canvas.drawLine(Offset(painter.usableArea.left, row * size), Offset(painter.usableArea.right, row * size), _paint);
      }
    }
  }
}

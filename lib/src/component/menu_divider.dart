import 'package:flutter/widgets.dart';

import '../extension/extension.dart';

class CarrotMenuDivider extends StatelessWidget {
  final Axis axis;
  final Color? color;
  final EdgeInsetsGeometry margin;
  final double thickness;

  const CarrotMenuDivider.horizontal({
    super.key,
    this.color,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 6,
    ),
    this.thickness = 2.0,
  }) : axis = Axis.horizontal;

  const CarrotMenuDivider.vertical({
    super.key,
    this.color,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 24,
    ),
    this.thickness = 2.0,
  }) : axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: axis == Axis.horizontal ? thickness : null,
      width: axis == Axis.vertical ? thickness : null,
      margin: margin,
      color: color ?? context.carrotTheme.gray[100],
    );
  }
}

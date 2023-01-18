import 'package:flutter/widgets.dart';

class CarrotSpacer extends StatelessWidget {
  final Axis axis;
  final double size;

  const CarrotSpacer({
    super.key,
    required this.axis,
    required this.size,
  });

  const CarrotSpacer.horizontal({
    super.key,
    required this.size,
  }) : axis = Axis.horizontal;

  const CarrotSpacer.vertical({
    super.key,
    required this.size,
  }) : axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: axis == Axis.vertical ? size : 0,
      width: axis == Axis.horizontal ? size : 0,
    );
  }
}

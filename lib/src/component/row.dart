import 'package:flutter/widgets.dart';

import 'primitive/primitive.dart';

class CarrotRow extends CarrotFlex {
  const CarrotRow({
    super.key,
    required super.children,
    super.clipBehavior,
    super.gap,
    super.crossAxisAlignment,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
          direction: Axis.horizontal,
        );
}

import 'package:flutter/widgets.dart';

import '../utils/utils.dart';

class CarrotColumn extends Column {
  CarrotColumn({
    super.key,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.textDirection,
    super.verticalDirection = VerticalDirection.down,
    super.textBaseline,
    double? gap,
    List<Widget> children = const [],
  }) : super(
          children: intersperseWidgets(
            gap != null && gap > 0 ? SizedBox(height: gap) : null,
            children,
          ),
        );
}

class CarrotRow extends Row {
  CarrotRow({
    super.key,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.textDirection,
    super.verticalDirection = VerticalDirection.down,
    super.textBaseline,
    double? gap,
    List<Widget> children = const [],
  }) : super(
          children: intersperseWidgets(
            gap != null && gap > 0 ? SizedBox(width: gap) : null,
            children,
          ),
        );
}

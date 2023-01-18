import 'package:flutter/widgets.dart';

import '../../extension/extension.dart';
import '../icon.dart';
import '../row.dart';

class CarrotFormGroupAddition extends StatelessWidget {
  final Color? color;
  final String icon;
  final Widget message;

  const CarrotFormGroupAddition({
    super.key,
    required this.icon,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final carrotTheme = context.carrotTheme;

    return DefaultTextStyle(
      style: carrotTheme.typography.body2.copyWith(
        color: color,
        fontSize: 13.0,
      ),
      child: CarrotRow(
        gap: 6.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
            ),
            child: CarrotIcon(
              glyph: icon,
              size: 13.0,
            ),
          ),
          Expanded(
            child: message,
          ),
        ],
      ),
    );
  }
}

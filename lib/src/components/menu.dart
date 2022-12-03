import 'package:flutter/widgets.dart';

import 'column.dart';

class CarrotMenu extends StatelessWidget {
  final List<Widget> children;
  final double gap;

  const CarrotMenu({
    super.key,
    required this.children,
    this.gap = .0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CarrotColumn(
        gap: gap,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import 'row.dart';

class CarrotAppBarButtons extends StatelessWidget {
  final MainAxisAlignment alignment;
  final List<Widget> children;

  const CarrotAppBarButtons({
    super.key,
    required this.alignment,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotRow(
      gap: 6.0,
      mainAxisAlignment: alignment,
      children: children,
    );
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../data/data.dart';
import '../theme/theme.dart';

part 'container_theme.dart';

class CarrotContainer extends StatelessWidget {
  final Widget child;

  const CarrotContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final containerTheme = CarrotContainerTheme.of(context);

    return Align(
      alignment: containerTheme.alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: containerTheme.width,
        ),
        child: child,
      ),
    );
  }
}

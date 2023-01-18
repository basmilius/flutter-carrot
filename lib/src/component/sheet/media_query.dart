import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'widget.dart';

class CarrotSheetMediaQuery extends StatelessWidget {
  final Widget child;

  const CarrotSheetMediaQuery({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CarrotSheet.of(context)!.controller;
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: controller.animation,
        builder: (context, child) {
          final position = controller.position;
          final viewportDimension = position.hasViewportDimension ? position.viewportDimension : double.infinity;
          final pixels = position.hasPixels ? position.pixels : 0;
          final offset = viewportDimension - pixels;
          final topPadding = math.max(.0, mediaQuery.padding.top - offset);

          return MediaQuery(
            data: mediaQuery.copyWith(
              padding: mediaQuery.padding.copyWith(
                top: topPadding,
              ),
            ),
            child: child!,
          );
        },
        child: child,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotAnimatedClipRRect extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final Curve curve;
  final Duration duration;

  const CarrotAnimatedClipRRect({
    super.key,
    required this.borderRadius,
    required this.child,
    required this.duration,
    this.curve = CarrotCurves.swiftOutCurve,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<BorderRadiusGeometry>(
      curve: curve,
      duration: duration,
      tween: Tween(
        begin: BorderRadius.zero,
        end: borderRadius,
      ),
      builder: (context, borderRadius, child) => ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
      child: child,
    );
  }
}

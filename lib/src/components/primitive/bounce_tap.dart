import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import 'bounce_tap_builder.dart';

class CarrotBounceTap extends StatelessWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final double scale;
  final Function? onDown;
  final Function? onUp;
  final GestureTapCallback? onTap;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;

  const CarrotBounceTap({
    super.key,
    required this.child,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 90),
    this.scale = .985,
    this.onDown,
    this.onUp,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotBounceTapBuilder(
      builder: (context, _) => child,
      curve: curve,
      duration: duration,
      scale: scale,
      onDown: onDown,
      onUp: onUp,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
    );
  }
}

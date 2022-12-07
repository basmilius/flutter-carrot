import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

final _kDefaultCurve = CarrotCurves.springCriticallyDamped;
const _kDefaultDuration = Duration(milliseconds: 540);

class CarrotDefaultSwitchAnimation extends StatelessWidget {
  final Widget? child;
  final Curve? curve;
  final Duration duration;
  final Duration switchInDurationExtra;

  const CarrotDefaultSwitchAnimation({
    super.key,
    this.child,
    this.curve,
    this.duration = _kDefaultDuration,
    this.switchInDurationExtra = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final curve = this.curve ?? _kDefaultCurve;

    return AnimatedSwitcher(
      duration: duration + switchInDurationExtra,
      reverseDuration: duration,
      switchInCurve: curve,
      switchOutCurve: curve.flipped,
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Opacity(
          opacity: animation.value.clamp(0, 1),
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        ),
        child: child,
      ),
      child: child,
    );
  }
}

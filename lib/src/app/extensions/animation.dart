import 'package:flutter/animation.dart';

import '../../animation/curve.dart';

extension CarrotAnimationControllerExtension on AnimationController {
  Animation<T> curveTween<T>({
    required T begin,
    required T end,
    required Curve curve,
  }) =>
      CarrotCurveTween<T>(
        begin: begin,
        end: end,
        curve: curve,
      ).animate(this);
}

extension CarrotAnimationCurveExtension on Curve {
  Curve withInterval({double begin = 0, double end = 1}) => Interval(begin, end, curve: this);
}

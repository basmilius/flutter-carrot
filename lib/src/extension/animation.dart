import 'package:flutter/animation.dart';

import '../animation/animation.dart';

extension CarrotAnimationExtension on Animation<double> {
  /// Returns a [CurvedAnimation] with the given [curve] and
  /// attaches the current [Animation] as a parent.
  CurvedAnimation curved(Curve curve) => CurvedAnimation(
        curve: curve,
        reverseCurve: curve.flipped,
        parent: this,
      );

  /// Creates a new [CarrotCurveTween] with the given [curve],
  /// [begin] and [end] arguments.
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
  /// Wraps the current [Curve] with an [Interval].
  Curve withInterval({double begin = 0, double end = 1}) => Interval(begin, end, curve: this);
}

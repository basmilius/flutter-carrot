import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import 'backdrop_blur.dart';

class CarrotBackdropBlurContainer extends StatelessWidget {
  final Widget? child;
  final Clip clip;
  final Color? color;
  final Curve curve;
  final BoxDecoration? decoration;
  final Duration duration;
  final EdgeInsets? padding;
  final double sigmaX;
  final double sigmaY;

  const CarrotBackdropBlurContainer({
    super.key,
    this.child,
    this.clip = Clip.none,
    this.color,
    this.curve = CarrotCurves.swiftOutCurve,
    this.decoration,
    this.duration = const Duration(milliseconds: 270),
    this.padding,
    this.sigmaX = 15.0,
    this.sigmaY = 15.0,
  })  : assert(sigmaX >= 0.0),
        assert(sigmaY >= 0.0);

  @override
  Widget build(BuildContext context) {
    return CarrotBackdropBlur(
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      child: AnimatedContainer(
        clipBehavior: clip,
        curve: curve,
        decoration: decoration,
        duration: duration,
        color: color,
        padding: padding,
        child: child,
      ),
    );
  }
}

class CarrotAnimatedBackdropBlurContainer extends StatelessWidget {
  final Widget? child;
  final Clip clip;
  final Color? color;
  final Curve curve;
  final BoxDecoration? decoration;
  final Duration duration;
  final EdgeInsets? padding;
  final double sigmaX;
  final double sigmaY;

  const CarrotAnimatedBackdropBlurContainer({
    super.key,
    this.child,
    this.clip = Clip.none,
    this.color,
    this.curve = CarrotCurves.swiftOutCurve,
    this.decoration,
    this.duration = const Duration(milliseconds: 270),
    this.padding,
    this.sigmaX = 15.0,
    this.sigmaY = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotAnimatedBackdropBlur(
      curve: curve,
      duration: duration,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      child: AnimatedContainer(
        clipBehavior: clip,
        curve: curve,
        decoration: decoration,
        duration: duration,
        color: color,
        padding: padding,
        child: child,
      ),
    );
  }
}

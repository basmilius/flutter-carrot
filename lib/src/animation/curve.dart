import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import 'spring.dart';

class CarrotCurves {
  static const accelerationCurve = Cubic(.4, .0, 1, 1);
  static const accelerationCurveReversed = FlippedCurve(Cubic(.4, .0, 1, 1));

  static const decelerationCurve = Cubic(.0, .0, .2, 1);
  static const decelerationCurveReversed = FlippedCurve(Cubic(.0, .0, .2, 1));

  static const sharpCurve = Cubic(.4, .0, .6, 1);
  static const sharpCurveReversed = FlippedCurve(Cubic(.4, .0, .6, 1));

  static const standardCurve = Cubic(.4, .0, .2, 1);
  static const standardCurveReversed = FlippedCurve(Cubic(.4, .0, .2, 1));

  static const swiftOutCurve = Cubic(.55, 0, .1, 1);
  static const swiftOutCurveReversed = FlippedCurve(Cubic(.55, 0, .1, 1));

  static final springCriticallyDamped = CarrotSpring(damping: 20);
  static final springOverDamped = CarrotSpring(damping: 28);
  static final springUnderDamped = CarrotSpring(damping: 12);

  static const linear = Curves.linear;
  static const decelerate = Curves.decelerate;
  static const fastLinearToSlowEaseIn = Curves.fastLinearToSlowEaseIn;
  static const ease = Curves.ease;
  static const easeIn = Curves.easeIn;
  static const easeInToLinear = Curves.easeInToLinear;
  static const easeInSine = Curves.easeInSine;
  static const easeInQuad = Curves.easeInQuad;
  static const easeInCubic = Curves.easeInCubic;
  static const easeInQuart = Curves.easeInQuart;
  static const easeInQuint = Curves.easeInQuint;
  static const easeInExpo = Curves.easeInExpo;
  static const easeInCirc = Curves.easeInCirc;
  static const easeInBack = Curves.easeInBack;
  static const easeOut = Curves.easeOut;
  static const linearToEaseOut = Curves.linearToEaseOut;
  static const easeOutSine = Curves.easeOutSine;
  static const easeOutQuad = Curves.easeOutQuad;
  static const easeOutCubic = Curves.easeOutCubic;
  static const easeOutQuart = Curves.easeOutQuart;
  static const easeOutQuint = Curves.easeOutQuint;
  static const easeOutExpo = Curves.easeOutExpo;
  static const easeOutCirc = Curves.easeOutCirc;
  static const easeOutBack = Curves.easeOutBack;
  static const easeInOut = Curves.easeInOut;
  static const easeInOutSine = Curves.easeInOutSine;
  static const easeInOutQuad = Curves.easeInOutQuad;
  static const easeInOutCubic = Curves.easeInOutCubic;
  static const easeInOutCubicEmphasized = Curves.easeInOutCubicEmphasized;
  static const easeInOutQuart = Curves.easeInOutQuart;
  static const easeInOutQuint = Curves.easeInOutQuint;
  static const easeInOutExpo = Curves.easeInOutExpo;
  static const easeInOutCirc = Curves.easeInOutCirc;
  static const easeInOutBack = Curves.easeInOutBack;
  static const fastOutSlowIn = Curves.fastOutSlowIn;
  static const slowMiddle = Curves.slowMiddle;
  static const bounceIn = Curves.bounceIn;
  static const bounceOut = Curves.bounceOut;
  static const bounceInOut = Curves.bounceInOut;
  static const elasticIn = Curves.elasticIn;
  static const elasticOut = Curves.elasticOut;
  static const elasticInOut = Curves.elasticInOut;

  static CarrotSpring spring({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) =>
      CarrotSpring(
        damping: damping,
        stiffness: stiffness,
        mass: mass,
        velocity: velocity,
      );
}

class CarrotAccelerationCurveAnimation extends CurvedAnimation {
  CarrotAccelerationCurveAnimation({
    required super.parent,
  }) : super(
          curve: CarrotCurves.accelerationCurve,
          reverseCurve: CarrotCurves.accelerationCurveReversed,
        );
}

class CarrotDecelerationCurveAnimation extends CurvedAnimation {
  CarrotDecelerationCurveAnimation({
    required super.parent,
  }) : super(
          curve: CarrotCurves.decelerationCurve,
          reverseCurve: CarrotCurves.decelerationCurveReversed,
        );
}

class CarrotSharpCurveAnimation extends CurvedAnimation {
  CarrotSharpCurveAnimation({
    required super.parent,
  }) : super(
          curve: CarrotCurves.sharpCurve,
          reverseCurve: CarrotCurves.sharpCurveReversed,
        );
}

class CarrotStandardCurveAnimation extends CurvedAnimation {
  CarrotStandardCurveAnimation({
    required super.parent,
  }) : super(
          curve: CarrotCurves.standardCurve,
          reverseCurve: CarrotCurves.standardCurveReversed,
        );
}

class CarrotSwiftOutCurveAnimation extends CurvedAnimation {
  CarrotSwiftOutCurveAnimation({
    required super.parent,
  }) : super(
          curve: CarrotCurves.swiftOutCurve,
          reverseCurve: CarrotCurves.swiftOutCurveReversed,
        );
}

class CarrotCurveTween<T> extends Tween<T> {
  final Curve curve;

  CarrotCurveTween({
    required this.curve,
    required super.begin,
    required super.end,
  });

  @override
  T lerp(double t) {
    if (begin is Rect && end is Rect) {
      return Rect.lerp(begin as Rect, end as Rect, t) as T;
    }

    return super.lerp(t);
  }

  @override
  T transform(double t) {
    if (t == 0.0 || t == 1.0) {
      assert(curve.transform(t).round() == t);
      return super.transform(t);
    }

    return super.transform(curve.transform(t));
  }
}

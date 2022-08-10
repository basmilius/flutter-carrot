import 'dart:async';

import 'package:flutter/widgets.dart';

import 'base_bounces.dart';
import 'base_elastics.dart';
import 'base_fades.dart';
import 'base_flips.dart';
import 'curve.dart';

typedef CarrotBasicAnimationControllerBuilder = Function(AnimationController);
typedef CarrotBasicAnimationCreatorBuilder = CarrotBasicAnimationBuilder Function();

const _kDefaultDuration = Duration(milliseconds: 300);

abstract class CarrotBasicAnimationBuilder {
  Widget build(BuildContext context, Widget child);

  void init(CurvedAnimation controller);
}

class CarrotBasicAnimation<T extends CarrotBasicAnimationBuilder> extends StatefulWidget {
  final bool animate;
  final Widget child;
  final CarrotBasicAnimationControllerBuilder? controller;
  final CarrotBasicAnimationCreatorBuilder creator;
  final Curve curve;
  final Duration delay;
  final Duration duration;
  final Function? onBegin;
  final Function? onEnd;

  const CarrotBasicAnimation({
    super.key,
    required this.animate,
    required this.child,
    required this.controller,
    required this.creator,
    required this.curve,
    required this.delay,
    required this.duration,
    this.onBegin,
    this.onEnd,
  });

  @override
  createState() => _CarrotBasicAnimation();

  factory CarrotBasicAnimation.bounceIn({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.bounceOut,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => BounceInBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.bounceInOffset({
    bool animate = true,
    required Widget child,
    required Offset fromOffset,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.bounceOut,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => BounceInOffsetBuilder(fromOffset),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.elasticIn({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.elasticOut,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => ElasticInBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.elasticInOffset({
    bool animate = true,
    required Widget child,
    required Offset fromOffset,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.elasticOut,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => ElasticInOffsetBuilder(fromOffset),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.fadeIn({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FadeInBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.fadeInOffset({
    bool animate = true,
    required Widget child,
    required Offset fromOffset,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FadeInOffsetBuilder(fromOffset),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.fadeOut({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FadeOutBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.fadeOutOffset({
    bool animate = true,
    required Widget child,
    required Offset toOffset,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FadeOutOffsetBuilder(toOffset),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.flipInX({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FlipInXBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.flipInY({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FlipInYBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );

  factory CarrotBasicAnimation.flipInXY({
    bool animate = true,
    required Widget child,
    CarrotBasicAnimationControllerBuilder? controller,
    Curve curve = CarrotCurves.linear,
    Duration delay = Duration.zero,
    Duration duration = _kDefaultDuration,
    Function? onBegin,
    Function? onEnd,
  }) =>
      CarrotBasicAnimation(
        animate: animate,
        controller: controller,
        creator: () => FlipInXYBuilder(),
        curve: curve,
        delay: delay,
        duration: duration,
        onBegin: onBegin,
        onEnd: onEnd,
        child: child,
      );
}

class _CarrotBasicAnimation<T extends CarrotBasicAnimationBuilder> extends State<CarrotBasicAnimation<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CarrotBasicAnimationBuilder _builder;

  Timer? _delayTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _prepareForAnimation();
  }

  @override
  void didUpdateWidget(CarrotBasicAnimation<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool resetAnimation = false;
    bool resetCurve = false;

    if (widget.creator != oldWidget.creator) {
      _initBuilder();
      resetAnimation = true;
      resetCurve = true;
    }

    if (widget.curve != oldWidget.curve) {
      resetAnimation = true;
      resetCurve = true;
    }

    if (widget.delay != oldWidget.delay) {
      resetAnimation = true;
    }

    if (widget.duration != oldWidget.duration) {
      _initAnimationController();
      resetAnimation = true;
    }

    if (resetCurve) {
      _builder.init(CurvedAnimation(parent: _controller, curve: widget.curve));
    }

    if (resetAnimation) {
      _resetAnimation();
      _prepareForAnimation();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initAnimationController();
    _initBuilder();
  }

  void _initAnimationController() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.addStatusListener(_onAnimationStatusChanged);

    widget.controller?.call(_controller);
  }

  void _initBuilder() {
    _builder = widget.creator();
    _builder.init(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    switch(status) {
      case AnimationStatus.dismissed:
        break;

      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        widget.onBegin?.call();
        break;

      case AnimationStatus.completed:
        widget.onEnd?.call();
        break;
    }
  }

  void _prepareForAnimation() {
    if (widget.animate && widget.delay.inMilliseconds > 0) {
      _delayTimer = Timer(widget.delay, () => _controller.forward());
    } else if (widget.animate) {
      _controller.forward();
    }
  }

  void _resetAnimation() {
    _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => _builder.build(context, child ?? Container()),
      child: widget.child,
    );
  }
}

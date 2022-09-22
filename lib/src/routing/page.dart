import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../animation/animation.dart';

Widget _transitionBuilder(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  final reverse = animation.status == AnimationStatus.completed;
  final controller = reverse ? secondaryAnimation : animation;

  return CarrotRoutingTransition(
    controller: CarrotSwiftOutCurveAnimation(parent: controller),
    reverse: reverse,
    child: child,
  );
}

class CarrotRoutingPage<T> extends CustomTransitionPage<T> {
  const CarrotRoutingPage({
    super.key,
    required super.child,
    super.name,
    Duration duration = const Duration(milliseconds: 450),
  }) : super(
          transitionDuration: duration,
          transitionsBuilder: _transitionBuilder,
        );
}

class CarrotRoutingTransition extends StatefulWidget {
  final Widget child;
  final Animation<double> controller;
  final bool reverse;

  const CarrotRoutingTransition({
    super.key,
    required this.child,
    required this.controller,
    this.reverse = false,
  });

  @override
  createState() => _CarrotRoutingTransition();
}

class _CarrotRoutingTransition extends State<CarrotRoutingTransition> {
  late Animation<Offset> offset;
  late Animation<double> opacity;
  late Animation<double> scale;

  @override
  void didUpdateWidget(CarrotRoutingTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reverse != widget.reverse) {
      _initTweens();
    }
  }

  @override
  void dispose() {
    if (widget.controller is AnimationController) {
      (widget.controller as AnimationController).dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initTweens();
  }

  void _initTweens() {
    if (widget.reverse) {
      offset = Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0)).animate(widget.controller);

      opacity = TweenSequence<double>([
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 1.0, end: 0.0)),
        TweenSequenceItem(weight: 10.0, tween: Tween(begin: 0.0, end: 0.0)),
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 0.0, end: 0.0)),
      ]).animate(widget.controller);

      scale = TweenSequence<double>([
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 1.0, end: 0.95)),
        TweenSequenceItem(weight: 10.0, tween: Tween(begin: 0.95, end: 0.95)),
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 0.95, end: 0.95)),
      ]).animate(widget.controller);
    } else {
      offset = TweenSequence<Offset>([
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0))),
        TweenSequenceItem(weight: 10.0, tween: Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0))),
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: const Offset(0.0, 30.0), end: const Offset(0.0, 0.0))),
      ]).animate(widget.controller);

      opacity = TweenSequence<double>([
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 0.0, end: 0.0)),
        TweenSequenceItem(weight: 10.0, tween: Tween(begin: 0.0, end: 0.0)),
        TweenSequenceItem(weight: 45.0, tween: Tween(begin: 0.0, end: 1.0)),
      ]).animate(widget.controller);

      scale = Tween(begin: 1.0, end: 1.0).animate(widget.controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: AnimatedBuilder(
        animation: widget.controller,
        child: widget.child,
        builder: (context, child) => Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4(
            scale.value,
            0,
            0,
            0,
            0,
            scale.value,
            1,
            0,
            0,
            0,
            1,
            0,
            offset.value.dx,
            offset.value.dy,
            0,
            1,
          ),
          child: child,
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../extension/extension.dart';

const double _kBackGestureWidth = 20.0;
const double _kMinFlingVelocity = 1.0;
const int _kMaxDroppedSwipePageForwardAnimationTime = 540;
const int _kMaxPageBackAnimationTime = 420;

typedef CarrotPageTransitionBuilder = Widget Function(BuildContext, Animation<double>, Animation<double>, Widget);

class CarrotPage<T> extends Page<T> {
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final Widget child;
  final bool fullscreenDialog;
  final bool maintainState;
  final bool opaque;
  final Duration transitionDuration;

  const CarrotPage({
    super.key,
    required this.child,
    super.arguments,
    super.name,
    super.restorationId,
    this.barrierColor,
    this.barrierDismissible = false,
    this.barrierLabel,
    this.fullscreenDialog = false,
    this.maintainState = true,
    this.opaque = true,
    this.transitionDuration = const Duration(milliseconds: 450),
  });

  @override
  Route<T> createRoute(BuildContext context) => CarrotPageRoute<T>(this);
}

class CarrotPageRoute<T> extends PageRoute<T> {
  static final _offsetTween = TweenSequence<Offset>([
    TweenSequenceItem(weight: 55, tween: ConstantTween(Offset.zero)),
    TweenSequenceItem(weight: 45, tween: Tween(begin: const Offset(0, 30), end: Offset.zero)),
  ]);

  static final _opacityTween = TweenSequence<double>([
    TweenSequenceItem(weight: 55, tween: ConstantTween(0)),
    TweenSequenceItem(weight: 45, tween: Tween(begin: 0, end: 1)),
  ]);

  static final _scaleTween = ConstantTween<double>(1);

  static final _reverseOffsetTween = ConstantTween<Offset>(Offset.zero);

  static final _reverseOpacityTween = TweenSequence<double>([
    TweenSequenceItem(weight: 45, tween: Tween(begin: 1, end: 0)),
    TweenSequenceItem(weight: 55, tween: ConstantTween(0)),
  ]);

  static final _reverseScaleTween = TweenSequence<double>([
    TweenSequenceItem(weight: 45, tween: Tween(begin: 1, end: .95)),
    TweenSequenceItem(weight: 55, tween: ConstantTween(.95)),
  ]);

  Tween<Offset>? _popGestureBottomOffsetTween;
  Tween<double>? _popGestureBottomOpacityTween;
  Tween<Offset>? _popGestureTopOffsetTween;

  bool get isPopGestureEnabled {
    if (!Platform.isIOS) {
      return false;
    }

    if (isFirst) {
      return false;
    }

    if (willHandlePopInternally) {
      return false;
    }

    if (popDisposition == RoutePopDisposition.doNotPop) {
      return false;
    }

    if (fullscreenDialog) {
      return false;
    }

    if (animation!.status != AnimationStatus.completed) {
      return false;
    }

    if (secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }

    if (isPopGestureInProgress) {
      return false;
    }

    return true;
  }

  bool get isPopGestureInProgress => navigator!.userGestureInProgress;

  @override
  Color? get barrierColor => page.barrierColor;

  @override
  String? get barrierLabel => page.barrierLabel;

  @override
  bool get fullscreenDialog => page.fullscreenDialog;

  @override
  bool get maintainState => page.maintainState;

  @override
  bool get opaque => page.opaque;

  @override
  Duration get transitionDuration => page.transitionDuration;

  CarrotPage<T> get page => settings as CarrotPage<T>;

  CarrotPageRoute(CarrotPage<T> page) : super(settings: page);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Semantics(
        explicitChildNodes: true,
        scopesRoute: true,
        child: page.child,
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (fullscreenDialog) {
      return child;
    }

    final reverse = animation.status == AnimationStatus.completed;
    final controller = (reverse ? secondaryAnimation : animation);

    return AnimatedBuilder(
      animation: controller,
      child: CarrotBackGestureDetector(
        enabledCallback: () => isPopGestureEnabled,
        onStartPopGesture: startPopGesture,
        child: child,
      ),
      builder: (context, child) {
        late Offset offset;
        late double opacity;
        late double scale;

        final width = MediaQuery.of(context).size.width;

        if (isPopGestureInProgress && !reverse) {
          offset = (_popGestureTopOffsetTween ??= Tween(begin: Offset(width, 0), end: Offset.zero)).evaluate(controller);
          opacity = 1;
          scale = 1;
        } else if (isPopGestureInProgress) {
          offset = (_popGestureBottomOffsetTween ??= Tween(begin: Offset.zero, end: Offset(width * -.5, 0))).evaluate(controller);
          opacity = (_popGestureBottomOpacityTween ??= Tween(begin: 1.0, end: .0)).evaluate(controller);
          scale = 1;
        } else {
          offset = (reverse ? _reverseOffsetTween : _offsetTween).evaluate(controller.curved(CarrotCurves.swiftOutCurve));
          opacity = (reverse ? _reverseOpacityTween : _opacityTween).evaluate(controller.curved(CarrotCurves.swiftOutCurve));
          scale = (reverse ? _reverseScaleTween : _scaleTween).evaluate(controller.curved(CarrotCurves.swiftOutCurve));
        }

        return Opacity(
          opacity: opacity,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4(
              scale,
              0,
              0,
              0,
              0,
              scale,
              1,
              0,
              0,
              0,
              1,
              0,
              offset.dx,
              offset.dy,
              0,
              1,
            ),
            child: child,
          ),
        );
      },
    );
  }

  CarrotBackGestureController startPopGesture() {
    assert(isPopGestureEnabled);

    return CarrotBackGestureController(
      controller: controller!,
      navigator: navigator!,
    );
  }
}

class CarrotBackGestureController {
  final AnimationController controller;
  final NavigatorState navigator;

  CarrotBackGestureController({
    required this.controller,
    required this.navigator,
  }) {
    navigator.didStartUserGesture();
  }

  void dragEnd(double velocity) {
    const animationCurve = CarrotCurves.decelerationCurve;
    final bool animateForward = velocity.abs() >= _kMinFlingVelocity ? velocity <= 0 : controller.value > .5;

    if (animateForward) {
      final droppedPageForwardAnimationTime = math.min(
        lerpDouble(_kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value)!.floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(
        1.0,
        curve: animationCurve,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
      );
    } else {
      navigator.pop();

      if (controller.isAnimating) {
        final droppedPageBackAnimationTime = lerpDouble(0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!.floor();
        controller.animateBack(
          .0,
          curve: animationCurve,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;

      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };

      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }

  void dragUpdate(double delta) {
    controller.value -= delta;
  }
}

class CarrotBackGestureDetector extends StatefulWidget {
  final Widget child;
  final ValueGetter<bool> enabledCallback;
  final ValueGetter<CarrotBackGestureController> onStartPopGesture;

  const CarrotBackGestureDetector({
    super.key,
    required this.child,
    required this.enabledCallback,
    required this.onStartPopGesture,
  });

  @override
  createState() => _CarrotBackGestureDetectorState();
}

class _CarrotBackGestureDetectorState extends State<CarrotBackGestureDetector> {
  late final HorizontalDragGestureRecognizer _recognizer;

  CarrotBackGestureController? _backGestureController;

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onCancel = _handleDragCancel
      ..onEnd = _handleDragEnd
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate;
  }

  void _handleDragCancel() {
    assert(mounted);

    _backGestureController?.dragEnd(.0);
    _backGestureController = null;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);

    _backGestureController?.dragEnd(_convertToLogical(details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);

    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);

    _backGestureController?.dragUpdate(_convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(double value) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return value;
    }

    return -value;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    double dragAreaWidth = math.max(
      Directionality.of(context) == TextDirection.ltr ? MediaQuery.of(context).padding.left : MediaQuery.of(context).padding.right,
      _kBackGestureWidth,
    );

    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        PositionedDirectional(
          bottom: 0,
          start: 0,
          top: 0,
          width: dragAreaWidth,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handlePointerDown,
          ),
        ),
      ],
    );
  }
}

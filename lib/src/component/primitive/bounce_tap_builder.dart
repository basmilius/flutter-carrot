import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

typedef CarrotBounceTapWidgetBuilder = Widget Function(BuildContext, bool);

class CarrotBounceTapBuilder extends StatefulWidget {
  final CarrotBounceTapWidgetBuilder builder;
  final Curve curve;
  final Duration duration;
  final double scale;
  final Function? onDown;
  final Function? onUp;
  final GestureTapCallback? onTap;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;

  const CarrotBounceTapBuilder({
    super.key,
    required this.builder,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 90),
    this.scale = .985,
    this.onDown,
    this.onUp,
    this.onTap,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
  });

  factory CarrotBounceTapBuilder.child({
    Key? key,
    required Widget child,
    Curve curve = CarrotCurves.swiftOutCurve,
    Duration duration = const Duration(milliseconds: 90),
    double scale = .985,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
  }) =>
      CarrotBounceTapBuilder(
        key: key,
        builder: (context, _) => child,
        curve: curve,
        duration: duration,
        onTap: onTap,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
      );

  @override
  createState() => _CarrotBounceTapBuilderState();
}

class _CarrotBounceTapBuilderState extends State<CarrotBounceTapBuilder> {
  bool get _canTap => widget.onTap != null;

  bool _isTapDown = false;

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _onPanDown(DragDownDetails details) {
    if (!_canTap) {
      return;
    }

    setState(() {
      _isTapDown = true;
    });

    widget.onDown?.call();
  }

  void _onPanEndOrCancel([DragEndDetails? details]) {
    if (!_canTap) {
      return;
    }

    setState(() {
      _isTapDown = false;
    });

    widget.onUp?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanEnd: _onPanEndOrCancel,
      onPanCancel: _onPanEndOrCancel,
      onTap: _onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        curve: widget.curve,
        duration: widget.duration,
        scale: _isTapDown ? widget.scale : 1,
        child: Builder(
          builder: (context) => widget.builder(context, _isTapDown),
        ),
      ),
    );
  }
}

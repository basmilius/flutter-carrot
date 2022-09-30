import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotBounceTap extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final double scale;
  final Function? onDown;
  final Function? onUp;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

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
  createState() => _CarrotBounceTapState();
}

class _CarrotBounceTapState extends State<CarrotBounceTap> {
  bool get canTap => widget.onTap != null;

  bool _isTapDown = false;

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _onPanDown(DragDownDetails details) {
    if (!canTap) {
      return;
    }

    setState(() {
      _isTapDown = true;
    });

    widget.onDown?.call();
  }

  void _onPanEndOrCancel([DragEndDetails? details]) {
    if (!canTap) {
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
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotBackgroundTap extends StatefulWidget {
  final Widget child;
  final Color background;
  final Color? backgroundTap;
  final Curve curve;
  final Duration duration;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const CarrotBackgroundTap({
    super.key,
    required this.child,
    required this.background,
    this.backgroundTap,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 90),
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  createState() => _CarrotBackgroundTapState();
}

class _CarrotBackgroundTapState extends State<CarrotBackgroundTap> {
  bool get canTap {
    return widget.onTap != null;
  }

  bool isTapDown = false;

  void _onPanDown(DragDownDetails details) {
    if (!canTap) {
      return;
    }

    setState(() {
      isTapDown = true;
    });
  }

  void _onPanEndOrCancel([DragEndDetails? details]) {
    if (!canTap) {
      return;
    }

    setState(() {
      isTapDown = false;
    });
  }

  void _onTap() {
    if (!canTap) {
      return;
    }

    HapticFeedback.selectionClick();
    widget.onTap!.call();
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
      child: AnimatedContainer(
        color: isTapDown ? (widget.backgroundTap ?? widget.background) : widget.background,
        curve: widget.curve,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}

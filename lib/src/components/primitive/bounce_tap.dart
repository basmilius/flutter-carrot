import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import '../../app/extensions/extensions.dart';

class CarrotBounceTap extends StatefulWidget {
  final Widget child;
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

class _CarrotBounceTapState extends State<CarrotBounceTap> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool get canTap {
    return widget.onTap != null;
  }

  @override
  void didUpdateWidget(CarrotBounceTap oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animationController.duration = widget.duration;
    _initializeAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _scaleAnimation = _animationController.curveTween(
      begin: 1,
      end: widget.scale,
      curve: CarrotCurves.swiftOutCurve,
    );
  }

  void _onTap() {
    HapticFeedback.selectionClick();

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onPanCancel() {
    _onPanEnd(null);
  }

  void _onPanDown(DragDownDetails? _) {
    if (!canTap) {
      return;
    }

    _animationController.forward();

    if (widget.onDown != null) {
      widget.onDown!();
    }
  }

  void _onPanEnd(DragEndDetails? _) {
    if (!canTap) {
      return;
    }

    _animationController.reverse();

    if (widget.onUp != null) {
      widget.onUp!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
      onTap: _onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animationController,
        child: widget.child,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
      ),
    );
  }
}

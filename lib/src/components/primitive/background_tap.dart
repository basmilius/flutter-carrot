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

class _CarrotBackgroundTapState extends State<CarrotBackgroundTap> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  bool get canTap {
    return widget.onTap != null;
  }

  @override
  void didUpdateWidget(CarrotBackgroundTap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _animationController.duration = widget.duration;
    }

    if (oldWidget.background != widget.background || oldWidget.backgroundTap != widget.backgroundTap || oldWidget.curve != widget.curve) {
      _createAnimation();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _createAnimation();
  }

  void _createAnimation() {
    _colorAnimation = ColorTween(begin: widget.background, end: widget.backgroundTap ?? widget.background.withOpacity(.9)).animate(CurvedAnimation(parent: _animationController, curve: widget.curve))
      ..addListener(() {
        setState(() {});
      });
  }

  void _onTap() {
    if (!canTap) {
      return;
    }

    _animationController.forward();
  }

  void _onTapUp() {
    if (!canTap) {
      return;
    }

    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _onTap(),
      onPanEnd: (details) => _onTapUp(),
      onPanCancel: () => _onTapUp(),
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      child: Container(
        color: _colorAnimation.value,
        child: widget.child,
      ),
    );
  }
}

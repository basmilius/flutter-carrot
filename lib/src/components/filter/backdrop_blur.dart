import 'dart:ui' as ui show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotBackdropBlur extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;

  const CarrotBackdropBlur({
    super.key,
    required this.child,
    this.sigmaX = 15.0,
    this.sigmaY = 15.0,
  })  : assert(sigmaX >= 0.0),
        assert(sigmaY >= 0.0);

  @override
  Widget build(BuildContext context) {
    if (sigmaX == 0 && sigmaY == 0) {
      return child;
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
        ),
        child: child,
      ),
    );
  }
}

class CarrotAnimatedBackdropBlur extends ImplicitlyAnimatedWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;

  const CarrotAnimatedBackdropBlur({
    super.key,
    super.curve = CarrotCurves.swiftOutCurve,
    super.duration = const Duration(milliseconds: 300),
    super.onEnd,
    required this.child,
    this.sigmaX = 15.0,
    this.sigmaY = 15.0,
  }) : assert(sigmaX >= 0 && sigmaY >= 0);

  @override
  createState() => _CarrotAnimatedBackdropBlur();
}

class _CarrotAnimatedBackdropBlur extends ImplicitlyAnimatedWidgetState<CarrotAnimatedBackdropBlur> {
  Tween<double>? _sigmaX;
  Tween<double>? _sigmaY;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _sigmaX = visitor(_sigmaX, widget.sigmaX, (value) => Tween<double>(begin: value as double)) as Tween<double>;
    _sigmaY = visitor(_sigmaY, widget.sigmaY, (value) => Tween<double>(begin: value as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: _sigmaX?.evaluate(animation) ?? 0.0,
          sigmaY: _sigmaY?.evaluate(animation) ?? 0.0,
        ),
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';

class CarrotExpandable extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final bool isExpanded;

  const CarrotExpandable({
    super.key,
    required this.child,
    required this.isExpanded,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  createState() => _CarrotExpandableState();
}

class _CarrotExpandableState extends State<CarrotExpandable> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightTween;

  @override
  void didUpdateWidget(CarrotExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initAnimation();

    if (widget.isExpanded) {
      _animationController.forward();
    } else if (!widget.isExpanded) {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() {
        setState(() {});
      });

    _initAnimation();

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  void _initAnimation() {
    _heightTween = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: FlippedCurve(widget.curve)));
  }

  @override
  Widget build(BuildContext context) {
    bool isClosed = !widget.isExpanded && _animationController.isDismissed;

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topLeft,
            heightFactor: _heightTween.value.clamp(0.0, 2.0),
            child: child,
          ),
        );
      },
      child: isClosed ? null : widget.child,
    );
  }
}

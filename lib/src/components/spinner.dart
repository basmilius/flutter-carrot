import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import '../utils/utils.dart';

const _kAnimationDuration = Duration(milliseconds: 1200);
const _kDeltaIncrementor = .007;

class CarrotSpinner extends StatefulWidget {
  final Color? color;
  final Curve curve;
  final Duration duration;
  final double size;
  final double thickness;

  const CarrotSpinner({
    super.key,
    this.color,
    this.curve = CarrotCurves.easeInOutSine,
    this.duration = _kAnimationDuration,
    this.size = 30,
    this.thickness = 3,
  });

  @override
  createState() => _CarrotSpinnerState();
}

class _CarrotSpinnerState extends State<CarrotSpinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _strokeAnimation;

  @override
  void didUpdateWidget(CarrotSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initAnimation();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _initTween();

    _controller.repeat();
  }

  void _initTween() {
    _strokeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CarrotSpinnerPainter(
            animation: _strokeAnimation,
            color: widget.color ?? context.carrotTheme.primary,
            thickness: widget.thickness,
          ),
          child: SizedBox.fromSize(
            size: Size.square(widget.size),
          ),
        ),
      ),
    );
  }
}

class _CarrotSpinnerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double thickness;

  final Paint _paint;
  double _delta = 2.25;

  _CarrotSpinnerPainter({
    required this.animation,
    required this.color,
    required this.thickness,
  })  : _paint = Paint()
          ..color = color
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    _delta += _kDeltaIncrementor;

    final rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    final delta = (animation.value >= .5 ? 1 - animation.value : animation.value) * 2;

    double arc = radians(delta * 135 + 45);
    double rotation = radians((animation.value + _delta) * 360);

    canvas.drawArc(rect, rotation, -arc, false, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

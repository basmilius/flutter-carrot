import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import '../../app/extensions/extensions.dart';
import '../../utils/utils.dart';
import '../row.dart';

class CarrotGauge extends StatefulWidget {
  final int fractionDigits;
  final Widget? label;
  final String? maxLabel;
  final num maxValue;
  final String? minLabel;
  final num minValue;
  final Color? trackColor;
  final List<Color>? trackGradient;
  final double trackOpacity;
  final num value;
  final Color? valueColor;

  const CarrotGauge({
    super.key,
    required this.value,
    this.fractionDigits = 1,
    this.label,
    this.maxLabel,
    this.maxValue = 1,
    this.minLabel,
    this.minValue = 0,
    this.trackColor,
    this.trackGradient,
    this.trackOpacity = .25,
    this.valueColor,
  })  : assert(fractionDigits >= 0),
        assert(maxValue > minValue),
        assert(value >= minValue),
        assert(value <= maxValue),
        assert(label == null || (maxLabel == null && minLabel == null)),
        assert(trackGradient == null || trackGradient.length > 1, 'At least two colors should be in the gradient.');

  @override
  createState() => CarrotGaugeState();
}

class CarrotGaugeState extends State<CarrotGauge> with TickerProviderStateMixin {
  AnimationController? _animation;

  double get fractionalValue => (_animation?.value ?? 0 - widget.minValue) / (widget.maxValue - widget.minValue);

  double get value => _animation?.value ?? 0;

  @override
  void didUpdateWidget(CarrotGauge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.maxValue != oldWidget.maxValue || widget.minValue != oldWidget.minValue) {
      _initAnimationController();
    }

    if (widget.value != oldWidget.value) {
      _animation?.animateTo(
        widget.value.toDouble(),
        curve: CarrotCurves.swiftOutCurve,
        duration: const Duration(milliseconds: 480),
      );
    }
  }

  @override
  void dispose() {
    _disposeAnimationController();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  void _disposeAnimationController() {
    _animation?.dispose();
    _animation = null;
  }

  void _initAnimationController() {
    _disposeAnimationController();

    setState(() {
      _animation = AnimationController(
        lowerBound: widget.minValue.toDouble(),
        upperBound: widget.maxValue.toDouble(),
        value: widget.value.toDouble(),
        vsync: this,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: _buildGauge,
        ),
      ),
    );
  }

  Widget _buildGauge(BuildContext context, BoxConstraints constraints) {
    final appTheme = context.carrotTheme;

    final size = Size(
      constraints.maxWidth.floorToDouble(),
      constraints.maxHeight.floorToDouble(),
    );

    final thickness = size.width / 8;

    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox.fromSize(
          size: size,
          child: AnimatedBuilder(
            animation: _animation!,
            builder: (context, child) => CustomPaint(
              isComplex: true,
              willChange: true,
              painter: _GaugePainter(
                repaint: _animation,
                size: size,
                trackColor: widget.trackColor ?? appTheme.gray[900],
                trackGradient: widget.trackGradient,
                trackOpacity: widget.trackOpacity,
                value: fractionalValue,
                valueColor: widget.valueColor,
              ),
            ),
          ),
        ),
        Positioned.fill(
          left: thickness * 2,
          right: thickness * 2,
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) => Text(
                  value.toStringAsFixed(widget.fractionDigits),
                  style: TextStyle(
                    inherit: true,
                    fontFeatures: const [
                      FontFeature.tabularFigures(),
                    ],
                    fontSize: thickness * 1.8,
                    fontWeight: FontWeight.w700,
                    height: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.label != null || widget.maxLabel != null || widget.minLabel != null)
          Positioned(
            left: thickness * 1.5,
            right: thickness * 1.5,
            bottom: 0,
            child: _GaugeLabels(
              label: widget.label,
              maxLabel: widget.maxLabel,
              minLabel: widget.minLabel,
            ),
          ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final Size size;
  final Color trackColor;
  final List<Color>? trackGradient;
  final double trackOpacity;
  final double value;
  final Color? valueColor;

  _GaugePainter({
    required this.size,
    required this.trackColor,
    required this.trackOpacity,
    required this.value,
    super.repaint,
    this.trackGradient,
    this.valueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = rect.center;
    const startAngle = 0.0;
    const endAngle = 240.0;
    final thickness = size.width / 8.0;
    final valueAngle = value * endAngle - 210;
    final valueOffset = Offset(
      math.cos(radians(valueAngle)) * thickness * 3.5 + center.dx,
      math.sin(radians(valueAngle)) * thickness * 3.5 + center.dy,
    );

    late Paint trackPaint;
    late Paint valuePaint;

    if (trackGradient != null) {
      final gradient = CarrotPaintingSweepGradient(
        center: center,
        colors: trackGradient!,
        stops: trackGradient!.mapIndexed((index, _) => index / (trackGradient!.length - 1)).toList(),
        startAngle: radians(startAngle),
        endAngle: radians(startAngle + endAngle),
      );

      trackPaint = Paint()
        ..color = const Color(0xFF000000).withOpacity(trackOpacity)
        ..shader = gradient
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke;

      valuePaint = Paint()
        ..color = valueColor ?? gradient.getColorAtPosition(value)
        ..style = PaintingStyle.fill;
    } else {
      trackPaint = Paint()
        ..color = trackColor.withOpacity(trackOpacity)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke;

      valuePaint = Paint()
        ..color = valueColor ?? trackColor
        ..style = PaintingStyle.fill;
    }

    canvas.saveLayer(rect.inflate(9), Paint());
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians(140));
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(rect.deflate(thickness * .5), radians(startAngle + 10), radians(endAngle), false, trackPaint);
    canvas.restore();
    canvas.drawCircle(valueOffset, thickness * .75, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
    canvas.drawCircle(valueOffset, thickness * .5, valuePaint);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return false;
  }
}

class _GaugeLabels extends StatelessWidget {
  final Widget? label;
  final String? maxLabel;
  final String? minLabel;

  const _GaugeLabels({
    this.label,
    this.maxLabel,
    this.minLabel,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      inherit: true,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1,
    );

    const maxMinStyle = TextStyle(
      inherit: true,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1,
    );

    const textHeightBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );

    return FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.scaleDown,
      child: CarrotRow(
        gap: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (minLabel != null)
            Text(
              minLabel!,
              style: maxMinStyle,
              textAlign: TextAlign.left,
              textHeightBehavior: textHeightBehavior,
            ),
          if (label != null)
            DefaultTextStyle(
              style: labelStyle,
              textAlign: TextAlign.center,
              textHeightBehavior: textHeightBehavior,
              child: label!,
            ),
          if (maxLabel != null)
            Text(
              maxLabel!,
              style: maxMinStyle,
              textAlign: TextAlign.right,
              textHeightBehavior: textHeightBehavior,
            ),
        ],
      ),
    );
  }
}

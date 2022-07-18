import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';

import 'primitive/bounce_tap.dart';
import 'basic.dart';

enum CarrotAppBarButtonLabelStyle {
  hidden,
  before,
  after,
}

class CarrotAppBarButton extends StatefulWidget {
  final Curve curve;
  final Duration duration;
  final Widget icon;
  final String label;
  final CarrotAppBarButtonLabelStyle labelStyle;
  final GestureTapCallback? onTap;

  const CarrotAppBarButton({
    super.key,
    required this.icon,
    required this.label,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 300),
    this.labelStyle = CarrotAppBarButtonLabelStyle.hidden,
    this.onTap,
  });

  @override
  createState() => _CarrotAppBarButton();
}

class _CarrotAppBarButton extends State<CarrotAppBarButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final defaultStyle = DefaultTextStyle.of(context);

    return CarrotBounceTap(
      onTap: widget.onTap,
      onDown: () => setState(() => _isPressed = true),
      onUp: () => setState(() => _isPressed = false),
      scale: .85,
      child: Semantics(
        label: widget.label,
        child: AnimatedContainer(
          curve: widget.curve,
          duration: widget.duration,
          decoration: BoxDecoration(
            borderRadius: appTheme.borderRadius,
            color: (defaultStyle.style.color ?? appTheme.gray[700]).withOpacity(_isPressed ? 0.1 : 0.0),
          ),
          padding: const EdgeInsets.all(9),
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(
              color: defaultStyle.style.color,
              fontSize: 20,
              shadows: defaultStyle.style.shadows,
            ),
            child: CarrotRow(
              children: [
                if (widget.labelStyle == CarrotAppBarButtonLabelStyle.before)
                  Text(
                    widget.label,
                    style: appTheme.typography.headline6.copyWith(
                      fontSize: 12,
                    ),
                  ),
                widget.icon,
                if (widget.labelStyle == CarrotAppBarButtonLabelStyle.after)
                  Text(
                    widget.label,
                    style: appTheme.typography.headline6.copyWith(
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';
import 'primitive/bounce_tap_builder.dart';
import 'row.dart';

enum CarrotAppBarButtonLabelStyle {
  hidden,
  before,
  after,
}

class CarrotAppBarButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final defaultStyle = DefaultTextStyle.of(context);

    return CarrotBounceTapBuilder(
      onTap: onTap,
      scale: .85,
      builder: (context, isTapDown) => Semantics(
        label: label,
        child: AnimatedContainer(
          curve: curve,
          duration: duration,
          decoration: BoxDecoration(
            borderRadius: appTheme.borderRadius,
            color: (defaultStyle.style.color ?? appTheme.gray[700]).withOpacity(isTapDown ? 0.1 : 0.0),
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
                if (labelStyle == CarrotAppBarButtonLabelStyle.before)
                  Text(
                    label,
                    style: appTheme.typography.headline6.copyWith(
                      fontSize: 12,
                    ),
                  ),
                icon,
                if (labelStyle == CarrotAppBarButtonLabelStyle.after)
                  Text(
                    label,
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

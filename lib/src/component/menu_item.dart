import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../extension/extension.dart';
import 'icon.dart';
import 'primitive/primitive.dart';
import 'row.dart';

class CarrotMenuItem extends StatelessWidget {
  final Curve curve;
  final Duration duration;
  final String? icon;
  final String? iconAfter;
  final Color? iconAfterColor;
  final Color? iconColor;
  final Widget label;
  final EdgeInsets padding;
  final GestureTapCallback? onTap;

  const CarrotMenuItem({
    super.key,
    required this.label,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 210),
    this.icon,
    this.iconAfter,
    this.iconAfterColor,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 15,
    ),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final localDuration = appTheme.isAnimating ? Duration.zero : duration;

    return CarrotBackgroundTap(
      background: appTheme.defaults.content,
      backgroundTap: appTheme.gray[50],
      duration: localDuration,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: CarrotRow(
          gap: 18,
          children: [
            if (icon != null)
              CarrotIcon(
                color: iconColor ?? appTheme.primary[600],
                glyph: icon!,
                size: 20,
              ),
            Expanded(
              child: DefaultTextStyle(
                style: appTheme.typography.body1.copyWith(
                  color: appTheme.gray[800],
                  fontWeight: FontWeight.w600,
                ),
                child: label,
              ),
            ),
            if (iconAfter != null)
              CarrotIcon(
                color: iconAfterColor ?? appTheme.gray[400],
                glyph: iconAfter!,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../ui/ui.dart';

import 'button.dart';
import 'icon.dart';

class CarrotContainedButton extends StatelessWidget {
  final BorderRadius? borderRadius;
  final List<Widget> children;
  final CarrotColor? color;
  final Duration duration;
  final FocusNode? focusNode;
  final String? icon;
  final String? iconAfter;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final EdgeInsets? padding;
  final double scale;
  final double scaleTap;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowTap;
  final CarrotButtonSize size;
  final TextStyle? textStyle;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const CarrotContainedButton({
    super.key,
    required this.children,
    this.borderRadius,
    this.color,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.padding,
    this.scale = 1.0,
    this.scaleTap = .985,
    this.shadow = CarrotShadows.small,
    this.shadowTap = CarrotShadows.small,
    this.size = CarrotButtonSize.medium,
    this.textStyle,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  CarrotContainedButton.text({
    super.key,
    required Text text,
    this.borderRadius,
    this.color,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.padding,
    this.scale = 1.0,
    this.scaleTap = .985,
    this.shadow = CarrotShadows.small,
    this.shadowTap = CarrotShadows.small,
    this.size = CarrotButtonSize.medium,
    this.textStyle,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  }) : children = [text];

  @override
  build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final palette = color ?? appTheme.primary;
    final radius = borderRadius ?? appTheme.borderRadius;

    return CarrotButton(
      duration: duration,
      focusNode: focusNode,
      icon: icon,
      iconAfter: iconAfter,
      iconAfterStyle: iconAfterStyle,
      iconStyle: iconStyle,
      padding: padding,
      scale: scale,
      scaleTap: scaleTap,
      size: size,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      decoration: BoxDecoration(
        border: Border.all(color: palette[600]),
        borderRadius: radius,
        boxShadow: shadow,
        color: palette[500],
      ),
      decorationTap: BoxDecoration(
        border: Border.all(color: palette[700]),
        borderRadius: radius,
        boxShadow: shadowTap,
        color: palette[600],
      ),
      textStyle: textStyle ??
          appTheme.typography.button.copyWith(
            color: palette[0],
            fontSize: size == CarrotButtonSize.tiny ? 14 : null,
          ),
      children: children,
    );
  }
}

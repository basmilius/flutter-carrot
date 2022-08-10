import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../ui/ui.dart';

import 'button.dart';
import 'icon.dart';

class CarrotTextButton extends StatelessWidget {
  final CarrotColor? border;
  final BorderRadius? borderRadius;
  final List<Widget> children;
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

  const CarrotTextButton({
    super.key,
    required this.children,
    this.border,
    this.borderRadius,
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

  CarrotTextButton.text({
    super.key,
    required Text text,
    this.border,
    this.borderRadius,
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
    final borderColor = border?[300] ?? appTheme.gray[300];
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
        border: Border.all(color: borderColor.withOpacity(.35)),
        borderRadius: radius,
        boxShadow: shadow,
        color: appTheme.gray[0],
      ),
      decorationTap: BoxDecoration(
        border: Border.all(color: borderColor.withOpacity(.35)),
        borderRadius: radius,
        boxShadow: shadowTap,
        color: appTheme.gray[50],
      ),
      textStyle: textStyle ??
          appTheme.typography.button.copyWith(
            fontSize: size == CarrotButtonSize.tiny ? 14 : null,
          ),
      children: children,
    );
  }
}

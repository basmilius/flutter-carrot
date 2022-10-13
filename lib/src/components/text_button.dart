import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../ui/ui.dart';

import 'button.dart';
import 'icon.dart';

class CarrotTextButton extends StatelessWidget {
  final Color? background;
  final Color? backgroundTap;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<Widget> children;
  final Duration duration;
  final FocusNode? focusNode;
  final Color? foreground;
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
    this.background,
    this.backgroundTap,
    this.border,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.foreground,
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

  CarrotTextButton.icon({
    super.key,
    required CarrotIcon icon,
    this.background,
    this.backgroundTap,
    this.border,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.foreground,
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
  })  : children = [icon],
        icon = null,
        iconAfter = null,
        iconAfterStyle = CarrotIconStyle.regular,
        iconStyle = CarrotIconStyle.regular;

  CarrotTextButton.text({
    super.key,
    required Widget text,
    this.background,
    this.backgroundTap,
    this.border,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.foreground,
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
    final radius = borderRadius ?? appTheme.borderRadius;

    final border = this.border ??
        Border.all(
          color: appTheme.gray[300].withOpacity(.35),
          width: 1.0,
        );

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
        border: border,
        borderRadius: radius,
        boxShadow: shadow,
        color: background ?? appTheme.gray[0],
      ),
      decorationTap: BoxDecoration(
        border: border,
        borderRadius: radius,
        boxShadow: shadowTap,
        color: backgroundTap ?? background ?? appTheme.gray[50],
      ),
      textStyle: textStyle ??
          appTheme.typography.base.copyWith(
            color: foreground ?? appTheme.gray[700],
            fontSize: size == CarrotButtonSize.tiny ? 14 : null,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
      children: children,
    );
  }
}

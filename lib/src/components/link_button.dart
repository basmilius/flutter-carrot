import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../ui/ui.dart';

import 'button.dart';
import 'icon.dart';

class CarrotLinkButton extends StatelessWidget {
  final List<Widget> children;
  final CarrotColor? border;
  final Duration duration;
  final FocusNode? focusNode;
  final String? icon;
  final String? iconAfter;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final bool isPrimary;
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

  const CarrotLinkButton({
    super.key,
    required this.children,
    this.border,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.isPrimary = false,
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

  CarrotLinkButton.text({
    super.key,
    required Widget text,
    this.border,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.isPrimary = false,
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
        borderRadius: appTheme.borderRadius,
        color: appTheme.gray[100].withOpacity(.0),
      ),
      decorationTap: BoxDecoration(
        borderRadius: appTheme.borderRadius,
        color: appTheme.gray[100],
      ),
      textStyle: textStyle ??
          appTheme.typography.button.copyWith(
            color: isPrimary ? appTheme.primary : null,
            fontSize: size == CarrotButtonSize.tiny ? 14 : null,
          ),
      children: children,
    );
  }
}

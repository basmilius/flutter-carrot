import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../theme/theme.dart';
import 'button.dart';
import 'icon.dart';

class CarrotContainedButton extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final FocusNode? focusNode;
  final String? icon;
  final String? iconAfter;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final double scale;
  final double scaleTap;
  final CarrotButtonSize size;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const CarrotContainedButton({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.scale = 1.0,
    this.scaleTap = .985,
    this.size = CarrotButtonSize.medium,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  CarrotContainedButton.text({
    super.key,
    required Widget text,
    this.duration = const Duration(milliseconds: 240),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.scale = 1.0,
    this.scaleTap = .985,
    this.size = CarrotButtonSize.medium,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  }) : children = [text];

  @override
  build(BuildContext context) {
    final containedButtonTheme = CarrotContainedButtonTheme.of(context);

    return CarrotButton(
      duration: duration,
      focusNode: focusNode,
      icon: icon,
      iconAfter: iconAfter,
      iconAfterStyle: iconAfterStyle,
      iconStyle: iconStyle,
      padding: containedButtonTheme.padding,
      scale: scale,
      scaleTap: scaleTap,
      size: size,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      decoration: BoxDecoration(
        border: containedButtonTheme.border,
        borderRadius: containedButtonTheme.borderRadius,
        boxShadow: containedButtonTheme.shadow,
        color: containedButtonTheme.backgroundColor,
      ),
      decorationTap: BoxDecoration(
        border: containedButtonTheme.borderActive,
        borderRadius: containedButtonTheme.borderRadius,
        boxShadow: containedButtonTheme.shadowActive,
        color: containedButtonTheme.backgroundColorActive,
      ),
      textStyle: context.carrotTypography.base.copyWith(
        color: containedButtonTheme.color,
        fontSize: size == CarrotButtonSize.tiny ? 14 : null,
        fontWeight: containedButtonTheme.fontWeight,
        height: 1.45,
      ),
      children: children,
    );
  }
}

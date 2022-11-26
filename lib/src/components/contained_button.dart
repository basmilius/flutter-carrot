part of 'button.dart';

class CarrotContainedButton extends _CarrotButton {
  const CarrotContainedButton({
    super.key,
    required super.children,
    super.curve,
    super.duration,
    super.focusNode,
    super.icon,
    super.iconAfter,
    super.size,
    super.onTap,
  });

  CarrotContainedButton.icon({
    super.key,
    required CarrotIcon icon,
    super.curve,
    super.duration,
    super.focusNode,
    super.size,
    super.onTap,
  }) : super(
          children: [icon],
          icon: null,
          iconAfter: null,
          type: _CarrotButtonType.icon,
        );

  CarrotContainedButton.text({
    super.key,
    required Widget text,
    super.curve,
    super.duration,
    super.focusNode,
    super.icon,
    super.iconAfter,
    super.size,
    super.onTap,
  }) : super(
          children: [text],
        );

  @override
  _CarrotButtonStyle _getStyle(BuildContext context) {
    final containedButtonTheme = CarrotContainedButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: BoxDecoration(
        border: containedButtonTheme.border,
        borderRadius: containedButtonTheme.borderRadius,
        boxShadow: containedButtonTheme.shadow,
        color: containedButtonTheme.backgroundColor,
      ),
      decorationActive: BoxDecoration(
        border: containedButtonTheme.borderActive,
        borderRadius: containedButtonTheme.borderRadius,
        boxShadow: containedButtonTheme.shadowActive,
        color: containedButtonTheme.backgroundColorActive,
      ),
      iconAfterStyle: containedButtonTheme.iconAfterStyle,
      iconStyle: containedButtonTheme.iconStyle,
      padding: containedButtonTheme.padding,
      textStyle: context.carrotTypography.base.copyWith(
        color: containedButtonTheme.color,
        fontSize: size == CarrotButtonSize.tiny ? 14 : null,
        fontWeight: containedButtonTheme.fontWeight,
        height: 1.45,
      ),
    );
  }
}

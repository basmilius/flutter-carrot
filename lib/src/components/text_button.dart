part of 'button.dart';

class CarrotTextButton extends _CarrotButton {
  const CarrotTextButton({
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

  CarrotTextButton.icon({
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

  CarrotTextButton.text({
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
    final textButtonTheme = CarrotTextButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: BoxDecoration(
        border: textButtonTheme.border,
        borderRadius: textButtonTheme.borderRadius,
        boxShadow: textButtonTheme.shadow,
        color: textButtonTheme.backgroundColor,
      ),
      decorationActive: BoxDecoration(
        border: textButtonTheme.borderActive,
        borderRadius: textButtonTheme.borderRadius,
        boxShadow: textButtonTheme.shadowActive,
        color: textButtonTheme.backgroundColorActive,
      ),
      iconAfterStyle: textButtonTheme.iconAfterStyle,
      iconStyle: textButtonTheme.iconStyle,
      padding: textButtonTheme.padding,
      tapScale: .985,
      textStyle: context.carrotTypography.base.copyWith(
        color: textButtonTheme.color,
        fontSize: size == CarrotButtonSize.tiny ? 14 : null,
        fontWeight: textButtonTheme.fontWeight,
        height: 1.45,
      ),
    );
  }
}

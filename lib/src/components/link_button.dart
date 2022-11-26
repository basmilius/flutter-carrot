part of 'button.dart';

class CarrotLinkButton extends _CarrotButton {
  const CarrotLinkButton({
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

  CarrotLinkButton.icon({
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

  CarrotLinkButton.text({
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
    final linkButtonTheme = CarrotLinkButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: BoxDecoration(
        border: linkButtonTheme.border,
        borderRadius: linkButtonTheme.borderRadius,
        boxShadow: linkButtonTheme.shadow,
        color: linkButtonTheme.backgroundColor,
      ),
      decorationActive: BoxDecoration(
        border: linkButtonTheme.borderActive,
        borderRadius: linkButtonTheme.borderRadius,
        boxShadow: linkButtonTheme.shadowActive,
        color: linkButtonTheme.backgroundColorActive,
      ),
      iconAfterStyle: linkButtonTheme.iconAfterStyle,
      iconStyle: linkButtonTheme.iconStyle,
      padding: linkButtonTheme.padding,
      textStyle: context.carrotTypography.base.copyWith(
        color: linkButtonTheme.color,
        fontSize: size == CarrotButtonSize.tiny ? 14 : null,
        fontWeight: linkButtonTheme.fontWeight,
        height: 1.45,
      ),
    );
  }
}

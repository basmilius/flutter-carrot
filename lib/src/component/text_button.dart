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
    final appTheme = context.carrotTheme;
    final textButtonTheme = CarrotTextButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: textButtonTheme.decoration,
      decorationActive: textButtonTheme.decorationActive,
      iconAfterStyle: appTheme.defaults.iconStyle,
      iconStyle: appTheme.defaults.iconStyle,
      padding: textButtonTheme.padding,
      tapScale: textButtonTheme.tapScale,
      textStyle: _mergeTextStyle(context, textButtonTheme.textStyle),
      textStyleActive: _mergeTextStyle(context, textButtonTheme.textStyleActive),
    );
  }
}

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
    super.loading,
    super.size,
    super.onTap,
  });

  const CarrotTextButton.icon({
    super.key,
    required super.icon,
    super.curve,
    super.duration,
    super.focusNode,
    super.loading,
    super.size,
    super.onTap,
  }) : super(
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
    super.loading,
    super.size,
    super.onTap,
  }) : super(
          children: [text],
        );

  @override
  _CarrotButtonStyle _getStyle(BuildContext context) {
    final textButtonTheme = CarrotTextButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: textButtonTheme.decoration,
      decorationActive: textButtonTheme.decorationActive,
      padding: textButtonTheme.padding,
      tapScale: textButtonTheme.tapScale,
      textStyle: _mergeTextStyle(context, textButtonTheme.textStyle),
      textStyleActive: _mergeTextStyle(context, textButtonTheme.textStyleActive),
    );
  }
}

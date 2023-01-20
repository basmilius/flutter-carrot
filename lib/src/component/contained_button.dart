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
      decoration: containedButtonTheme.decoration,
      decorationActive: containedButtonTheme.decorationActive,
      padding: containedButtonTheme.padding,
      tapScale: containedButtonTheme.tapScale,
      textStyle: _mergeTextStyle(context, containedButtonTheme.textStyle),
      textStyleActive: _mergeTextStyle(context, containedButtonTheme.textStyleActive),
    );
  }
}

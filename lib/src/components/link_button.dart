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
    final appTheme = context.carrotTheme;
    final linkButtonTheme = CarrotLinkButtonTheme.of(context);

    return _CarrotButtonStyle(
      decoration: linkButtonTheme.decoration,
      decorationActive: linkButtonTheme.decorationActive,
      iconAfterStyle: appTheme.defaults.iconStyle,
      iconStyle: appTheme.defaults.iconStyle,
      padding: linkButtonTheme.padding,
      tapScale: linkButtonTheme.tapScale,
      textStyle: _mergeTextStyle(context, linkButtonTheme.textStyle),
      textStyleActive: _mergeTextStyle(context, linkButtonTheme.textStyleActive),
    );
  }
}

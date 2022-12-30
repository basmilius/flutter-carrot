part of 'button.dart';

class CarrotCustomButton extends _CarrotButton {
  final BoxDecoration decoration;
  final BoxDecoration decorationTap;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final EdgeInsets padding;

  const CarrotCustomButton({
    super.key,
    required super.children,
    required this.decoration,
    required this.decorationTap,
    super.curve,
    super.duration,
    super.focusNode,
    super.icon,
    super.iconAfter,
    super.size,
    super.onTap,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.padding = EdgeInsets.zero,
  });

  @override
  _CarrotButtonStyle _getStyle(BuildContext context) {
    return _CarrotButtonStyle(
      decoration: decoration,
      decorationActive: decorationTap,
      iconAfterStyle: iconAfterStyle,
      iconStyle: iconStyle,
      padding: padding,
      tapScale: .985,
      textStyle: context.carrotTypography.base,
    );
  }
}

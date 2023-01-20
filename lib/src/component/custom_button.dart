part of 'button.dart';

class CarrotCustomButton extends _CarrotButton {
  final BoxDecoration decoration;
  final BoxDecoration decorationTap;
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
    this.padding = EdgeInsets.zero,
  });

  @override
  _CarrotButtonStyle _getStyle(BuildContext context) {
    return _CarrotButtonStyle(
      decoration: decoration,
      decorationActive: decorationTap,
      padding: padding,
      tapScale: .985,
      textStyle: context.carrotTypography.base,
      textStyleActive: context.carrotTypography.base,
    );
  }
}

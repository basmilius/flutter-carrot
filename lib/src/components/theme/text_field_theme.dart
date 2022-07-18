import 'package:flutter/widgets.dart';

import '../../ui/ui.dart';
import '_component_theme.dart';

class CarrotTextFieldTheme extends CarrotComponentTheme {
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? cursorColor;
  final String? obscuringCharacter;
  final Color? selectionColor;
  final TextStyle? textPlaceholderStyle;
  final TextStyle? textStyle;

  const CarrotTextFieldTheme({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.cursorColor,
    this.obscuringCharacter,
    this.selectionColor,
    this.textPlaceholderStyle,
    this.textStyle,
  });
}

class CarrotTextFieldThemeProxy extends CarrotComponentThemeProxy<CarrotTextFieldThemeProxy, CarrotTextFieldTheme> {
  Color get backgroundColor => walk((data) => data.backgroundColor, gray(100));
  Color get borderColor => walk((data) => data.borderColor, CarrotColors.transparent);
  double get borderWidth => walk((data) => data.borderWidth, 1.0);
  Color get cursorColor => walk((data) => data.cursorColor, primary(500));
  String get obscuringCharacter => walk((data) => data.obscuringCharacter, "•");
  Color get selectionColor => walk((data) => data.selectionColor, primary(100));
  TextStyle get textPlaceholderStyle => walk((data) => data.textPlaceholderStyle, typography.base.copyWith(
    color: (typography.base.color ?? gray(600)).withOpacity(darkMode ? 1 : .5),
  ));
  TextStyle get textStyle => walk((data) => data.textStyle, typography.body1);

  Border get border => Border.all(
    color: borderColor,
    width: borderWidth,
  );

  CarrotTextFieldThemeProxy({
    required super.data,
    super.parent,
  });

  @override
  CarrotTextFieldThemeProxy extend(other) => other == null ? this : CarrotTextFieldThemeProxy(data: other, parent: this);
}

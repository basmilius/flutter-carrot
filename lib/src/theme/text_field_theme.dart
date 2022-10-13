import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotTextFieldTheme extends InheritedTheme {
  final CarrotTextFieldThemeData data;

  const CarrotTextFieldTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotTextFieldTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotTextFieldTheme(
      data: data,
      child: child,
    );
  }

  static CarrotTextFieldThemeData of(BuildContext context) {
    final textFieldTheme = context.dependOnInheritedWidgetOfExactType<CarrotTextFieldTheme>();

    return textFieldTheme?.data ?? CarrotTheme.of(context).textFieldTheme;
  }
}

class CarrotTextFieldThemeData {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color cursorColor;
  final String obscuringCharacter;
  final Color selectionColor;
  final TextStyle textPlaceholderStyle;
  final TextStyle textStyle;

  Border get border => Border.all(
        color: borderColor,
        width: borderWidth,
      );

  const CarrotTextFieldThemeData.raw({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.cursorColor,
    required this.obscuringCharacter,
    required this.selectionColor,
    required this.textPlaceholderStyle,
    required this.textStyle,
  });

  factory CarrotTextFieldThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? cursorColor,
    String? obscuringCharacter,
    Color? selectionColor,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) {
    backgroundColor ??= theme.gray[100];
    borderColor ??= CarrotColors.transparent;
    borderWidth ??= 1.0;
    cursorColor ??= theme.primary[500];
    obscuringCharacter ??= '•';
    selectionColor ??= theme.primary[100];
    textPlaceholderStyle ??= theme.typography.body1.copyWith(
      color: theme.gray[600].withOpacity(theme.isDark ? 1 : .5),
    );
    textStyle ??= theme.typography.body1;

    return CarrotTextFieldThemeData.raw(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      cursorColor: cursorColor,
      obscuringCharacter: obscuringCharacter,
      selectionColor: selectionColor,
      textPlaceholderStyle: textPlaceholderStyle,
      textStyle: textStyle,
    );
  }

  factory CarrotTextFieldThemeData.dark(CarrotThemeDataBase theme) => CarrotTextFieldThemeData(
        theme,
      );

  factory CarrotTextFieldThemeData.light(CarrotThemeDataBase theme) => CarrotTextFieldThemeData(
        theme,
      );
}

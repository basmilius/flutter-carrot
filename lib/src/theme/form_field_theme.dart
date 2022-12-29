import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotFormFieldTheme extends InheritedTheme {
  final CarrotFormFieldThemeData data;

  const CarrotFormFieldTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotFormFieldTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotFormFieldTheme(
      data: data,
      child: child,
    );
  }

  static CarrotFormFieldThemeData of(BuildContext context) {
    final formFieldTheme = context.dependOnInheritedWidgetOfExactType<CarrotFormFieldTheme>();

    return formFieldTheme?.data ?? CarrotTheme.of(context).formFieldTheme;
  }
}

class CarrotFormFieldThemeData {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color cursorColor;
  final String obscuringCharacter;
  final EdgeInsets padding;
  final Color selectionColor;
  final StrutStyle strutStyle;
  final TextStyle textPlaceholderStyle;
  final TextStyle textStyle;

  Border get border => Border.all(
        color: borderColor,
        width: borderWidth,
      );

  const CarrotFormFieldThemeData.raw({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.cursorColor,
    required this.obscuringCharacter,
    required this.padding,
    required this.selectionColor,
    required this.strutStyle,
    required this.textPlaceholderStyle,
    required this.textStyle,
  });

  factory CarrotFormFieldThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? cursorColor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selectionColor,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) {
    backgroundColor ??= theme.gray[100];
    borderColor ??= CarrotColors.transparent;
    borderWidth ??= .0;
    cursorColor ??= theme.primary[500];
    obscuringCharacter ??= '•';
    padding ??= const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 11,
    );
    selectionColor ??= theme.primary[500].withOpacity(.35);
    strutStyle = const StrutStyle(
      height: 1.0,
    );
    textStyle ??= theme.typography.body1;
    textPlaceholderStyle ??= textStyle.copyWith(
      color: theme.gray[600].withOpacity(.5),
    );

    return CarrotFormFieldThemeData.raw(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      cursorColor: cursorColor,
      obscuringCharacter: obscuringCharacter,
      padding: padding,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
      textPlaceholderStyle: textPlaceholderStyle,
      textStyle: textStyle,
    );
  }

  factory CarrotFormFieldThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? cursorColor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selectionColor,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) =>
      CarrotFormFieldThemeData(
        theme,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        cursorColor: cursorColor,
        obscuringCharacter: obscuringCharacter,
        padding: padding,
        selectionColor: selectionColor,
        strutStyle: strutStyle,
        textPlaceholderStyle: textPlaceholderStyle,
        textStyle: textStyle,
      );

  factory CarrotFormFieldThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? cursorColor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selectionColor,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) =>
      CarrotFormFieldThemeData(
        theme,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        cursorColor: cursorColor,
        obscuringCharacter: obscuringCharacter,
        padding: padding,
        selectionColor: selectionColor,
        strutStyle: strutStyle,
        textPlaceholderStyle: textPlaceholderStyle,
        textStyle: textStyle,
      );

  CarrotFormFieldThemeData copyWith(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? cursorColor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selectionColor,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) =>
      CarrotFormFieldThemeData(
        theme,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        cursorColor: cursorColor ?? this.cursorColor,
        obscuringCharacter: obscuringCharacter ?? this.obscuringCharacter,
        padding: padding ?? this.padding,
        selectionColor: selectionColor ?? this.selectionColor,
        strutStyle: strutStyle ?? this.strutStyle,
        textPlaceholderStyle: textPlaceholderStyle ?? this.textPlaceholderStyle,
        textStyle: textStyle ?? this.textStyle,
      );

  static CarrotFormFieldThemeData lerp(CarrotFormFieldThemeData a, CarrotFormFieldThemeData b, double t) {
    return CarrotFormFieldThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      cursorColor: Color.lerp(a.cursorColor, b.cursorColor, t)!,
      obscuringCharacter: t < .5 ? a.obscuringCharacter : b.obscuringCharacter,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t)!,
      strutStyle: t < .5 ? a.strutStyle : b.strutStyle,
      textPlaceholderStyle: TextStyle.lerp(a.textPlaceholderStyle, b.textPlaceholderStyle, t)!,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
    );
  }
}

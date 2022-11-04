import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotContainedButtonTheme extends InheritedTheme {
  final CarrotContainedButtonThemeData data;

  const CarrotContainedButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotContainedButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotContainedButtonTheme(
      data: data,
      child: child,
    );
  }

  static CarrotContainedButtonThemeData of(BuildContext context) {
    final containedButtonTheme = context.dependOnInheritedWidgetOfExactType<CarrotContainedButtonTheme>();

    return containedButtonTheme?.data ?? CarrotTheme.of(context).containedButtonTheme;
  }
}

class CarrotContainedButtonThemeData {
  final Color backgroundColor;
  final Color backgroundColorActive;
  final Color borderColor;
  final Color borderColorActive;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color color;
  final FontWeight fontWeight;
  final EdgeInsets? padding;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowActive;

  Border get border => Border.all(
        color: borderColor,
        width: borderWidth,
      );

  Border get borderActive => Border.all(
        color: borderColorActive,
        width: borderWidth,
      );

  const CarrotContainedButtonThemeData.raw({
    required this.backgroundColor,
    required this.backgroundColorActive,
    required this.borderColor,
    required this.borderColorActive,
    required this.borderRadius,
    required this.borderWidth,
    required this.color,
    required this.fontWeight,
    required this.shadow,
    required this.shadowActive,
    this.padding,
  });

  factory CarrotContainedButtonThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) {
    backgroundColor ??= theme.primary[500];
    backgroundColorActive ??= theme.primary[600];
    borderColor ??= theme.primary[600];
    borderColorActive ??= theme.primary[700];
    borderRadius ??= theme.borderRadius;
    borderWidth ??= 1.0;
    fontWeight ??= FontWeight.w600;
    color ??= theme.primary[0];
    shadow ??= CarrotShadows.small;
    shadowActive ??= CarrotShadows.small;

    return CarrotContainedButtonThemeData.raw(
      backgroundColor: backgroundColor,
      backgroundColorActive: backgroundColorActive,
      borderColor: borderColor,
      borderColorActive: borderColorActive,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      color: color,
      fontWeight: fontWeight,
      padding: padding,
      shadow: shadow,
      shadowActive: shadowActive,
    );
  }

  factory CarrotContainedButtonThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) =>
      CarrotContainedButtonThemeData(
        theme,
        backgroundColor: backgroundColor ?? theme.primary[400],
        backgroundColorActive: backgroundColorActive ?? theme.primary[500],
        borderColor: borderColor ?? theme.primary[500],
        borderColorActive: borderColorActive ?? theme.primary[600],
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        color: color ?? theme.primary[900],
        fontWeight: fontWeight,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
      );

  factory CarrotContainedButtonThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) =>
      CarrotContainedButtonThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        borderColor: borderColor,
        borderColorActive: borderColorActive,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        color: color,
        fontWeight: fontWeight,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
      );

  static CarrotContainedButtonThemeData lerp(CarrotContainedButtonThemeData a, CarrotContainedButtonThemeData b, double t) {
    return CarrotContainedButtonThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      backgroundColorActive: Color.lerp(a.backgroundColorActive, b.backgroundColorActive, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderColorActive: Color.lerp(a.borderColorActive, b.borderColorActive, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      color: Color.lerp(a.color, b.color, t)!,
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t)!,
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      shadow: t < .5 ? a.shadow : b.shadow,
      shadowActive: t < .5 ? a.shadowActive : b.shadowActive,
    );
  }
}

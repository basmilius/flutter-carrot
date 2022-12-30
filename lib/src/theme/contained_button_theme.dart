import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../components/components.dart';
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
  final Border border;
  final Border borderActive;
  final BorderRadius borderRadius;
  final Color color;
  final FontWeight fontWeight;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final EdgeInsets? padding;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowActive;
  final double tapScale;

  const CarrotContainedButtonThemeData.raw({
    required this.backgroundColor,
    required this.backgroundColorActive,
    required this.border,
    required this.borderActive,
    required this.borderRadius,
    required this.color,
    required this.fontWeight,
    required this.iconAfterStyle,
    required this.iconStyle,
    required this.shadow,
    required this.shadowActive,
    required this.tapScale,
    this.padding,
  });

  factory CarrotContainedButtonThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) {
    backgroundColor ??= theme.primary[500];
    backgroundColorActive ??= theme.primary[600];
    border ??= Border.all(
      color: CarrotColors.transparent,
      width: 1.0,
    );
    borderActive ??= border;
    borderRadius ??= theme.borderRadius;
    color ??= theme.primary.text;
    fontWeight ??= FontWeight.w600;
    iconAfterStyle ??= CarrotIconStyle.regular;
    iconStyle ??= CarrotIconStyle.regular;
    shadow ??= CarrotShadows.small;
    shadowActive ??= shadow;
    tapScale ??= .985;

    return CarrotContainedButtonThemeData.raw(
      backgroundColor: backgroundColor,
      backgroundColorActive: backgroundColorActive,
      border: border,
      borderActive: borderActive,
      borderRadius: borderRadius,
      color: color,
      fontWeight: fontWeight,
      iconAfterStyle: iconAfterStyle,
      iconStyle: iconStyle,
      padding: padding,
      shadow: shadow,
      shadowActive: shadowActive,
      tapScale: tapScale,
    );
  }

  factory CarrotContainedButtonThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) =>
      CarrotContainedButtonThemeData(
        theme,
        backgroundColor: backgroundColor ?? theme.primary[400],
        backgroundColorActive: backgroundColorActive ?? theme.primary[500],
        border: border ??
            Border.all(
              color: theme.primary[500],
              width: 1.0,
            ),
        borderActive: borderActive ?? border,
        borderRadius: borderRadius,
        color: color ?? theme.primary[900],
        fontWeight: fontWeight,
        iconAfterStyle: iconAfterStyle,
        iconStyle: iconStyle,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
        tapScale: tapScale,
      );

  factory CarrotContainedButtonThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) =>
      CarrotContainedButtonThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        border: border,
        borderActive: borderActive,
        borderRadius: borderRadius,
        color: color,
        fontWeight: fontWeight,
        iconAfterStyle: iconAfterStyle,
        iconStyle: iconStyle,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
        tapScale: tapScale,
      );

  CarrotContainedButtonThemeData copyWith(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) =>
      CarrotContainedButtonThemeData(
        theme,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundColorActive: backgroundColorActive ?? this.backgroundColorActive,
        border: border ?? this.border,
        borderActive: borderActive ?? this.borderActive,
        borderRadius: borderRadius ?? this.borderRadius,
        color: color ?? this.color,
        fontWeight: fontWeight ?? this.fontWeight,
        iconAfterStyle: iconAfterStyle ?? this.iconAfterStyle,
        iconStyle: iconStyle ?? this.iconStyle,
        padding: padding ?? this.padding,
        shadow: shadow ?? this.shadow,
        shadowActive: shadowActive ?? this.shadowActive,
        tapScale: tapScale ?? this.tapScale,
      );

  static CarrotContainedButtonThemeData lerp(CarrotContainedButtonThemeData a, CarrotContainedButtonThemeData b, double t) {
    return CarrotContainedButtonThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      backgroundColorActive: Color.lerp(a.backgroundColorActive, b.backgroundColorActive, t)!,
      border: Border.lerp(a.border, b.border, t)!,
      borderActive: Border.lerp(a.borderActive, b.borderActive, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      color: Color.lerp(a.color, b.color, t)!,
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t)!,
      iconAfterStyle: t < .5 ? a.iconAfterStyle : b.iconAfterStyle,
      iconStyle: t < .5 ? a.iconStyle : b.iconStyle,
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      shadow: t < .5 ? a.shadow : b.shadow,
      shadowActive: t < .5 ? a.shadowActive : b.shadowActive,
      tapScale: lerpDouble(a.tapScale, b.tapScale, t)!,
    );
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../components/components.dart';
import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotLinkButtonTheme extends InheritedTheme {
  final CarrotLinkButtonThemeData data;

  const CarrotLinkButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotLinkButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotLinkButtonTheme(
      data: data,
      child: child,
    );
  }

  static CarrotLinkButtonThemeData of(BuildContext context) {
    final linkButtonTheme = context.dependOnInheritedWidgetOfExactType<CarrotLinkButtonTheme>();

    return linkButtonTheme?.data ?? CarrotTheme.of(context).linkButtonTheme;
  }
}

class CarrotLinkButtonThemeData {
  final Color backgroundColor;
  final Color backgroundColorActive;
  final Color borderColor;
  final Color borderColorActive;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color color;
  final FontWeight fontWeight;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
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

  const CarrotLinkButtonThemeData.raw({
    required this.backgroundColor,
    required this.backgroundColorActive,
    required this.borderColor,
    required this.borderColorActive,
    required this.borderRadius,
    required this.borderWidth,
    required this.color,
    required this.fontWeight,
    required this.iconAfterStyle,
    required this.iconStyle,
    required this.shadow,
    required this.shadowActive,
    this.padding,
  });

  factory CarrotLinkButtonThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) {
    backgroundColor ??= theme.gray[100].withOpacity(.0);
    backgroundColorActive ??= theme.gray[100];
    borderColor ??= backgroundColor;
    borderColorActive ??= backgroundColorActive;
    borderRadius ??= theme.borderRadius;
    borderWidth ??= .0;
    color ??= theme.gray[700];
    fontWeight ??= FontWeight.w600;
    iconAfterStyle ??= CarrotIconStyle.regular;
    iconStyle ??= CarrotIconStyle.regular;
    shadow ??= CarrotShadows.none;
    shadowActive ??= CarrotShadows.none;

    return CarrotLinkButtonThemeData.raw(
      backgroundColor: backgroundColor,
      backgroundColorActive: backgroundColorActive,
      borderColor: borderColor,
      borderColorActive: borderColorActive,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      color: color,
      fontWeight: fontWeight,
      iconAfterStyle: iconAfterStyle,
      iconStyle: iconStyle,
      padding: padding,
      shadow: shadow,
      shadowActive: shadowActive,
    );
  }

  factory CarrotLinkButtonThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) =>
      CarrotLinkButtonThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        borderColor: borderColor,
        borderColorActive: borderColorActive,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        color: color,
        fontWeight: fontWeight,
        iconAfterStyle: iconAfterStyle,
        iconStyle: iconStyle,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
      );

  factory CarrotLinkButtonThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) =>
      CarrotLinkButtonThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        borderColor: borderColor,
        borderColorActive: borderColorActive,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        color: color,
        fontWeight: fontWeight,
        iconAfterStyle: iconAfterStyle,
        iconStyle: iconStyle,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
      );

  CarrotLinkButtonThemeData copyWith(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    Color? borderColor,
    Color? borderColorActive,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    FontWeight? fontWeight,
    CarrotIconStyle? iconAfterStyle,
    CarrotIconStyle? iconStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
  }) =>
      CarrotLinkButtonThemeData(
        theme,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundColorActive: backgroundColorActive ?? this.backgroundColorActive,
        borderColor: borderColor ?? this.borderColor,
        borderColorActive: borderColorActive ?? this.borderColorActive,
        borderRadius: borderRadius ?? this.borderRadius,
        borderWidth: borderWidth ?? this.borderWidth,
        color: color ?? this.color,
        fontWeight: fontWeight ?? this.fontWeight,
        iconAfterStyle: iconAfterStyle ?? this.iconAfterStyle,
        iconStyle: iconStyle ?? this.iconStyle,
        padding: padding ?? this.padding,
        shadow: shadow ?? this.shadow,
        shadowActive: shadowActive ?? this.shadowActive,
      );

  static CarrotLinkButtonThemeData lerp(CarrotLinkButtonThemeData a, CarrotLinkButtonThemeData b, double t) {
    return CarrotLinkButtonThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      backgroundColorActive: Color.lerp(a.backgroundColorActive, b.backgroundColorActive, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderColorActive: Color.lerp(a.borderColorActive, b.borderColorActive, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      color: Color.lerp(a.color, b.color, t)!,
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t)!,
      iconAfterStyle: t < .5 ? a.iconAfterStyle : b.iconAfterStyle,
      iconStyle: t < .5 ? a.iconStyle : b.iconStyle,
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      shadow: t < .5 ? a.shadow : b.shadow,
      shadowActive: t < .5 ? a.shadowActive : b.shadowActive,
    );
  }
}

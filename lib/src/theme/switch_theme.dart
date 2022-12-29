import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotSwitchTheme extends InheritedTheme {
  final CarrotSwitchThemeData data;

  const CarrotSwitchTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotSwitchTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotSwitchTheme(
      data: data,
      child: child,
    );
  }

  static CarrotSwitchThemeData of(BuildContext context) {
    final switchTheme = context.dependOnInheritedWidgetOfExactType<CarrotSwitchTheme>();

    return switchTheme?.data ?? CarrotTheme.of(context).switchTheme;
  }
}

class CarrotSwitchThemeData {
  final Color backgroundColor;
  final Color backgroundColorActive;
  final BorderRadius borderRadius;
  final Size size;
  final BorderRadius toggleBorderRadius;
  final Color toggleColor;
  final Color toggleColorActive;
  final double toggleMargin;
  final List<BoxShadow> toggleShadow;
  final List<BoxShadow> toggleShadowPressed;

  const CarrotSwitchThemeData.raw({
    required this.backgroundColor,
    required this.backgroundColorActive,
    required this.borderRadius,
    required this.size,
    required this.toggleBorderRadius,
    required this.toggleColor,
    required this.toggleColorActive,
    required this.toggleMargin,
    required this.toggleShadow,
    required this.toggleShadowPressed,
  });

  factory CarrotSwitchThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggleColor,
    Color? toggleColorActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) {
    backgroundColor ??= theme.gray[100];
    backgroundColorActive ??= theme.primary;
    borderRadius ??= BorderRadius.circular(15);
    size ??= const Size(48, 30);
    toggleBorderRadius ??= borderRadius;
    toggleColor ??= theme.defaults.content;
    toggleColorActive ??= theme.defaults.content;
    toggleMargin ??= 3.0;
    toggleShadow ??= CarrotShadows.small;
    toggleShadowPressed ??= CarrotShadows.large;

    return CarrotSwitchThemeData.raw(
      backgroundColor: backgroundColor,
      backgroundColorActive: backgroundColorActive,
      borderRadius: borderRadius,
      size: size,
      toggleBorderRadius: toggleBorderRadius,
      toggleColor: toggleColor,
      toggleColorActive: toggleColorActive,
      toggleMargin: toggleMargin,
      toggleShadow: toggleShadow,
      toggleShadowPressed: toggleShadowPressed,
    );
  }

  factory CarrotSwitchThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggleColor,
    Color? toggleColorActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        borderRadius: borderRadius,
        size: size,
        toggleBorderRadius: toggleBorderRadius,
        toggleColor: toggleColor ?? theme.gray[300],
        toggleColorActive: toggleColorActive,
        toggleMargin: toggleMargin,
        toggleShadow: toggleShadow,
        toggleShadowPressed: toggleShadowPressed,
      );

  factory CarrotSwitchThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggleColor,
    Color? toggleColorActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData(
        theme,
        backgroundColor: backgroundColor,
        backgroundColorActive: backgroundColorActive,
        borderRadius: borderRadius,
        size: size,
        toggleBorderRadius: toggleBorderRadius,
        toggleColor: toggleColor,
        toggleColorActive: toggleColorActive,
        toggleMargin: toggleMargin,
        toggleShadow: toggleShadow,
        toggleShadowPressed: toggleShadowPressed,
      );

  CarrotSwitchThemeData copyWith(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? backgroundColorActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggleColor,
    Color? toggleColorActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData(
        theme,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundColorActive: backgroundColorActive ?? this.backgroundColorActive,
        borderRadius: borderRadius ?? this.borderRadius,
        size: size ?? this.size,
        toggleBorderRadius: toggleBorderRadius ?? this.toggleBorderRadius,
        toggleColor: toggleColor ?? this.toggleColor,
        toggleColorActive: toggleColorActive ?? this.toggleColorActive,
        toggleMargin: toggleMargin ?? this.toggleMargin,
        toggleShadow: toggleShadow ?? this.toggleShadow,
        toggleShadowPressed: toggleShadowPressed ?? this.toggleShadowPressed,
      );

  static CarrotSwitchThemeData lerp(CarrotSwitchThemeData a, CarrotSwitchThemeData b, double t) {
    return CarrotSwitchThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      backgroundColorActive: Color.lerp(a.backgroundColorActive, b.backgroundColorActive, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      size: Size.lerp(a.size, b.size, t)!,
      toggleBorderRadius: BorderRadius.lerp(a.toggleBorderRadius, b.toggleBorderRadius, t)!,
      toggleColor: Color.lerp(a.toggleColor, b.toggleColor, t)!,
      toggleColorActive: Color.lerp(a.toggleColorActive, b.toggleColorActive, t)!,
      toggleMargin: lerpDouble(a.toggleMargin, b.toggleMargin, t)!,
      toggleShadow: t < .5 ? a.toggleShadow : b.toggleShadow,
      toggleShadowPressed: t < .5 ? a.toggleShadowPressed : b.toggleShadowPressed,
    );
  }
}

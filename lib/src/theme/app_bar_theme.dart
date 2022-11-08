import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'carrot_theme.dart';

class CarrotAppBarTheme extends InheritedTheme {
  final CarrotAppBarThemeData data;

  const CarrotAppBarTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotAppBarTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotAppBarTheme(
      data: data,
      child: child,
    );
  }

  static CarrotAppBarThemeData of(BuildContext context) {
    final appBarTheme = context.dependOnInheritedWidgetOfExactType<CarrotAppBarTheme>();

    return appBarTheme?.data ?? CarrotTheme.of(context).appBarTheme;
  }
}

class CarrotAppBarThemeData {
  final Color backgroundColor;
  final Color foregroundColor;
  final Border? border;
  final List<BoxShadow> shadow;

  const CarrotAppBarThemeData.raw({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.shadow,
    this.border,
  });

  factory CarrotAppBarThemeData(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? foregroundColor,
    Border? border,
    List<BoxShadow>? shadow,
  }) {
    backgroundColor ??= theme.primary[700];
    foregroundColor ??= theme.primary[0];
    shadow ??= CarrotShadows.small;

    return CarrotAppBarThemeData.raw(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      border: border,
      shadow: shadow,
    );
  }

  factory CarrotAppBarThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? foregroundColor,
    Border? border,
    List<BoxShadow>? shadow,
  }) {
    return CarrotAppBarThemeData(
      theme,
      backgroundColor: backgroundColor ?? theme.primary[900],
      foregroundColor: foregroundColor ?? theme.primary[0],
      border: border,
      shadow: shadow,
    );
  }

  factory CarrotAppBarThemeData.light(
    CarrotThemeDataBase theme, {
    Color? backgroundColor,
    Color? foregroundColor,
    Border? border,
    List<BoxShadow>? shadow,
  }) {
    return CarrotAppBarThemeData(
      theme,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      border: border,
      shadow: shadow,
    );
  }

  static CarrotAppBarThemeData lerp(CarrotAppBarThemeData a, CarrotAppBarThemeData b, double t) {
    return CarrotAppBarThemeData.raw(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      border: Border.lerp(a.border, b.border, t),
      shadow: t < .5 ? a.shadow : b.shadow,
    );
  }
}

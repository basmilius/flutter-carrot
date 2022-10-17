import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'carrot_theme.dart';

class CarrotNoticeTheme extends InheritedTheme {
  final CarrotNoticeThemeData data;

  const CarrotNoticeTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotNoticeTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotNoticeTheme(
      data: data,
      child: child,
    );
  }

  static CarrotNoticeThemeData of(BuildContext context) {
    final noticeTheme = context.dependOnInheritedWidgetOfExactType<CarrotNoticeTheme>();

    return noticeTheme?.data ?? CarrotTheme.of(context).noticeTheme;
  }
}

class CarrotNoticeThemeData {
  final int backgroundColorShade;
  final int foregroundColorShade;
  final int iconColorShade;
  final int titleColorShade;

  const CarrotNoticeThemeData.raw({
    required this.backgroundColorShade,
    required this.foregroundColorShade,
    required this.iconColorShade,
    required this.titleColorShade,
  });

  factory CarrotNoticeThemeData(
    CarrotThemeDataBase theme, {
    int? backgroundColorShade,
    int? foregroundColorShade,
    int? iconColorShade,
    int? titleColorShade,
  }) {
    backgroundColorShade ??= 100;
    foregroundColorShade ??= 700;
    iconColorShade ??= 500;
    titleColorShade ??= 500;

    return CarrotNoticeThemeData.raw(
      backgroundColorShade: backgroundColorShade,
      foregroundColorShade: foregroundColorShade,
      iconColorShade: iconColorShade,
      titleColorShade: titleColorShade,
    );
  }

  factory CarrotNoticeThemeData.dark(
    CarrotThemeDataBase theme, {
    int? backgroundColorShade,
    int? foregroundColorShade,
    int? iconColorShade,
    int? titleColorShade,
  }) {
    backgroundColorShade ??= 900;
    foregroundColorShade ??= 200;
    iconColorShade ??= 0;
    titleColorShade ??= 0;

    return CarrotNoticeThemeData(
      theme,
      backgroundColorShade: backgroundColorShade,
      foregroundColorShade: foregroundColorShade,
      iconColorShade: iconColorShade,
      titleColorShade: titleColorShade,
    );
  }

  factory CarrotNoticeThemeData.light(
    CarrotThemeDataBase theme, {
    int? backgroundColorShade,
    int? foregroundColorShade,
    int? iconColorShade,
    int? titleColorShade,
  }) {
    return CarrotNoticeThemeData(
      theme,
      backgroundColorShade: backgroundColorShade,
      foregroundColorShade: foregroundColorShade,
      iconColorShade: iconColorShade,
      titleColorShade: titleColorShade,
    );
  }

  static CarrotNoticeThemeData lerp(CarrotNoticeThemeData a, CarrotNoticeThemeData b, double t) {
    return CarrotNoticeThemeData.raw(
      backgroundColorShade: lerpDouble(a.backgroundColorShade, b.backgroundColorShade, t)!.toInt(),
      foregroundColorShade: lerpDouble(a.foregroundColorShade, b.foregroundColorShade, t)!.toInt(),
      iconColorShade: lerpDouble(a.iconColorShade, b.iconColorShade, t)!.toInt(),
      titleColorShade: lerpDouble(a.titleColorShade, b.titleColorShade, t)!.toInt(),
    );
  }
}

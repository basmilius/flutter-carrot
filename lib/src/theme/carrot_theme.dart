import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'contained_button_theme.dart';
import 'notice_theme.dart';
import 'text_field_theme.dart';
import 'typography.dart';

class CarrotTheme extends StatelessWidget {
  final Widget child;
  final CarrotThemeData data;

  const CarrotTheme({
    super.key,
    required this.child,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _InheritedCarrotTheme(
      theme: this,
      child: child,
    );
  }

  static CarrotThemeData of(BuildContext context) {
    return maybeOf(context) ?? CarrotThemeData.fallback();
  }

  static CarrotThemeData? maybeOf(BuildContext context) {
    final inheritedTheme = context.dependOnInheritedWidgetOfExactType<_InheritedCarrotTheme>();

    return inheritedTheme?.theme.data;
  }

  static Brightness brightnessOf(BuildContext context) {
    return maybeOf(context)?.brightness ?? MediaQuery.of(context).platformBrightness;
  }

  static Brightness? maybeBrightnessOf(BuildContext context) {
    return maybeOf(context)?.brightness ?? MediaQuery.maybeOf(context)?.platformBrightness;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<CarrotThemeData>('data', data, showName: false),
    );
  }
}

class CarrotThemeData extends CarrotThemeDataBase {
  final bool isAnimating;
  final CarrotContainedButtonThemeData containedButtonTheme;
  final CarrotNoticeThemeData noticeTheme;
  final CarrotTextFieldThemeData textFieldTheme;

  const CarrotThemeData.raw({
    required super.defaults,
    required super.typography,
    required super.brightness,
    required super.radius,
    required super.accent,
    required super.gray,
    required super.primary,
    required super.secondary,
    required this.containedButtonTheme,
    required this.noticeTheme,
    required this.textFieldTheme,
    this.isAnimating = false,
  });

  factory CarrotThemeData({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Brightness? brightness,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) {
    brightness ??= Brightness.light;
    radius ??= const Radius.circular(12);

    defaults ??= brightness == Brightness.light ? CarrotThemeDataDefaults.light(gray) : CarrotThemeDataDefaults.dark(gray);

    typography ??= CarrotTypography(gray, primary);

    final base = CarrotThemeDataBase(
      defaults: defaults,
      typography: typography,
      brightness: brightness,
      radius: radius,
      accent: accent,
      gray: gray,
      primary: primary,
      secondary: secondary,
    );

    containedButtonTheme ??= base.isLight ? CarrotContainedButtonThemeData.light(base) : CarrotContainedButtonThemeData.dark(base);
    noticeTheme ??= base.isLight ? CarrotNoticeThemeData.light(base) : CarrotNoticeThemeData.dark(base);
    textFieldTheme ??= base.isLight ? CarrotTextFieldThemeData.light(base) : CarrotTextFieldThemeData.dark(base);

    return CarrotThemeData.raw(
      defaults: base.defaults,
      typography: base.typography,
      brightness: base.brightness,
      radius: base.radius,
      accent: base.accent,
      gray: base.gray,
      primary: base.primary,
      secondary: base.secondary,
      containedButtonTheme: containedButtonTheme,
      noticeTheme: noticeTheme,
      textFieldTheme: textFieldTheme,
    );
  }

  factory CarrotThemeData.dark({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) =>
      CarrotThemeData(
        defaults: defaults,
        typography: typography,
        brightness: Brightness.dark,
        radius: radius,
        accent: accent,
        gray: gray,
        primary: primary,
        secondary: secondary,
        containedButtonTheme: containedButtonTheme,
        noticeTheme: noticeTheme,
        textFieldTheme: textFieldTheme,
      );

  factory CarrotThemeData.light({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) =>
      CarrotThemeData(
        defaults: defaults,
        typography: typography,
        brightness: Brightness.light,
        radius: radius,
        accent: accent,
        gray: gray,
        primary: primary,
        secondary: secondary,
        containedButtonTheme: containedButtonTheme,
        noticeTheme: noticeTheme,
        textFieldTheme: textFieldTheme,
      );

  factory CarrotThemeData.fallback() => CarrotThemeData.light();

  T resolve<T>(T light, T dark) {
    if (isDark) {
      return dark;
    }

    return light;
  }

  static CarrotThemeData lerp(CarrotThemeData a, CarrotThemeData b, double t) {
    final base = CarrotThemeDataBase.lerp(a, b, t);

    return CarrotThemeData.raw(
      isAnimating: t > 0 && t < 1,
      defaults: base.defaults,
      typography: base.typography,
      brightness: base.brightness,
      radius: base.radius,
      accent: base.accent,
      gray: base.gray,
      primary: base.primary,
      secondary: base.secondary,
      containedButtonTheme: CarrotContainedButtonThemeData.lerp(a.containedButtonTheme, b.containedButtonTheme, t),
      noticeTheme: CarrotNoticeThemeData.lerp(a.noticeTheme, b.noticeTheme, t),
      textFieldTheme: CarrotTextFieldThemeData.lerp(a.textFieldTheme, b.textFieldTheme, t),
    );
  }
}

class CarrotThemeDataBase {
  final CarrotThemeDataDefaults defaults;
  final CarrotTypography typography;

  final Brightness brightness;
  final Radius radius;

  final CarrotColor accent;
  final CarrotColor gray;
  final CarrotColor primary;
  final CarrotColor secondary;

  BorderRadius get borderRadius => BorderRadius.all(radius);

  bool get isDark => brightness == Brightness.dark;

  bool get isLight => brightness == Brightness.light;

  const CarrotThemeDataBase({
    required this.defaults,
    required this.typography,
    required this.brightness,
    required this.radius,
    required this.accent,
    required this.gray,
    required this.primary,
    required this.secondary,
  });

  static CarrotThemeDataBase lerp(CarrotThemeDataBase a, CarrotThemeDataBase b, double t) {
    return CarrotThemeDataBase(
      defaults: CarrotThemeDataDefaults.lerp(a.defaults, b.defaults, t),
      typography: CarrotTypography.lerp(a.typography, b.typography, t),
      brightness: t < .5 ? a.brightness : b.brightness,
      radius: Radius.lerp(a.radius, b.radius, t)!,
      accent: CarrotColor.lerp(a.accent, b.accent, t),
      gray: CarrotColor.lerp(a.gray, b.gray, t),
      primary: CarrotColor.lerp(a.primary, b.primary, t),
      secondary: CarrotColor.lerp(a.secondary, b.secondary, t),
    );
  }
}

class CarrotThemeDataDefaults {
  final Color background;
  final Color scrim;

  const CarrotThemeDataDefaults.raw({
    required this.background,
    required this.scrim,
  });

  factory CarrotThemeDataDefaults.dark(
    CarrotColor gray, {
    Color? background,
    Color? scrim,
  }) =>
      CarrotThemeDataDefaults.raw(
        background: background ?? gray[0],
        scrim: scrim ?? gray[100].withOpacity(.75),
      );

  factory CarrotThemeDataDefaults.light(
    CarrotColor gray, {
    Color? background,
    Color? scrim,
  }) =>
      CarrotThemeDataDefaults.raw(
        background: background ?? gray[0],
        scrim: scrim ?? gray[700].withOpacity(.75),
      );

  static CarrotThemeDataDefaults lerp(CarrotThemeDataDefaults a, CarrotThemeDataDefaults b, double t) {
    return CarrotThemeDataDefaults.raw(
      background: Color.lerp(a.background, b.background, t)!,
      scrim: Color.lerp(a.scrim, b.scrim, t)!,
    );
  }
}

class _InheritedCarrotTheme extends InheritedWidget {
  final CarrotTheme theme;

  const _InheritedCarrotTheme({
    required super.child,
    required this.theme,
  });

  @override
  bool updateShouldNotify(_InheritedCarrotTheme oldWidget) {
    return theme.data != oldWidget.theme.data;
  }
}

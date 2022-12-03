import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'app_bar_theme.dart';
import 'contained_button_theme.dart';
import 'link_button_theme.dart';
import 'notice_theme.dart';
import 'switch_theme.dart';
import 'text_button_theme.dart';
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
  final CarrotAppBarThemeData appBarTheme;
  final CarrotContainedButtonThemeData containedButtonTheme;
  final CarrotLinkButtonThemeData linkButtonTheme;
  final CarrotNoticeThemeData noticeTheme;
  final CarrotSwitchThemeData switchTheme;
  final CarrotTextButtonThemeData textButtonTheme;
  final CarrotTextFieldThemeData textFieldTheme;

  const CarrotThemeData.raw({
    required super.defaults,
    required super.typography,
    required super.brightness,
    required super.radius,
    required super.accent,
    required super.error,
    required super.gray,
    required super.primary,
    required super.secondary,
    required this.appBarTheme,
    required this.containedButtonTheme,
    required this.linkButtonTheme,
    required this.noticeTheme,
    required this.switchTheme,
    required this.textButtonTheme,
    required this.textFieldTheme,
    this.isAnimating = false,
  });

  factory CarrotThemeData({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Brightness? brightness,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor error = CarrotColors.rose,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotAppBarThemeData? appBarTheme,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotLinkButtonThemeData? linkButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotSwitchThemeData? switchTheme,
    CarrotTextButtonThemeData? textButtonTheme,
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
      error: error,
      gray: gray,
      primary: primary,
      secondary: secondary,
    );

    appBarTheme ??= base.isLight ? CarrotAppBarThemeData.light(base) : CarrotAppBarThemeData.dark(base);
    containedButtonTheme ??= base.isLight ? CarrotContainedButtonThemeData.light(base) : CarrotContainedButtonThemeData.dark(base);
    linkButtonTheme ??= base.isLight ? CarrotLinkButtonThemeData.light(base) : CarrotLinkButtonThemeData.dark(base);
    noticeTheme ??= base.isLight ? CarrotNoticeThemeData.light(base) : CarrotNoticeThemeData.dark(base);
    switchTheme ??= base.isLight ? CarrotSwitchThemeData.light(base) : CarrotSwitchThemeData.dark(base);
    textButtonTheme ??= base.isLight ? CarrotTextButtonThemeData.light(base) : CarrotTextButtonThemeData.dark(base);
    textFieldTheme ??= base.isLight ? CarrotTextFieldThemeData.light(base) : CarrotTextFieldThemeData.dark(base);

    return CarrotThemeData.raw(
      defaults: base.defaults,
      typography: base.typography,
      brightness: base.brightness,
      radius: base.radius,
      accent: base.accent,
      error: base.error,
      gray: base.gray,
      primary: base.primary,
      secondary: base.secondary,
      appBarTheme: appBarTheme,
      containedButtonTheme: containedButtonTheme,
      linkButtonTheme: linkButtonTheme,
      noticeTheme: noticeTheme,
      switchTheme: switchTheme,
      textButtonTheme: textButtonTheme,
      textFieldTheme: textFieldTheme,
    );
  }

  factory CarrotThemeData.dark({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor error = CarrotColors.rose,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotAppBarThemeData? appBarTheme,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotLinkButtonThemeData? linkButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotSwitchThemeData? switchTheme,
    CarrotTextButtonThemeData? textButtonTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) =>
      CarrotThemeData(
        defaults: defaults,
        typography: typography,
        brightness: Brightness.dark,
        radius: radius,
        accent: accent,
        error: error,
        gray: gray,
        primary: primary,
        secondary: secondary,
        appBarTheme: appBarTheme,
        containedButtonTheme: containedButtonTheme,
        linkButtonTheme: linkButtonTheme,
        noticeTheme: noticeTheme,
        switchTheme: switchTheme,
        textButtonTheme: textButtonTheme,
        textFieldTheme: textFieldTheme,
      );

  factory CarrotThemeData.light({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Radius? radius,
    CarrotColor accent = CarrotColors.orange,
    CarrotColor error = CarrotColors.rose,
    CarrotColor gray = CarrotColors.slate,
    CarrotColor primary = CarrotColors.blue,
    CarrotColor secondary = CarrotColors.purple,
    CarrotAppBarThemeData? appBarTheme,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotLinkButtonThemeData? linkButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotSwitchThemeData? switchTheme,
    CarrotTextButtonThemeData? textButtonTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) =>
      CarrotThemeData(
        defaults: defaults,
        typography: typography,
        brightness: Brightness.light,
        radius: radius,
        accent: accent,
        error: error,
        gray: gray,
        primary: primary,
        secondary: secondary,
        appBarTheme: appBarTheme,
        containedButtonTheme: containedButtonTheme,
        linkButtonTheme: linkButtonTheme,
        noticeTheme: noticeTheme,
        switchTheme: switchTheme,
        textButtonTheme: textButtonTheme,
        textFieldTheme: textFieldTheme,
      );

  factory CarrotThemeData.fallback() => CarrotThemeData.light();

  T resolve<T>(T light, T dark) {
    if (isDark) {
      return dark;
    }

    return light;
  }

  CarrotThemeData copyWith({
    CarrotThemeDataDefaults? defaults,
    CarrotTypography? typography,
    Brightness? brightness,
    Radius? radius,
    CarrotColor? accent,
    CarrotColor? error,
    CarrotColor? gray,
    CarrotColor? primary,
    CarrotColor? secondary,
    CarrotAppBarThemeData? appBarTheme,
    CarrotContainedButtonThemeData? containedButtonTheme,
    CarrotLinkButtonThemeData? linkButtonTheme,
    CarrotNoticeThemeData? noticeTheme,
    CarrotSwitchThemeData? switchTheme,
    CarrotTextButtonThemeData? textButtonTheme,
    CarrotTextFieldThemeData? textFieldTheme,
  }) =>
      CarrotThemeData.raw(
        defaults: defaults ?? this.defaults,
        typography: typography ?? this.typography,
        brightness: brightness ?? this.brightness,
        radius: radius ?? this.radius,
        accent: accent ?? this.accent,
        error: error ?? this.error,
        gray: gray ?? this.gray,
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        appBarTheme: appBarTheme ?? this.appBarTheme,
        containedButtonTheme: containedButtonTheme ?? this.containedButtonTheme,
        linkButtonTheme: linkButtonTheme ?? this.linkButtonTheme,
        noticeTheme: noticeTheme ?? this.noticeTheme,
        switchTheme: switchTheme ?? this.switchTheme,
        textButtonTheme: textButtonTheme ?? this.textButtonTheme,
        textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      );

  static CarrotThemeData lerp(CarrotThemeData a, CarrotThemeData b, double t) {
    final base = CarrotThemeDataBase.lerp(a, b, t);

    return CarrotThemeData.raw(
      isAnimating: t > 0 && t < 1,
      defaults: base.defaults,
      typography: base.typography,
      brightness: base.brightness,
      radius: base.radius,
      accent: base.accent,
      error: base.error,
      gray: base.gray,
      primary: base.primary,
      secondary: base.secondary,
      appBarTheme: CarrotAppBarThemeData.lerp(a.appBarTheme, b.appBarTheme, t),
      containedButtonTheme: CarrotContainedButtonThemeData.lerp(a.containedButtonTheme, b.containedButtonTheme, t),
      linkButtonTheme: CarrotLinkButtonThemeData.lerp(a.linkButtonTheme, b.linkButtonTheme, t),
      noticeTheme: CarrotNoticeThemeData.lerp(a.noticeTheme, b.noticeTheme, t),
      switchTheme: CarrotSwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      textButtonTheme: CarrotTextButtonThemeData.lerp(a.textButtonTheme, b.textButtonTheme, t),
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
  final CarrotColor error;
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
    required this.error,
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
      error: CarrotColor.lerp(a.error, b.error, t),
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

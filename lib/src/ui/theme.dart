import 'package:flutter/widgets.dart';

import '../components/theme/text_field_theme.dart';

import 'color.dart';

enum CarrotTypographyType {
  display1,
  display2,
  headline1,
  headline2,
  headline3,
  headline4,
  headline5,
  headline6,
  subtitle1,
  subtitle2,
  body1,
  body2,
}

class CarrotTheme {
  final Color background;
  final BorderRadius borderRadius;
  final bool darkMode;
  final CarrotColor gray;
  final CarrotColor primary;
  final Radius radius;
  final Color scrimColor;

  final CarrotTypography typography;
  final CarrotTextFieldThemeProxy textField;

  CarrotTheme({
    this.darkMode = false,
    this.gray = CarrotColors.slate,
    this.primary = CarrotColors.blue,
    this.radius = const Radius.circular(12),
    Color? background,
    Color? scrimColor,
    CarrotTypography? typography,
    CarrotTextFieldTheme textField = const CarrotTextFieldTheme(),
  })  : background = background ?? gray[0],
        borderRadius = BorderRadius.all(radius),
        scrimColor = (scrimColor ?? gray[darkMode ? 100 : 700]).withOpacity(.75),
        typography = typography ??
            CarrotTypography(
              gray: gray,
              primary: primary,
            ),
        textField = CarrotTextFieldThemeProxy(data: textField);

  static CarrotTheme of(BuildContext context) {
    return CarrotThemeProvider.of(context).theme;
  }

  CarrotTheme copyWith({
    Color? background,
    bool? darkMode,
    CarrotColor? gray,
    CarrotColor? primary,
    Radius? radius,
    Color? scrimColor,
    CarrotTypography? typography,
    CarrotTextFieldTheme? textField,
  }) =>
      CarrotTheme(
        background: background ?? gray?[0] ?? this.background,
        darkMode: darkMode ?? this.darkMode,
        gray: gray ?? this.gray,
        primary: primary ?? this.primary,
        radius: radius ?? this.radius,
        scrimColor: scrimColor ?? this.scrimColor,
        typography: typography ?? this.typography,
        textField: textField ?? this.textField.data,
      );
}

class CarrotThemeProvider extends InheritedWidget {
  final CarrotTheme theme;

  @protected
  const CarrotThemeProvider({
    super.key,
    required super.child,
    required this.theme,
  });

  @override
  bool updateShouldNotify(CarrotThemeProvider oldWidget) {
    return oldWidget.theme != theme;
  }

  static CarrotThemeProvider of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<CarrotThemeProvider>();

    if (widget == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotThemeProvider.of() called with a context that does not contain a CarrotTheme.',
        ),
      ]);
    }

    return widget;
  }
}

class CarrotTypography {
  final TextStyle base;
  final CarrotColor? gray;
  final CarrotColor? primary;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final TextHeightBehavior textHeightBehavior;

  TextStyle get display1 => base.copyWith(
        color: gray?[700],
        fontSize: 48,
        fontWeight: FontWeight.w300,
        height: 1.1,
        overflow: TextOverflow.visible,
      );

  TextStyle get display2 => base.copyWith(
        color: gray?[700],
        fontSize: 36,
        fontWeight: FontWeight.w300,
        height: 1.1,
        overflow: TextOverflow.visible,
      );

  TextStyle get headline1 => base.copyWith(
        color: gray?[700],
        fontSize: 27,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  TextStyle get headline2 => base.copyWith(
        color: gray?[700],
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  TextStyle get headline3 => base.copyWith(
        color: gray?[700],
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.4,
      );

  TextStyle get headline4 => base.copyWith(
        color: gray?[700],
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.4,
      );

  TextStyle get headline5 => base.copyWith(
        color: gray?[700],
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.5,
      );

  TextStyle get headline6 => base.copyWith(
        color: gray?[700],
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.6,
      );

  TextStyle get subtitle1 => base.copyWith(
        color: primary?[500],
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.5,
      );

  TextStyle get subtitle2 => base.copyWith(
        color: primary?[500],
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.6,
      );

  TextStyle get body1 => base.copyWith(
        color: gray?[800],
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.6,
      );

  TextStyle get body2 => base.copyWith(
        color: gray?[800].withOpacity(.65),
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.6,
      );

  TextStyle get button => base.copyWith(
        color: gray?[600],
        height: 1.45,
      );

  CarrotTypography({
    this.gray,
    this.primary,
    this.fontFamily = "helvetica_now",
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w400,
    this.height = 1.6,
    this.textHeightBehavior = const TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: true,
      leadingDistribution: TextLeadingDistribution.even,
    ),
  }) : base = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
          leadingDistribution: textHeightBehavior.leadingDistribution,
        );
}

class CarrotTypographyPanton extends CarrotTypography {
  @override
  TextStyle get display1 => super.display1.copyWith(
        fontWeight: FontWeight.w400,
      );

  @override
  TextStyle get display2 => super.display2.copyWith(
        fontWeight: FontWeight.w400,
      );

  @override
  TextStyle get headline1 => super.headline1.copyWith(
        fontWeight: FontWeight.w800,
      );

  @override
  TextStyle get headline2 => super.headline2.copyWith(
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline3 => super.headline3.copyWith(
        fontWeight: FontWeight.w800,
      );

  @override
  TextStyle get headline4 => super.headline4.copyWith(
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline5 => super.headline5.copyWith(
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline6 => super.headline6.copyWith(
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get subtitle1 => super.subtitle1.copyWith(
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get subtitle2 => super.subtitle2.copyWith(
        fontWeight: FontWeight.w600,
      );

  @override
  TextStyle get body1 => super.body1.copyWith(
        color: gray?[700],
      );

  @override
  TextStyle get body2 => super.body2.copyWith(
        color: gray?[700].withOpacity(.65),
      );

  @override
  TextStyle get button => super.button.copyWith(
        fontWeight: FontWeight.w700,
      );

  CarrotTypographyPanton({
    super.gray,
    super.primary,
    super.fontSize = 16.0,
    super.fontWeight = FontWeight.w600,
    super.height = 1.6,
    super.textHeightBehavior,
  }) : super(fontFamily: "panton");
}

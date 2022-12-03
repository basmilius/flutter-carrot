import 'package:flutter/painting.dart';

import '../ui/ui.dart';

const _kDefaultTextHeightBehavior = TextHeightBehavior(
  applyHeightToFirstAscent: true,
  applyHeightToLastDescent: true,
  leadingDistribution: TextLeadingDistribution.even,
);

class CarrotTypography {
  final TextStyle base;
  final TextStyle display1;
  final TextStyle display2;
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle headline3;
  final TextStyle headline4;
  final TextStyle headline5;
  final TextStyle headline6;
  final TextStyle subtitle1;
  final TextStyle subtitle2;
  final TextStyle body1;
  final TextStyle body2;
  final TextHeightBehavior textHeightBehavior;

  const CarrotTypography.raw({
    required this.base,
    required this.display1,
    required this.display2,
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.headline5,
    required this.headline6,
    required this.subtitle1,
    required this.subtitle2,
    required this.body1,
    required this.body2,
    required this.textHeightBehavior,
  });

  factory CarrotTypography(
    CarrotColor gray,
    CarrotColor primary, {
    String fontFamily = 'system-ui',
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.6,
    TextStyle? display1,
    TextStyle? display2,
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? headline3,
    TextStyle? headline4,
    TextStyle? headline5,
    TextStyle? headline6,
    TextStyle? subtitle1,
    TextStyle? subtitle2,
    TextStyle? body1,
    TextStyle? body2,
    TextHeightBehavior? textHeightBehavior,
  }) {
    textHeightBehavior ??= _kDefaultTextHeightBehavior;
    final base = getBaseTextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );

    display1 ??= base.copyWith(
      color: gray[700],
      fontSize: 48,
      fontWeight: FontWeight.w300,
      height: 1.1,
    );

    display2 ??= base.copyWith(
      color: gray[700],
      fontSize: 36,
      fontWeight: FontWeight.w300,
      height: 1.1,
    );

    headline1 ??= base.copyWith(
      color: gray[700],
      fontSize: 27,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );

    headline2 ??= base.copyWith(
      color: gray[700],
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );

    headline3 ??= base.copyWith(
      color: gray[700],
      fontSize: 21,
      fontWeight: FontWeight.w700,
      height: 1.4,
    );

    headline4 ??= base.copyWith(
      color: gray[700],
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.4,
    );

    headline5 ??= base.copyWith(
      color: gray[700],
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );

    headline6 ??= base.copyWith(
      color: gray[700],
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.6,
    );

    subtitle1 ??= base.copyWith(
      color: primary[500],
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );

    subtitle2 ??= base.copyWith(
      color: primary[500],
      height: 1.6,
    );

    body1 ??= base.copyWith(
      color: gray[800],
      height: 1.6,
    );

    body2 ??= base.copyWith(
      color: gray[800].withOpacity(.65),
      height: 1.6,
    );

    return CarrotTypography.raw(
      base: base,
      display1: display1,
      display2: display2,
      headline1: headline1,
      headline2: headline2,
      headline3: headline3,
      headline4: headline4,
      headline5: headline5,
      headline6: headline6,
      subtitle1: subtitle1,
      subtitle2: subtitle2,
      body1: body1,
      body2: body2,
      textHeightBehavior: textHeightBehavior,
    );
  }

  static TextStyle getBaseTextStyle({
    String fontFamily = 'system-ui',
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.6,
    TextOverflow overflow = TextOverflow.visible,
    TextHeightBehavior textHeightBehavior = _kDefaultTextHeightBehavior,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        leadingDistribution: textHeightBehavior.leadingDistribution,
        overflow: overflow,
      );

  static CarrotTypography lerp(CarrotTypography a, CarrotTypography b, double t) {
    return CarrotTypography.raw(
      base: TextStyle.lerp(a.base, b.base, t)!,
      display1: TextStyle.lerp(a.display1, b.display1, t)!,
      display2: TextStyle.lerp(a.display2, b.display2, t)!,
      headline1: TextStyle.lerp(a.headline1, b.headline1, t)!,
      headline2: TextStyle.lerp(a.headline2, b.headline2, t)!,
      headline3: TextStyle.lerp(a.headline3, b.headline3, t)!,
      headline4: TextStyle.lerp(a.headline4, b.headline4, t)!,
      headline5: TextStyle.lerp(a.headline5, b.headline5, t)!,
      headline6: TextStyle.lerp(a.headline6, b.headline6, t)!,
      subtitle1: TextStyle.lerp(a.subtitle1, b.subtitle1, t)!,
      subtitle2: TextStyle.lerp(a.subtitle2, b.subtitle2, t)!,
      body1: TextStyle.lerp(a.body1, b.body1, t)!,
      body2: TextStyle.lerp(a.body2, b.body2, t)!,
      textHeightBehavior: t < .5 ? a.textHeightBehavior : b.textHeightBehavior,
    );
  }
}

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

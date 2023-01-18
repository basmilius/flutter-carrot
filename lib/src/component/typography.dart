import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/widgets.dart';

import '../extension/extension.dart';
import '../theme/theme.dart';

class CarrotText extends StatelessWidget {
  final String? data;
  final InlineSpan? textSpan;

  final Locale? locale;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final ui.TextHeightBehavior? textHeightBehavior;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final CarrotTypographyType type;

  const CarrotText(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
    this.type = CarrotTypographyType.body1,
  }) : textSpan = null;

  const CarrotText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
    this.type = CarrotTypographyType.body1,
  }) : data = null;

  const CarrotText.display1(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.display1;

  const CarrotText.display2(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.display2;

  const CarrotText.headline1(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline1;

  const CarrotText.headline2(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline2;

  const CarrotText.headline3(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline3;

  const CarrotText.headline4(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline4;

  const CarrotText.headline5(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline5;

  const CarrotText.headline6(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.headline6;

  const CarrotText.subtitle1(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.subtitle1;

  const CarrotText.subtitle2(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.subtitle2;

  const CarrotText.body1(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.body1;

  const CarrotText.body2(
    String this.data, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : textSpan = null,
        type = CarrotTypographyType.body2;

  TextStyle _getTextStyle(BuildContext context) {
    final typography = context.carrotTypography;
    TextStyle base;

    switch (type) {
      case CarrotTypographyType.display1:
        base = typography.display1;
        break;
      case CarrotTypographyType.display2:
        base = typography.display2;
        break;
      case CarrotTypographyType.headline1:
        base = typography.headline1;
        break;
      case CarrotTypographyType.headline2:
        base = typography.headline2;
        break;
      case CarrotTypographyType.headline3:
        base = typography.headline3;
        break;
      case CarrotTypographyType.headline4:
        base = typography.headline4;
        break;
      case CarrotTypographyType.headline5:
        base = typography.headline5;
        break;
      case CarrotTypographyType.headline6:
        base = typography.headline6;
        break;
      case CarrotTypographyType.subtitle1:
        base = typography.subtitle1;
        break;
      case CarrotTypographyType.subtitle2:
        base = typography.subtitle2;
        break;
      case CarrotTypographyType.body1:
        base = typography.body1;
        break;
      case CarrotTypographyType.body2:
        base = typography.body2;
        break;
    }

    return base.merge(style);
  }

  @override
  Widget build(BuildContext context) {
    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
        strutStyle: strutStyle,
        style: _getTextStyle(context),
        textAlign: textAlign,
        textDirection: textDirection,
        textHeightBehavior: textHeightBehavior,
        textScaleFactor: textScaleFactor,
        textWidthBasis: textWidthBasis,
      );
    }

    return Text(
      data!,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      style: _getTextStyle(context),
      textAlign: textAlign,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
    );
  }
}

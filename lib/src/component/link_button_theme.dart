part of 'button.dart';

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
  final Color? background;
  final Color? backgroundActive;
  final Border? border;
  final Border? borderActive;
  final BorderRadius? borderRadius;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? foreground;
  final Color? foregroundActive;
  final EdgeInsets? padding;
  final List<BoxShadow>? shadow;
  final List<BoxShadow>? shadowActive;
  final double tapScale;

  BoxDecoration get decoration => BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        boxShadow: shadow,
        color: background,
      );

  BoxDecoration get decorationActive => BoxDecoration(
        border: borderActive,
        borderRadius: borderRadius,
        boxShadow: shadowActive,
        color: backgroundActive,
      );

  TextStyle get textStyle => TextStyle(
        color: foreground,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.45,
      );

  TextStyle get textStyleActive => TextStyle(
        color: foregroundActive,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.45,
      );

  const CarrotLinkButtonThemeData.raw({
    required this.background,
    required this.backgroundActive,
    required this.border,
    required this.borderActive,
    required this.borderRadius,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.foreground,
    required this.foregroundActive,
    required this.padding,
    required this.shadow,
    required this.shadowActive,
    required this.tapScale,
  });

  factory CarrotLinkButtonThemeData(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    Color? foreground,
    Color? foregroundActive,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) {
    background ??= theme.gray[100].withOpacity(.0);
    backgroundActive ??= theme.gray[100];
    borderRadius ??= theme.borderRadius;
    fontWeight ??= FontWeight.w600;
    foreground ??= theme.gray[700];
    foregroundActive ??= foreground;
    shadow ??= CarrotShadows.none;
    shadowActive ??= CarrotShadows.none;
    tapScale ??= .985;

    return CarrotLinkButtonThemeData.raw(
      background: background,
      backgroundActive: backgroundActive,
      border: border,
      borderActive: borderActive,
      borderRadius: borderRadius,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: foreground,
      foregroundActive: foregroundActive,
      padding: padding,
      shadow: shadow,
      shadowActive: shadowActive,
      tapScale: tapScale,
    );
  }

  factory CarrotLinkButtonThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    Color? foreground,
    Color? foregroundActive,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) =>
      CarrotLinkButtonThemeData(
        theme,
        background: background,
        backgroundActive: backgroundActive,
        border: border,
        borderActive: borderActive,
        borderRadius: borderRadius,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: foreground,
        foregroundActive: foregroundActive,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
        tapScale: tapScale,
      );

  factory CarrotLinkButtonThemeData.light(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    Border? border,
    Border? borderActive,
    BorderRadius? borderRadius,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    Color? foreground,
    Color? foregroundActive,
    EdgeInsets? padding,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowActive,
    double? tapScale,
  }) =>
      CarrotLinkButtonThemeData(
        theme,
        background: background,
        backgroundActive: backgroundActive,
        border: border,
        borderActive: borderActive,
        borderRadius: borderRadius,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: foreground,
        foregroundActive: foregroundActive,
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
        tapScale: tapScale,
      );

  CarrotLinkButtonThemeData copyWith({
    CarrotOptional<Color>? background,
    CarrotOptional<Color>? backgroundActive,
    CarrotOptional<Border>? border,
    CarrotOptional<Border>? borderActive,
    CarrotOptional<BorderRadius>? borderRadius,
    CarrotOptional<String>? fontFamily,
    CarrotOptional<double>? fontSize,
    CarrotOptional<FontWeight>? fontWeight,
    CarrotOptional<Color>? foreground,
    CarrotOptional<Color>? foregroundActive,
    CarrotOptional<EdgeInsets>? padding,
    CarrotOptional<List<BoxShadow>>? shadow,
    CarrotOptional<List<BoxShadow>>? shadowActive,
    CarrotOptional<double>? tapScale,
  }) =>
      CarrotLinkButtonThemeData.raw(
        background: CarrotOptional.valueOr(background, this.background),
        backgroundActive: CarrotOptional.valueOr(backgroundActive, this.backgroundActive),
        border: CarrotOptional.valueOr(border, this.border),
        borderActive: CarrotOptional.valueOr(borderActive, this.borderActive),
        borderRadius: CarrotOptional.valueOr(borderRadius, this.borderRadius),
        fontFamily: CarrotOptional.valueOr(fontFamily, this.fontFamily),
        fontSize: CarrotOptional.valueOr(fontSize, this.fontSize),
        fontWeight: CarrotOptional.valueOr(fontWeight, this.fontWeight),
        foreground: CarrotOptional.valueOr(foreground, this.foreground),
        foregroundActive: CarrotOptional.valueOr(foregroundActive, this.foregroundActive),
        padding: CarrotOptional.valueOr(padding, this.padding),
        shadow: CarrotOptional.valueOr(shadow, this.shadow),
        shadowActive: CarrotOptional.valueOr(shadowActive, this.shadowActive),
        tapScale: CarrotOptional.ensure(tapScale, this.tapScale),
      );

  static CarrotLinkButtonThemeData lerp(CarrotLinkButtonThemeData a, CarrotLinkButtonThemeData b, double t) {
    return CarrotLinkButtonThemeData.raw(
      background: Color.lerp(a.background, b.background, t),
      backgroundActive: Color.lerp(a.backgroundActive, b.backgroundActive, t),
      border: Border.lerp(a.border, b.border, t),
      borderActive: Border.lerp(a.borderActive, b.borderActive, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      fontFamily: t < .5 ? a.fontFamily : b.fontFamily,
      fontSize: lerpDouble(a.fontSize, b.fontSize, t),
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t),
      foreground: Color.lerp(a.foreground, b.foreground, t),
      foregroundActive: Color.lerp(a.foregroundActive, b.foregroundActive, t),
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      shadow: t < .5 ? a.shadow : b.shadow,
      shadowActive: t < .5 ? a.shadowActive : b.shadowActive,
      tapScale: lerpDouble(a.tapScale, b.tapScale, t)!,
    );
  }
}

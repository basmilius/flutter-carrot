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

class CarrotLinkButtonThemeData extends _CarrotButtonThemeData {
  const CarrotLinkButtonThemeData.raw({
    required super.background,
    required super.backgroundActive,
    required super.border,
    required super.borderActive,
    required super.borderRadius,
    required super.fontFamily,
    required super.fontSize,
    required super.fontWeight,
    required super.foreground,
    required super.foregroundActive,
    required super.padding,
    required super.shadow,
    required super.shadowActive,
    required super.tapScale,
  }) : super.raw();

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

  @override
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
    final lerped = _CarrotButtonThemeData.lerp(a, b, t);

    return CarrotLinkButtonThemeData.raw(
      background: lerped.background,
      backgroundActive: lerped.backgroundActive,
      border: lerped.border,
      borderActive: lerped.borderActive,
      borderRadius: lerped.borderRadius,
      fontFamily: lerped.fontFamily,
      fontSize: lerped.fontSize,
      fontWeight: lerped.fontWeight,
      foreground: lerped.foreground,
      foregroundActive: lerped.foregroundActive,
      padding: lerped.padding,
      shadow: lerped.shadow,
      shadowActive: lerped.shadowActive,
      tapScale: lerped.tapScale,
    );
  }
}

part of 'button.dart';

class CarrotContainedButtonTheme extends InheritedTheme {
  final CarrotContainedButtonThemeData data;

  const CarrotContainedButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotContainedButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotContainedButtonTheme(
      data: data,
      child: child,
    );
  }

  static CarrotContainedButtonThemeData of(BuildContext context) {
    final containedButtonTheme = context.dependOnInheritedWidgetOfExactType<CarrotContainedButtonTheme>();

    return containedButtonTheme?.data ?? CarrotTheme.of(context).containedButtonTheme;
  }
}

class CarrotContainedButtonThemeData extends _CarrotButtonThemeData {
  const CarrotContainedButtonThemeData.raw({
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

  factory CarrotContainedButtonThemeData(
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
    background ??= theme.primary[500];
    backgroundActive ??= theme.primary[600];
    border ??= Border.all(
      color: CarrotColors.transparent,
      width: 1.0,
    );
    borderActive ??= border;
    borderRadius ??= theme.borderRadius;
    fontWeight ??= FontWeight.w600;
    foreground ??= theme.primary.text;
    foregroundActive ??= foreground;
    shadow ??= CarrotShadows.small;
    shadowActive ??= shadow;
    tapScale ??= .985;

    return CarrotContainedButtonThemeData.raw(
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

  factory CarrotContainedButtonThemeData.dark(
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
      CarrotContainedButtonThemeData(
        theme,
        background: background ?? theme.primary[400],
        backgroundActive: backgroundActive ?? theme.primary[500],
        border: border,
        borderActive: borderActive ?? border,
        borderRadius: borderRadius,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: foreground ?? theme.primary[900],
        foregroundActive: foregroundActive ?? theme.primary[900],
        padding: padding,
        shadow: shadow,
        shadowActive: shadowActive,
        tapScale: tapScale,
      );

  factory CarrotContainedButtonThemeData.light(
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
      CarrotContainedButtonThemeData(
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

  CarrotContainedButtonThemeData copyWith({
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
      CarrotContainedButtonThemeData.raw(
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

  static CarrotContainedButtonThemeData lerp(CarrotContainedButtonThemeData a, CarrotContainedButtonThemeData b, double t) {
    final lerped = _CarrotButtonThemeData.lerp(a, b, t);

    return CarrotContainedButtonThemeData.raw(
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

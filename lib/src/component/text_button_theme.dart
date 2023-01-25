part of 'button.dart';

class CarrotTextButtonTheme extends InheritedTheme {
  final CarrotTextButtonThemeData data;

  const CarrotTextButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotTextButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotTextButtonTheme(
      data: data,
      child: child,
    );
  }

  static CarrotTextButtonThemeData of(BuildContext context) {
    final textButtonTheme = context.dependOnInheritedWidgetOfExactType<CarrotTextButtonTheme>();

    return textButtonTheme?.data ?? CarrotTheme.of(context).textButtonTheme;
  }
}

class CarrotTextButtonThemeData extends _CarrotButtonThemeData {
  const CarrotTextButtonThemeData.raw({
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

  factory CarrotTextButtonThemeData(
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
    background ??= theme.defaults.content;
    backgroundActive ??= theme.gray[100];
    border ??= Border.all(
      color: theme.gray[300].withOpacity(.35),
      width: 1.0,
    );
    borderActive ??= border;
    borderRadius ??= theme.borderRadius;
    fontWeight ??= FontWeight.w600;
    foreground ??= theme.gray[700];
    foregroundActive ??= foreground;
    shadow ??= CarrotShadows.small;
    shadowActive ??= CarrotShadows.small;
    tapScale ??= .985;

    return CarrotTextButtonThemeData.raw(
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

  factory CarrotTextButtonThemeData.dark(
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
    border ??= Border.all(
      color: theme.gray[200].withOpacity(.35),
      width: 1.0,
    );
    borderActive ??= border;

    return CarrotTextButtonThemeData(
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
  }

  factory CarrotTextButtonThemeData.light(
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
      CarrotTextButtonThemeData(
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
  CarrotTextButtonThemeData copyWith({
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
      CarrotTextButtonThemeData.raw(
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

  static CarrotTextButtonThemeData lerp(CarrotTextButtonThemeData a, CarrotTextButtonThemeData b, double t) {
    final lerped = _CarrotButtonThemeData.lerp(a, b, t);

    return CarrotTextButtonThemeData.raw(
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

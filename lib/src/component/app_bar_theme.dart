part of 'app_bar.dart';

class CarrotAppBarTheme extends InheritedTheme {
  final CarrotAppBarThemeData data;

  const CarrotAppBarTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotAppBarTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotAppBarTheme(
      data: data,
      child: child,
    );
  }

  static CarrotAppBarThemeData of(BuildContext context) {
    final appBarTheme = context.dependOnInheritedWidgetOfExactType<CarrotAppBarTheme>();

    return appBarTheme?.data ?? CarrotTheme.of(context).appBarTheme;
  }
}

class CarrotAppBarThemeData {
  final Color? background;
  final Border? border;
  final Color? foreground;
  final Gradient? gradient;
  final DecorationImage? image;
  final List<BoxShadow>? shadow;

  BoxDecoration get decoration => BoxDecoration(
    border: border,
    boxShadow: shadow,
    color: background,
    gradient: gradient,
    image: image,
  );

  TextStyle get textStyle => TextStyle(
    color: foreground,
  );

  const CarrotAppBarThemeData.raw({
    this.background,
    this.border,
    this.foreground,
    this.gradient,
    this.image,
    this.shadow,
  });

  factory CarrotAppBarThemeData(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? foreground,
    Gradient? gradient,
    DecorationImage? image,
    List<BoxShadow>? shadow,
  }) {
    background ??= theme.primary[700];
    foreground ??= theme.primary[25];
    shadow ??= CarrotShadows.small;

    return CarrotAppBarThemeData.raw(
      background: background,
      border: border,
      foreground: foreground,
      gradient: gradient,
      image: image,
      shadow: shadow,
    );
  }

  factory CarrotAppBarThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? foreground,
    Gradient? gradient,
    DecorationImage? image,
    List<BoxShadow>? shadow,
  }) {
    background ??= theme.primary[900];
    foreground ??= theme.primary[25];

    return CarrotAppBarThemeData(
      theme,
      background: background,
      border: border,
      foreground: foreground,
      gradient: gradient,
      image: image,
      shadow: shadow,
    );
  }

  factory CarrotAppBarThemeData.light(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? foreground,
    Gradient? gradient,
    DecorationImage? image,
    List<BoxShadow>? shadow,
  }) {
    return CarrotAppBarThemeData(
      theme,
      background: background,
      border: border,
      foreground: foreground,
      gradient: gradient,
      image: image,
      shadow: shadow,
    );
  }

  CarrotAppBarThemeData copyWith({
    CarrotOptional<Color>? background,
    CarrotOptional<Border>? border,
    CarrotOptional<Color>? foreground,
    CarrotOptional<Gradient>? gradient,
    CarrotOptional<DecorationImage>? image,
    CarrotOptional<List<BoxShadow>>? shadow,
  }) =>
      CarrotAppBarThemeData.raw(
        background: CarrotOptional.valueOr(background, this.background),
        border: CarrotOptional.valueOr(border, this.border),
        foreground: CarrotOptional.valueOr(foreground, this.foreground),
        gradient: CarrotOptional.valueOr(gradient, this.gradient),
        image: CarrotOptional.valueOr(image, this.image),
        shadow: CarrotOptional.valueOr(shadow, this.shadow),
      );

  static CarrotAppBarThemeData lerp(CarrotAppBarThemeData a, CarrotAppBarThemeData b, double t) {
    return CarrotAppBarThemeData.raw(
      background: Color.lerp(a.background, b.background, t),
      border: Border.lerp(a.border, b.border, t),
      foreground: Color.lerp(a.foreground, b.foreground, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      image: t < .5 ? a.image : b.image,
      shadow: t < .5 ? a.shadow : b.shadow,
    );
  }
}

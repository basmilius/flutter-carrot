part of 'switch.dart';

class CarrotSwitchTheme extends InheritedTheme {
  final CarrotSwitchThemeData data;

  const CarrotSwitchTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotSwitchTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotSwitchTheme(
      data: data,
      child: child,
    );
  }

  static CarrotSwitchThemeData of(BuildContext context) {
    final switchTheme = context.dependOnInheritedWidgetOfExactType<CarrotSwitchTheme>();

    return switchTheme?.data ?? CarrotTheme.of(context).switchTheme;
  }
}

class CarrotSwitchThemeData {
  final Color background;
  final Color backgroundActive;
  final BorderRadius borderRadius;
  final Size size;
  final BorderRadius toggleBorderRadius;
  final Color toggle;
  final Color toggleActive;
  final double toggleMargin;
  final List<BoxShadow> toggleShadow;
  final List<BoxShadow> toggleShadowPressed;

  const CarrotSwitchThemeData.raw({
    required this.background,
    required this.backgroundActive,
    required this.borderRadius,
    required this.size,
    required this.toggleBorderRadius,
    required this.toggle,
    required this.toggleActive,
    required this.toggleMargin,
    required this.toggleShadow,
    required this.toggleShadowPressed,
  });

  factory CarrotSwitchThemeData(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggle,
    Color? toggleActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) {
    background ??= theme.gray[100];
    backgroundActive ??= theme.primary;
    borderRadius ??= BorderRadius.circular(15);
    size ??= const Size(48, 30);
    toggleBorderRadius ??= borderRadius;
    toggle ??= theme.defaults.content;
    toggleActive ??= theme.defaults.content;
    toggleMargin ??= 3.0;
    toggleShadow ??= CarrotShadows.small;
    toggleShadowPressed ??= CarrotShadows.large;

    return CarrotSwitchThemeData.raw(
      background: background,
      backgroundActive: backgroundActive,
      borderRadius: borderRadius,
      size: size,
      toggleBorderRadius: toggleBorderRadius,
      toggle: toggle,
      toggleActive: toggleActive,
      toggleMargin: toggleMargin,
      toggleShadow: toggleShadow,
      toggleShadowPressed: toggleShadowPressed,
    );
  }

  factory CarrotSwitchThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggle,
    Color? toggleActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData(
        theme,
        background: background,
        backgroundActive: backgroundActive,
        borderRadius: borderRadius,
        size: size,
        toggleBorderRadius: toggleBorderRadius,
        toggle: toggle ?? theme.gray[300],
        toggleActive: toggleActive,
        toggleMargin: toggleMargin,
        toggleShadow: toggleShadow,
        toggleShadowPressed: toggleShadowPressed,
      );

  factory CarrotSwitchThemeData.light(
    CarrotThemeDataBase theme, {
    Color? background,
    Color? backgroundActive,
    BorderRadius? borderRadius,
    Size? size,
    BorderRadius? toggleBorderRadius,
    Color? toggle,
    Color? toggleActive,
    double? toggleMargin,
    List<BoxShadow>? toggleShadow,
    List<BoxShadow>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData(
        theme,
        background: background,
        backgroundActive: backgroundActive,
        borderRadius: borderRadius,
        size: size,
        toggleBorderRadius: toggleBorderRadius,
        toggle: toggle,
        toggleActive: toggleActive,
        toggleMargin: toggleMargin,
        toggleShadow: toggleShadow,
        toggleShadowPressed: toggleShadowPressed,
      );

  CarrotSwitchThemeData copyWith({
    CarrotOptional<Color>? background,
    CarrotOptional<Color>? backgroundActive,
    CarrotOptional<BorderRadius>? borderRadius,
    CarrotOptional<Size>? size,
    CarrotOptional<BorderRadius>? toggleBorderRadius,
    CarrotOptional<Color>? toggle,
    CarrotOptional<Color>? toggleActive,
    CarrotOptional<double>? toggleMargin,
    CarrotOptional<List<BoxShadow>>? toggleShadow,
    CarrotOptional<List<BoxShadow>>? toggleShadowPressed,
  }) =>
      CarrotSwitchThemeData.raw(
        background: CarrotOptional.ensure(background, this.background),
        backgroundActive: CarrotOptional.ensure(backgroundActive, this.backgroundActive),
        borderRadius: CarrotOptional.ensure(borderRadius, this.borderRadius),
        size: CarrotOptional.ensure(size, this.size),
        toggleBorderRadius: CarrotOptional.ensure(toggleBorderRadius, this.toggleBorderRadius),
        toggle: CarrotOptional.ensure(toggle, this.toggle),
        toggleActive: CarrotOptional.ensure(toggleActive, this.toggleActive),
        toggleMargin: CarrotOptional.ensure(toggleMargin, this.toggleMargin),
        toggleShadow: CarrotOptional.ensure(toggleShadow, this.toggleShadow),
        toggleShadowPressed: CarrotOptional.ensure(toggleShadowPressed, this.toggleShadowPressed),
      );

  static CarrotSwitchThemeData lerp(CarrotSwitchThemeData a, CarrotSwitchThemeData b, double t) {
    return CarrotSwitchThemeData.raw(
      background: Color.lerp(a.background, b.background, t)!,
      backgroundActive: Color.lerp(a.backgroundActive, b.backgroundActive, t)!,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
      size: Size.lerp(a.size, b.size, t)!,
      toggleBorderRadius: BorderRadius.lerp(a.toggleBorderRadius, b.toggleBorderRadius, t)!,
      toggle: Color.lerp(a.toggle, b.toggle, t)!,
      toggleActive: Color.lerp(a.toggleActive, b.toggleActive, t)!,
      toggleMargin: lerpDouble(a.toggleMargin, b.toggleMargin, t)!,
      toggleShadow: t < .5 ? a.toggleShadow : b.toggleShadow,
      toggleShadowPressed: t < .5 ? a.toggleShadowPressed : b.toggleShadowPressed,
    );
  }
}

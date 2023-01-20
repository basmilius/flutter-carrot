part of 'increment_stepper.dart';

class CarrotIncrementStepperTheme extends InheritedTheme {
  final CarrotIncrementStepperThemeData data;

  const CarrotIncrementStepperTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotIncrementStepperTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotIncrementStepperTheme(
      data: data,
      child: child,
    );
  }

  static CarrotIncrementStepperThemeData of(BuildContext context) {
    final incrementStepperTheme = context.dependOnInheritedWidgetOfExactType<CarrotIncrementStepperTheme>();

    return incrementStepperTheme?.data ?? CarrotTheme.of(context).incrementStepperTheme;
  }
}

class CarrotIncrementStepperThemeData {
  final Color background;
  final Border? border;
  final BorderRadius? borderRadius;
  final Color foreground;
  final double gap;
  final double iconSize;
  final EdgeInsets padding;
  final Color valueForegroundAttached;
  final Color valueForegroundDetached;

  const CarrotIncrementStepperThemeData.raw({
    required this.background,
    required this.border,
    required this.borderRadius,
    required this.foreground,
    required this.gap,
    required this.iconSize,
    required this.padding,
    required this.valueForegroundAttached,
    required this.valueForegroundDetached,
  });

  factory CarrotIncrementStepperThemeData(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    BorderRadius? borderRadius,
    Color? foreground,
    double? gap,
    double? iconSize,
    EdgeInsets? padding,
    Color? valueForegroundAttached,
    Color? valueForegroundDetached,
  }) {
    background ??= theme.gray[100];
    borderRadius ??= theme.borderRadius / 2;
    foreground ??= theme.gray;
    gap ??= 9;
    iconSize ??= 16;
    padding ??= const EdgeInsets.all(9);
    valueForegroundAttached ??= theme.gray[700];
    valueForegroundDetached ??= theme.gray[700];

    return CarrotIncrementStepperThemeData.raw(
      background: background,
      border: border,
      borderRadius: borderRadius,
      foreground: foreground,
      gap: gap,
      iconSize: iconSize,
      padding: padding,
      valueForegroundAttached: valueForegroundAttached,
      valueForegroundDetached: valueForegroundDetached,
    );
  }

  factory CarrotIncrementStepperThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    BorderRadius? borderRadius,
    Color? foreground,
    double? gap,
    double? iconSize,
    EdgeInsets? padding,
    Color? valueForegroundAttached,
    Color? valueForegroundDetached,
  }) =>
      CarrotIncrementStepperThemeData(
        theme,
        background: background,
        border: border,
        borderRadius: borderRadius,
        foreground: foreground,
        gap: gap,
        iconSize: iconSize,
        padding: padding,
        valueForegroundAttached: valueForegroundAttached,
        valueForegroundDetached: valueForegroundDetached,
      );

  factory CarrotIncrementStepperThemeData.light(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    BorderRadius? borderRadius,
    Color? foreground,
    double? gap,
    double? iconSize,
    EdgeInsets? padding,
    Color? valueForegroundAttached,
    Color? valueForegroundDetached,
  }) =>
      CarrotIncrementStepperThemeData(
        theme,
        background: background,
        border: border,
        borderRadius: borderRadius,
        foreground: foreground,
        gap: gap,
        iconSize: iconSize,
        padding: padding,
        valueForegroundAttached: valueForegroundAttached,
        valueForegroundDetached: valueForegroundDetached,
      );

  CarrotIncrementStepperThemeData copyWith({
    CarrotOptional<Color>? background,
    CarrotOptional<Border>? border,
    CarrotOptional<BorderRadius>? borderRadius,
    CarrotOptional<Color>? foreground,
    CarrotOptional<double>? gap,
    CarrotOptional<double>? iconSize,
    CarrotOptional<EdgeInsets>? padding,
    CarrotOptional<Color>? valueForegroundAttached,
    CarrotOptional<Color>? valueForegroundDetached,
  }) =>
      CarrotIncrementStepperThemeData.raw(
        background: CarrotOptional.ensure(background, this.background),
        border: CarrotOptional.valueOr(border, this.border),
        borderRadius: CarrotOptional.valueOr(borderRadius, this.borderRadius),
        foreground: CarrotOptional.ensure(foreground, this.foreground),
        gap: CarrotOptional.ensure(gap, this.gap),
        iconSize: CarrotOptional.ensure(iconSize, this.iconSize),
        padding: CarrotOptional.ensure(padding, this.padding),
        valueForegroundAttached: CarrotOptional.ensure(valueForegroundAttached, this.valueForegroundAttached),
        valueForegroundDetached: CarrotOptional.ensure(valueForegroundDetached, this.valueForegroundDetached),
      );

  static CarrotIncrementStepperThemeData lerp(CarrotIncrementStepperThemeData a, CarrotIncrementStepperThemeData b, double t) {
    return CarrotIncrementStepperThemeData.raw(
      background: Color.lerp(a.background, b.background, t)!,
      border: Border.lerp(a.border, b.border, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      gap: lerpDouble(a.gap, b.gap, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      valueForegroundAttached: Color.lerp(a.valueForegroundAttached, b.valueForegroundAttached, t)!,
      valueForegroundDetached: Color.lerp(a.valueForegroundDetached, b.valueForegroundDetached, t)!,
    );
  }
}

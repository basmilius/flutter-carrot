part of 'container.dart';

class CarrotContainerTheme extends InheritedTheme {
  final CarrotContainerThemeData data;

  const CarrotContainerTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotContainerTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotContainerTheme(
      data: data,
      child: child,
    );
  }

  static CarrotContainerThemeData of(BuildContext context) {
    final containerTheme = context.dependOnInheritedWidgetOfExactType<CarrotContainerTheme>();

    return containerTheme?.data ?? CarrotTheme.of(context).containerTheme;
  }
}

class CarrotContainerThemeData {
  final AlignmentGeometry alignment;
  final double width;

  const CarrotContainerThemeData.raw({
    required this.alignment,
    required this.width,
  });

  factory CarrotContainerThemeData(
    CarrotThemeDataBase theme, {
    AlignmentGeometry? alignment,
    double? width,
  }) {
    alignment ??= AlignmentDirectional.topCenter;
    width ??= 810;

    return CarrotContainerThemeData.raw(
      alignment: alignment,
      width: width,
    );
  }

  factory CarrotContainerThemeData.dark(
    CarrotThemeDataBase theme, {
    AlignmentGeometry? alignment,
    double? width,
  }) {
    return CarrotContainerThemeData(
      theme,
      alignment: alignment,
      width: width,
    );
  }

  factory CarrotContainerThemeData.light(
    CarrotThemeDataBase theme, {
    AlignmentGeometry? alignment,
    double? width,
  }) {
    return CarrotContainerThemeData(
      theme,
      alignment: alignment,
      width: width,
    );
  }

  CarrotContainerThemeData copyWith({
    CarrotOptional<AlignmentGeometry>? alignment,
    CarrotOptional<double>? width,
  }) =>
      CarrotContainerThemeData.raw(
        alignment: CarrotOptional.ensure(alignment, this.alignment),
        width: CarrotOptional.ensure(width, this.width),
      );

  static CarrotContainerThemeData lerp(CarrotContainerThemeData a, CarrotContainerThemeData b, double t) {
    return CarrotContainerThemeData.raw(
      alignment: AlignmentGeometry.lerp(a.alignment, b.alignment, t)!,
      width: lerpDouble(a.width, b.width, t)!,
    );
  }
}

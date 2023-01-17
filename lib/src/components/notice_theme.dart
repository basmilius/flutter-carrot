part of 'notice.dart';

class CarrotNoticeTheme extends InheritedTheme {
  final CarrotNoticeThemeData data;

  const CarrotNoticeTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotNoticeTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotNoticeTheme(
      data: data,
      child: child,
    );
  }

  static CarrotNoticeThemeData of(BuildContext context) {
    final noticeTheme = context.dependOnInheritedWidgetOfExactType<CarrotNoticeTheme>();

    return noticeTheme?.data ?? CarrotTheme.of(context).noticeTheme;
  }
}

class CarrotNoticeThemeData {
  final int backgroundShade;
  final int foregroundShade;
  final int iconShade;
  final int titleShade;

  const CarrotNoticeThemeData.raw({
    required this.backgroundShade,
    required this.foregroundShade,
    required this.iconShade,
    required this.titleShade,
  });

  factory CarrotNoticeThemeData(
    CarrotThemeDataBase theme, {
    int? backgroundShade,
    int? foregroundShade,
    int? iconShade,
    int? titleShade,
  }) {
    backgroundShade ??= 100;
    foregroundShade ??= 700;
    iconShade ??= 500;
    titleShade ??= 500;

    return CarrotNoticeThemeData.raw(
      backgroundShade: backgroundShade,
      foregroundShade: foregroundShade,
      iconShade: iconShade,
      titleShade: titleShade,
    );
  }

  factory CarrotNoticeThemeData.dark(
    CarrotThemeDataBase theme, {
    int? backgroundShade,
    int? foregroundShade,
    int? iconShade,
    int? titleShade,
  }) {
    backgroundShade ??= 900;
    foregroundShade ??= 200;
    iconShade ??= 0;
    titleShade ??= 0;

    return CarrotNoticeThemeData(
      theme,
      backgroundShade: backgroundShade,
      foregroundShade: foregroundShade,
      iconShade: iconShade,
      titleShade: titleShade,
    );
  }

  factory CarrotNoticeThemeData.light(
    CarrotThemeDataBase theme, {
    int? backgroundShade,
    int? foregroundShade,
    int? iconShade,
    int? titleShade,
  }) {
    return CarrotNoticeThemeData(
      theme,
      backgroundShade: backgroundShade,
      foregroundShade: foregroundShade,
      iconShade: iconShade,
      titleShade: titleShade,
    );
  }

  CarrotNoticeThemeData copyWith({
    CarrotOptional<int>? backgroundShade,
    CarrotOptional<int>? foregroundShade,
    CarrotOptional<int>? iconShade,
    CarrotOptional<int>? titleShade,
  }) =>
      CarrotNoticeThemeData.raw(
        backgroundShade: CarrotOptional.ensure(backgroundShade, this.backgroundShade),
        foregroundShade: CarrotOptional.ensure(foregroundShade, this.foregroundShade),
        iconShade: CarrotOptional.ensure(iconShade, this.iconShade),
        titleShade: CarrotOptional.ensure(titleShade, this.titleShade),
      );

  static CarrotNoticeThemeData lerp(CarrotNoticeThemeData a, CarrotNoticeThemeData b, double t) {
    return CarrotNoticeThemeData.raw(
      backgroundShade: lerpDouble(a.backgroundShade, b.backgroundShade, t)!.toInt(),
      foregroundShade: lerpDouble(a.foregroundShade, b.foregroundShade, t)!.toInt(),
      iconShade: lerpDouble(a.iconShade, b.iconShade, t)!.toInt(),
      titleShade: lerpDouble(a.titleShade, b.titleShade, t)!.toInt(),
    );
  }
}

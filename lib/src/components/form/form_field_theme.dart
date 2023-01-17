part of 'form_field.dart';

class CarrotFormFieldTheme extends InheritedTheme {
  final CarrotFormFieldThemeData data;

  const CarrotFormFieldTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(CarrotFormFieldTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CarrotFormFieldTheme(
      data: data,
      child: child,
    );
  }

  static CarrotFormFieldThemeData of(BuildContext context) {
    final formFieldTheme = context.dependOnInheritedWidgetOfExactType<CarrotFormFieldTheme>();

    return formFieldTheme?.data ?? CarrotTheme.of(context).formFieldTheme;
  }
}

class CarrotFormFieldThemeData {
  final Color? background;
  final Border? border;
  final Color cursor;
  final String obscuringCharacter;
  final EdgeInsets padding;
  final Color? selection;
  final StrutStyle strutStyle;
  final TextStyle textPlaceholderStyle;
  final TextStyle textStyle;

  const CarrotFormFieldThemeData.raw({
    required this.background,
    required this.border,
    required this.cursor,
    required this.obscuringCharacter,
    required this.padding,
    required this.selection,
    required this.strutStyle,
    required this.textPlaceholderStyle,
    required this.textStyle,
  });

  factory CarrotFormFieldThemeData(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? cursor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selection,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) {
    background ??= theme.gray[100];
    cursor ??= theme.primary[500];
    obscuringCharacter ??= '•';
    padding ??= const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 11,
    );
    selection ??= theme.primary[500].withOpacity(.35);
    strutStyle = const StrutStyle(
      height: 1.0,
    );
    textStyle ??= theme.typography.body1;
    textPlaceholderStyle ??= textStyle.copyWith(
      color: theme.gray[600].withOpacity(.5),
    );

    return CarrotFormFieldThemeData.raw(
      background: background,
      border: border,
      cursor: cursor,
      obscuringCharacter: obscuringCharacter,
      padding: padding,
      selection: selection,
      strutStyle: strutStyle,
      textPlaceholderStyle: textPlaceholderStyle,
      textStyle: textStyle,
    );
  }

  factory CarrotFormFieldThemeData.dark(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? cursor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selection,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) =>
      CarrotFormFieldThemeData(
        theme,
        background: background,
        border: border,
        cursor: cursor,
        obscuringCharacter: obscuringCharacter,
        padding: padding,
        selection: selection,
        strutStyle: strutStyle,
        textPlaceholderStyle: textPlaceholderStyle,
        textStyle: textStyle,
      );

  factory CarrotFormFieldThemeData.light(
    CarrotThemeDataBase theme, {
    Color? background,
    Border? border,
    Color? cursor,
    String? obscuringCharacter,
    EdgeInsets? padding,
    Color? selection,
    StrutStyle? strutStyle,
    TextStyle? textPlaceholderStyle,
    TextStyle? textStyle,
  }) =>
      CarrotFormFieldThemeData(
        theme,
        background: background,
        border: border,
        cursor: cursor,
        obscuringCharacter: obscuringCharacter,
        padding: padding,
        selection: selection,
        strutStyle: strutStyle,
        textPlaceholderStyle: textPlaceholderStyle,
        textStyle: textStyle,
      );

  CarrotFormFieldThemeData copyWith({
    CarrotOptional<Color>? background,
    CarrotOptional<Border>? border,
    CarrotOptional<Color>? cursor,
    CarrotOptional<String>? obscuringCharacter,
    CarrotOptional<EdgeInsets>? padding,
    CarrotOptional<Color>? selection,
    CarrotOptional<StrutStyle>? strutStyle,
    CarrotOptional<TextStyle>? textPlaceholderStyle,
    CarrotOptional<TextStyle>? textStyle,
  }) =>
      CarrotFormFieldThemeData.raw(
        background: CarrotOptional.valueOr(background, this.background),
        border: CarrotOptional.valueOr(border, this.border),
        cursor: CarrotOptional.ensure(cursor, this.cursor),
        obscuringCharacter: CarrotOptional.ensure(obscuringCharacter, this.obscuringCharacter),
        padding: CarrotOptional.ensure(padding, this.padding),
        selection: CarrotOptional.valueOr(selection, this.selection),
        strutStyle: CarrotOptional.ensure(strutStyle, this.strutStyle),
        textPlaceholderStyle: CarrotOptional.ensure(textPlaceholderStyle, this.textPlaceholderStyle),
        textStyle: CarrotOptional.ensure(textStyle, this.textStyle),
      );

  static CarrotFormFieldThemeData lerp(CarrotFormFieldThemeData a, CarrotFormFieldThemeData b, double t) {
    return CarrotFormFieldThemeData.raw(
      background: Color.lerp(a.background, b.background, t)!,
      border: Border.lerp(a.border, b.border, t)!,
      cursor: Color.lerp(a.cursor, b.cursor, t)!,
      obscuringCharacter: t < .5 ? a.obscuringCharacter : b.obscuringCharacter,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      selection: Color.lerp(a.selection, b.selection, t)!,
      strutStyle: t < .5 ? a.strutStyle : b.strutStyle,
      textPlaceholderStyle: TextStyle.lerp(a.textPlaceholderStyle, b.textPlaceholderStyle, t)!,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
    );
  }
}

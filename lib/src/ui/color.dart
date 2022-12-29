import 'dart:math';
import 'dart:ui';

final _randomizer = Random(13031996);

const _knownSwatches = [
  25,
  50,
  100,
  200,
  300,
  400,
  500,
  600,
  700,
  800,
  900,
];

const _grayBlue = Color(0xff4e5ba6);
const _grayCool = Color(0xff5d6b98);
const _grayModern = Color(0xff697586);
const _gray = Color(0xff667085);
const _grayNeutral = Color(0xff6c737f);
const _grayIron = Color(0xff70707b);
const _grayTrue = Color(0xff737373);
const _grayWarm = Color(0xff79716b);
const _moss = Color(0xff669f2a);
const _greenLight = Color(0xff66c61c);
const _green = Color(0xff16b364);
const _emerald = Color(0xff12b76a);
const _teal = Color(0xff15b79e);
const _cyan = Color(0xff06aed4);
const _blueLight = Color(0xff0ba5ec);
const _blue = Color(0xff2e90fa);
const _blueDark = Color(0xff2970ff);
const _indigo = Color(0xff6172f3);
const _purple = Color(0xff7a5af8);
const _violet = Color(0xff875bf7);
const _portage = Color(0xff9e77ed);
const _fuchsia = Color(0xffd444f1);
const _pink = Color(0xffee46bc);
const _rose = Color(0xfff63d68);
const _red = Color(0xfff04438);
const _orangeDark = Color(0xffff4405);
const _orange = Color(0xffef6820);
const _amber = Color(0xfff79009);
const _yellow = Color(0xffeaaa08);

class CarrotColor extends Color {
  final Map<int, CarrotSwatch> _swatches;

  CarrotColor get reversed => CarrotColor(value, {
        25: this[900],
        50: this[890],
        100: this[860],
        200: this[800],
        300: this[700],
        400: this[600],
        500: this[500],
        600: this[400],
        700: this[300],
        800: this[200],
        900: this[100],
      });

  Color get text => _swatches[500]!.text;

  const CarrotColor(
    super.value,
    this._swatches,
  );

  CarrotSwatch operator [](int index) {
    assert(index >= 0 && index <= 900, 'CarrotColor only has shades between 0 and 900.');

    if (_knownSwatches.contains(index)) {
      return _swatches[index]!;
    }

    if (index < 25) {
      return _swatches[25]!;
    }

    if (index < 50) {
      return CarrotSwatch.lerp(_swatches[25]!, _swatches[50]!, (index - 25) / 25);
    }

    if (index < 100) {
      return CarrotSwatch.lerp(_swatches[50]!, _swatches[100]!, (index - 50) / 50);
    }

    int lowerIndex = (index / 100).floor() * 100;
    int upperIndex = (index / 100).ceil() * 100;

    final a = _swatches[lowerIndex]!;
    final b = _swatches[upperIndex]!;

    return CarrotSwatch.lerp(a, b, (index - lowerIndex) / 100);
  }

  static CarrotColor lerp(CarrotColor a, CarrotColor b, double t) {
    return CarrotColor(lerpDouble(a.value, b.value, t)!.toInt(), {
      25: CarrotSwatch.lerp(a[25], b[25], t),
      50: CarrotSwatch.lerp(a[50], b[50], t),
      100: CarrotSwatch.lerp(a[100], b[100], t),
      200: CarrotSwatch.lerp(a[200], b[200], t),
      300: CarrotSwatch.lerp(a[300], b[300], t),
      400: CarrotSwatch.lerp(a[400], b[400], t),
      500: CarrotSwatch.lerp(a[500], b[500], t),
      600: CarrotSwatch.lerp(a[600], b[600], t),
      700: CarrotSwatch.lerp(a[700], b[700], t),
      800: CarrotSwatch.lerp(a[800], b[800], t),
      900: CarrotSwatch.lerp(a[900], b[900], t),
    });
  }
}

class CarrotSwatch extends Color {
  final Color text;

  Color get color => Color(value);

  @override
  int get hashCode => Object.hash(runtimeType, value, text.value);

  const CarrotSwatch(
    super.value,
    this.text,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return super == other && other is CarrotSwatch;
  }

  static CarrotSwatch lerp(CarrotSwatch a, CarrotSwatch b, double t) => CarrotSwatch(
        Color.lerp(a, b, t)!.value,
        Color.lerp(a.text, b.text, t)!,
      );
}

class CarrotColors {
  final List<CarrotColor> _colors;

  CarrotColors._(this._colors) {
    _colors.shuffle(_randomizer);
  }

  CarrotColor operator [](int index) => _colors[index % _colors.length];

  static final all = CarrotColors._([
    grayBlue,
    grayCool,
    grayModern,
    gray,
    grayNeutral,
    grayIron,
    grayTrue,
    grayWarm,
    moss,
    greenLight,
    green,
    emerald,
    teal,
    cyan,
    blueLight,
    blue,
    blueDark,
    indigo,
    purple,
    violet,
    portage,
    fuchsia,
    pink,
    rose,
    red,
    orangeDark,
    orange,
    amber,
    yellow,
  ]);

  static final colorful = CarrotColors._([
    moss,
    greenLight,
    green,
    emerald,
    teal,
    cyan,
    blueLight,
    blue,
    blueDark,
    indigo,
    purple,
    violet,
    portage,
    fuchsia,
    pink,
    rose,
    red,
    orangeDark,
    orange,
    amber,
    yellow,
  ]);

  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);

  static const CarrotColor grayBlue = CarrotColor(0xff4e5ba6, {
    25: CarrotSwatch(0xfffcfcfd, _grayBlue),
    50: CarrotSwatch(0xfff8f9fc, _grayBlue),
    100: CarrotSwatch(0xffeaecf5, _grayBlue),
    200: CarrotSwatch(0xffd5d9eb, _grayBlue),
    300: CarrotSwatch(0xffb3b8db, white),
    400: CarrotSwatch(0xff717bbc, white),
    500: CarrotSwatch(0xff4e5ba6, white),
    600: CarrotSwatch(0xff3e4784, white),
    700: CarrotSwatch(0xff363f72, white),
    800: CarrotSwatch(0xff293056, white),
    900: CarrotSwatch(0xff101323, white),
  });

  static const CarrotColor grayCool = CarrotColor(0xff5d6b98, {
    25: CarrotSwatch(0xfffcfcfd, _grayCool),
    50: CarrotSwatch(0xfff9f9fb, _grayCool),
    100: CarrotSwatch(0xffeff1f5, _grayCool),
    200: CarrotSwatch(0xffdcdfea, _grayCool),
    300: CarrotSwatch(0xffb9c0d4, white),
    400: CarrotSwatch(0xff7d89b0, white),
    500: CarrotSwatch(0xff5d6b98, white),
    600: CarrotSwatch(0xff4a5578, white),
    700: CarrotSwatch(0xff404968, white),
    800: CarrotSwatch(0xff30374f, white),
    900: CarrotSwatch(0xff111322, white),
  });

  static const CarrotColor grayModern = CarrotColor(0xff697586, {
    25: CarrotSwatch(0xfffcfcfd, _grayModern),
    50: CarrotSwatch(0xfff8fafc, _grayModern),
    100: CarrotSwatch(0xffeef2f6, _grayModern),
    200: CarrotSwatch(0xffe3e8ef, _grayModern),
    300: CarrotSwatch(0xffcdd5df, white),
    400: CarrotSwatch(0xff9aa4b2, white),
    500: CarrotSwatch(0xff697586, white),
    600: CarrotSwatch(0xff4b5565, white),
    700: CarrotSwatch(0xff364152, white),
    800: CarrotSwatch(0xff202939, white),
    900: CarrotSwatch(0xff121926, white),
  });

  static const CarrotColor gray = CarrotColor(0xff667085, {
    25: CarrotSwatch(0xfffcfcfd, _gray),
    50: CarrotSwatch(0xfff9fafb, _gray),
    100: CarrotSwatch(0xfff2f4f7, _gray),
    200: CarrotSwatch(0xffeaecf0, _gray),
    300: CarrotSwatch(0xffd0d5dd, white),
    400: CarrotSwatch(0xff98a2b3, white),
    500: CarrotSwatch(0xff667085, white),
    600: CarrotSwatch(0xff475467, white),
    700: CarrotSwatch(0xff344054, white),
    800: CarrotSwatch(0xff1d2939, white),
    900: CarrotSwatch(0xff101828, white),
  });

  static const CarrotColor grayNeutral = CarrotColor(0xff6c737f, {
    25: CarrotSwatch(0xfffcfcfd, _grayNeutral),
    50: CarrotSwatch(0xfff9fafb, _grayNeutral),
    100: CarrotSwatch(0xfff3f4f6, _grayNeutral),
    200: CarrotSwatch(0xffe5e7eb, _grayNeutral),
    300: CarrotSwatch(0xffd2d6db, white),
    400: CarrotSwatch(0xff9da4ae, white),
    500: CarrotSwatch(0xff6c737f, white),
    600: CarrotSwatch(0xff4d5761, white),
    700: CarrotSwatch(0xff384250, white),
    800: CarrotSwatch(0xff1f2a37, white),
    900: CarrotSwatch(0xff111927, white),
  });

  static const CarrotColor grayIron = CarrotColor(0xff70707b, {
    25: CarrotSwatch(0xfffcfcfc, _grayIron),
    50: CarrotSwatch(0xfffafafa, _grayIron),
    100: CarrotSwatch(0xfff4f4f5, _grayIron),
    200: CarrotSwatch(0xffe4e4e7, _grayIron),
    300: CarrotSwatch(0xffd1d1d6, white),
    400: CarrotSwatch(0xffa0a0ab, white),
    500: CarrotSwatch(0xff70707b, white),
    600: CarrotSwatch(0xff51525c, white),
    700: CarrotSwatch(0xff3f3f46, white),
    800: CarrotSwatch(0xff26272b, white),
    900: CarrotSwatch(0xff18181b, white),
  });

  static const CarrotColor grayTrue = CarrotColor(0xff737373, {
    25: CarrotSwatch(0xfffcfcfc, _grayTrue),
    50: CarrotSwatch(0xfffafafa, _grayTrue),
    100: CarrotSwatch(0xfff5f5f5, _grayTrue),
    200: CarrotSwatch(0xffe5e5e5, _grayTrue),
    300: CarrotSwatch(0xffd6d6d6, white),
    400: CarrotSwatch(0xffa3a3a3, white),
    500: CarrotSwatch(0xff737373, white),
    600: CarrotSwatch(0xff525252, white),
    700: CarrotSwatch(0xff424242, white),
    800: CarrotSwatch(0xff292929, white),
    900: CarrotSwatch(0xff141414, white),
  });

  static const CarrotColor grayWarm = CarrotColor(0xff79716b, {
    25: CarrotSwatch(0xfffdfdfc, _grayWarm),
    50: CarrotSwatch(0xfffafaf9, _grayWarm),
    100: CarrotSwatch(0xfff5f5f4, _grayWarm),
    200: CarrotSwatch(0xffe7e5e4, _grayWarm),
    300: CarrotSwatch(0xffd7d3d0, white),
    400: CarrotSwatch(0xffa9a29d, white),
    500: CarrotSwatch(0xff79716b, white),
    600: CarrotSwatch(0xff57534e, white),
    700: CarrotSwatch(0xff44403c, white),
    800: CarrotSwatch(0xff292524, white),
    900: CarrotSwatch(0xff1c1917, white),
  });

  static const CarrotColor moss = CarrotColor(0xff669f2a, {
    25: CarrotSwatch(0xfffafdf7, _moss),
    50: CarrotSwatch(0xfff5fbee, _moss),
    100: CarrotSwatch(0xffe6f4d7, _moss),
    200: CarrotSwatch(0xffceeab0, _moss),
    300: CarrotSwatch(0xffacdc79, white),
    400: CarrotSwatch(0xff86cb3c, white),
    500: CarrotSwatch(0xff669f2a, white),
    600: CarrotSwatch(0xff4f7a21, white),
    700: CarrotSwatch(0xff3f621a, white),
    800: CarrotSwatch(0xff335015, white),
    900: CarrotSwatch(0xff2b4212, white),
  });

  static const CarrotColor greenLight = CarrotColor(0xff66c61c, {
    25: CarrotSwatch(0xfffafef5, _greenLight),
    50: CarrotSwatch(0xfff3fee7, _greenLight),
    100: CarrotSwatch(0xffe4fbcc, _greenLight),
    200: CarrotSwatch(0xffd0f8ab, _greenLight),
    300: CarrotSwatch(0xffa6ef67, white),
    400: CarrotSwatch(0xff85e13a, white),
    500: CarrotSwatch(0xff66c61c, white),
    600: CarrotSwatch(0xff4ca30d, white),
    700: CarrotSwatch(0xff3b7c0f, white),
    800: CarrotSwatch(0xff326212, white),
    900: CarrotSwatch(0xff2b5314, white),
  });

  static const CarrotColor green = CarrotColor(0xff16b364, {
    25: CarrotSwatch(0xfff6fef9, _green),
    50: CarrotSwatch(0xffedfcf2, _green),
    100: CarrotSwatch(0xffd3f8df, _green),
    200: CarrotSwatch(0xffaaf0c4, _green),
    300: CarrotSwatch(0xff73e2a3, white),
    400: CarrotSwatch(0xff3ccb7f, white),
    500: CarrotSwatch(0xff16b364, white),
    600: CarrotSwatch(0xff099250, white),
    700: CarrotSwatch(0xff087443, white),
    800: CarrotSwatch(0xff095c37, white),
    900: CarrotSwatch(0xff084c2e, white),
  });

  static const CarrotColor emerald = CarrotColor(0xff12b76a, {
    25: CarrotSwatch(0xfff6fef9, _emerald),
    50: CarrotSwatch(0xffecfdf3, _emerald),
    100: CarrotSwatch(0xffd1fadf, _emerald),
    200: CarrotSwatch(0xffa6f4c5, _emerald),
    300: CarrotSwatch(0xff6ce9a6, white),
    400: CarrotSwatch(0xff32d583, white),
    500: CarrotSwatch(0xff12b76a, white),
    600: CarrotSwatch(0xff039855, white),
    700: CarrotSwatch(0xff027a48, white),
    800: CarrotSwatch(0xff05603a, white),
    900: CarrotSwatch(0xff054f31, white),
  });

  static const CarrotColor teal = CarrotColor(0xff15b79e, {
    25: CarrotSwatch(0xfff6fefc, _teal),
    50: CarrotSwatch(0xfff0fdf9, _teal),
    100: CarrotSwatch(0xffccfbef, _teal),
    200: CarrotSwatch(0xff99f6e0, _teal),
    300: CarrotSwatch(0xff5fe9d0, white),
    400: CarrotSwatch(0xff2ed3b7, white),
    500: CarrotSwatch(0xff15b79e, white),
    600: CarrotSwatch(0xff0e9384, white),
    700: CarrotSwatch(0xff107569, white),
    800: CarrotSwatch(0xff125d56, white),
    900: CarrotSwatch(0xff134e48, white),
  });

  static const CarrotColor cyan = CarrotColor(0xff06aed4, {
    25: CarrotSwatch(0xfff5feff, _cyan),
    50: CarrotSwatch(0xffecfdff, _cyan),
    100: CarrotSwatch(0xffcff9fe, _cyan),
    200: CarrotSwatch(0xffa5f0fc, _cyan),
    300: CarrotSwatch(0xff67e3f9, white),
    400: CarrotSwatch(0xff22ccee, white),
    500: CarrotSwatch(0xff06aed4, white),
    600: CarrotSwatch(0xff088ab2, white),
    700: CarrotSwatch(0xff0e7090, white),
    800: CarrotSwatch(0xff155b75, white),
    900: CarrotSwatch(0xff164c63, white),
  });

  static const CarrotColor blueLight = CarrotColor(0xff0ba5ec, {
    25: CarrotSwatch(0xfff5fbff, _blueLight),
    50: CarrotSwatch(0xfff0f9ff, _blueLight),
    100: CarrotSwatch(0xffe0f2fe, _blueLight),
    200: CarrotSwatch(0xffb9e6fe, _blueLight),
    300: CarrotSwatch(0xff7cd4fd, white),
    400: CarrotSwatch(0xff36bffa, white),
    500: CarrotSwatch(0xff0ba5ec, white),
    600: CarrotSwatch(0xff0086c9, white),
    700: CarrotSwatch(0xff026aa2, white),
    800: CarrotSwatch(0xff065986, white),
    900: CarrotSwatch(0xff0b4a6f, white),
  });

  static const CarrotColor blue = CarrotColor(0xff2e90fa, {
    25: CarrotSwatch(0xfff5faff, _blue),
    50: CarrotSwatch(0xffeff8ff, _blue),
    100: CarrotSwatch(0xffd1e9ff, _blue),
    200: CarrotSwatch(0xffb2ddff, _blue),
    300: CarrotSwatch(0xff84caff, white),
    400: CarrotSwatch(0xff53b1fd, white),
    500: CarrotSwatch(0xff2e90fa, white),
    600: CarrotSwatch(0xff1570ef, white),
    700: CarrotSwatch(0xff175cd3, white),
    800: CarrotSwatch(0xff1849a9, white),
    900: CarrotSwatch(0xff194185, white),
  });

  static const CarrotColor blueDark = CarrotColor(0xff2970ff, {
    25: CarrotSwatch(0xfff5f8ff, _blueDark),
    50: CarrotSwatch(0xffeff4ff, _blueDark),
    100: CarrotSwatch(0xffd1e0ff, _blueDark),
    200: CarrotSwatch(0xffb2ccff, _blueDark),
    300: CarrotSwatch(0xff84adff, white),
    400: CarrotSwatch(0xff528bff, white),
    500: CarrotSwatch(0xff2970ff, white),
    600: CarrotSwatch(0xff155eef, white),
    700: CarrotSwatch(0xff004eeb, white),
    800: CarrotSwatch(0xff0040c1, white),
    900: CarrotSwatch(0xff00359e, white),
  });

  static const CarrotColor indigo = CarrotColor(0xff6172f3, {
    25: CarrotSwatch(0xfff5f8ff, _indigo),
    50: CarrotSwatch(0xffeef4ff, _indigo),
    100: CarrotSwatch(0xffe0eaff, _indigo),
    200: CarrotSwatch(0xffc7d7fe, _indigo),
    300: CarrotSwatch(0xffa4bcfd, white),
    400: CarrotSwatch(0xff8098f9, white),
    500: CarrotSwatch(0xff6172f3, white),
    600: CarrotSwatch(0xff444ce7, white),
    700: CarrotSwatch(0xff3538cd, white),
    800: CarrotSwatch(0xff2d31a6, white),
    900: CarrotSwatch(0xff2d3282, white),
  });

  static const CarrotColor purple = CarrotColor(0xff7a5af8, {
    25: CarrotSwatch(0xfffafaff, _purple),
    50: CarrotSwatch(0xfff4f3ff, _purple),
    100: CarrotSwatch(0xffebe9fe, _purple),
    200: CarrotSwatch(0xffd9d6fe, _purple),
    300: CarrotSwatch(0xffbdb4fe, white),
    400: CarrotSwatch(0xff9b8afb, white),
    500: CarrotSwatch(0xff7a5af8, white),
    600: CarrotSwatch(0xff6938ef, white),
    700: CarrotSwatch(0xff5925dc, white),
    800: CarrotSwatch(0xff4a1fb8, white),
    900: CarrotSwatch(0xff3e1c96, white),
  });

  static const CarrotColor violet = CarrotColor(0xff875bf7, {
    25: CarrotSwatch(0xfffbfaff, _violet),
    50: CarrotSwatch(0xfff5f3ff, _violet),
    100: CarrotSwatch(0xffece9fe, _violet),
    200: CarrotSwatch(0xffddd6fe, _violet),
    300: CarrotSwatch(0xffc3b5fd, white),
    400: CarrotSwatch(0xffa48afb, white),
    500: CarrotSwatch(0xff875bf7, white),
    600: CarrotSwatch(0xff7839ee, white),
    700: CarrotSwatch(0xff6927da, white),
    800: CarrotSwatch(0xff5720b7, white),
    900: CarrotSwatch(0xff491c96, white),
  });

  static const CarrotColor portage = CarrotColor(0xff9e77ed, {
    25: CarrotSwatch(0xfffcfaff, _portage),
    50: CarrotSwatch(0xfff9f5ff, _portage),
    100: CarrotSwatch(0xfff4ebff, _portage),
    200: CarrotSwatch(0xffe9d7fe, _portage),
    300: CarrotSwatch(0xffd6bbfb, white),
    400: CarrotSwatch(0xffb692f6, white),
    500: CarrotSwatch(0xff9e77ed, white),
    600: CarrotSwatch(0xff7f56d9, white),
    700: CarrotSwatch(0xff6941c6, white),
    800: CarrotSwatch(0xff53389e, white),
    900: CarrotSwatch(0xff42307d, white),
  });

  static const CarrotColor fuchsia = CarrotColor(0xffd444f1, {
    25: CarrotSwatch(0xfffefaff, _fuchsia),
    50: CarrotSwatch(0xfffdf4ff, _fuchsia),
    100: CarrotSwatch(0xfffbe8ff, _fuchsia),
    200: CarrotSwatch(0xfff6d0fe, _fuchsia),
    300: CarrotSwatch(0xffeeaafd, white),
    400: CarrotSwatch(0xffe478fa, white),
    500: CarrotSwatch(0xffd444f1, white),
    600: CarrotSwatch(0xffba24d5, white),
    700: CarrotSwatch(0xff9f1ab1, white),
    800: CarrotSwatch(0xff821890, white),
    900: CarrotSwatch(0xff6f1877, white),
  });

  static const CarrotColor pink = CarrotColor(0xffee46bc, {
    25: CarrotSwatch(0xfffef6fb, _pink),
    50: CarrotSwatch(0xfffdf2fa, _pink),
    100: CarrotSwatch(0xfffce7f6, _pink),
    200: CarrotSwatch(0xfffcceee, _pink),
    300: CarrotSwatch(0xfffaa7e0, white),
    400: CarrotSwatch(0xfff670c7, white),
    500: CarrotSwatch(0xffee46bc, white),
    600: CarrotSwatch(0xffdd2590, white),
    700: CarrotSwatch(0xffc11574, white),
    800: CarrotSwatch(0xff9e165f, white),
    900: CarrotSwatch(0xff851651, white),
  });

  static const CarrotColor rose = CarrotColor(0xfff63d68, {
    25: CarrotSwatch(0xfffff5f6, _rose),
    50: CarrotSwatch(0xfffff1f3, _rose),
    100: CarrotSwatch(0xffffe4e8, _rose),
    200: CarrotSwatch(0xfffecdd6, _rose),
    300: CarrotSwatch(0xfffea3b4, white),
    400: CarrotSwatch(0xfffd6f8e, white),
    500: CarrotSwatch(0xfff63d68, white),
    600: CarrotSwatch(0xffe31b54, white),
    700: CarrotSwatch(0xffc01048, white),
    800: CarrotSwatch(0xffa11043, white),
    900: CarrotSwatch(0xff89123e, white),
  });

  static const CarrotColor red = CarrotColor(0xfff04438, {
    25: CarrotSwatch(0xfffffbfa, _red),
    50: CarrotSwatch(0xfffef3f2, _red),
    100: CarrotSwatch(0xfffee4e2, _red),
    200: CarrotSwatch(0xfffecdca, _red),
    300: CarrotSwatch(0xfffda29b, white),
    400: CarrotSwatch(0xfff97066, white),
    500: CarrotSwatch(0xfff04438, white),
    600: CarrotSwatch(0xffd92d20, white),
    700: CarrotSwatch(0xffb42318, white),
    800: CarrotSwatch(0xff912018, white),
    900: CarrotSwatch(0xff7a271a, white),
  });

  static const CarrotColor orangeDark = CarrotColor(0xffff4405, {
    25: CarrotSwatch(0xfffff9f5, _orangeDark),
    50: CarrotSwatch(0xfffff4ed, _orangeDark),
    100: CarrotSwatch(0xffffe6d5, _orangeDark),
    200: CarrotSwatch(0xffffd6ae, _orangeDark),
    300: CarrotSwatch(0xffff9c66, white),
    400: CarrotSwatch(0xffff692e, white),
    500: CarrotSwatch(0xffff4405, white),
    600: CarrotSwatch(0xffe62e05, white),
    700: CarrotSwatch(0xffbc1b06, white),
    800: CarrotSwatch(0xff97180c, white),
    900: CarrotSwatch(0xff771a0d, white),
  });

  static const CarrotColor orange = CarrotColor(0xffef6820, {
    25: CarrotSwatch(0xfffefaf5, _orange),
    50: CarrotSwatch(0xfffef6ee, _orange),
    100: CarrotSwatch(0xfffdead7, _orange),
    200: CarrotSwatch(0xfff9dbaf, _orange),
    300: CarrotSwatch(0xfff7b27a, white),
    400: CarrotSwatch(0xfff38744, white),
    500: CarrotSwatch(0xffef6820, white),
    600: CarrotSwatch(0xffe04f16, white),
    700: CarrotSwatch(0xffb93815, white),
    800: CarrotSwatch(0xff932f19, white),
    900: CarrotSwatch(0xff772917, white),
  });

  static const CarrotColor amber = CarrotColor(0xfff79009, {
    25: CarrotSwatch(0xfffffcf5, _amber),
    50: CarrotSwatch(0xfffffaeb, _amber),
    100: CarrotSwatch(0xfffef0c7, _amber),
    200: CarrotSwatch(0xfffedf89, _amber),
    300: CarrotSwatch(0xfffec84b, white),
    400: CarrotSwatch(0xfffdb022, white),
    500: CarrotSwatch(0xfff79009, white),
    600: CarrotSwatch(0xffdc6803, white),
    700: CarrotSwatch(0xffb54708, white),
    800: CarrotSwatch(0xff93370d, white),
    900: CarrotSwatch(0xff7a2e0e, white),
  });

  static const CarrotColor yellow = CarrotColor(0xffeaaa08, {
    25: CarrotSwatch(0xfffefdf0, _yellow),
    50: CarrotSwatch(0xfffefbe8, _yellow),
    100: CarrotSwatch(0xfffef7c3, _yellow),
    200: CarrotSwatch(0xfffeee95, _yellow),
    300: CarrotSwatch(0xfffde272, white),
    400: CarrotSwatch(0xfffac515, white),
    500: CarrotSwatch(0xffeaaa08, white),
    600: CarrotSwatch(0xffca8504, white),
    700: CarrotSwatch(0xffa15c07, white),
    800: CarrotSwatch(0xff854a0e, white),
    900: CarrotSwatch(0xff713b12, white),
  });
}

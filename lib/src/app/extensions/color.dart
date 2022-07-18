import 'package:flutter/painting.dart';

import '../../ui/color.dart';

extension CarrotColorExtension on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  double get hue => HSLColor.fromColor(this).hue;
  double get saturation => HSLColor.fromColor(this).saturation;
  double get lightness => HSLColor.fromColor(this).lightness;

  bool get isDark => lightness <= .5;
  bool get isLight => lightness > .5;

  Color darkOrLight({
    Color dark = CarrotColors.black,
    Color light = CarrotColors.white,
  }) => isLight ? light : dark;

  Color darken([double amount = 0.1]) {
    assert(amount >= .0 && amount <= 1.0);

    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= .0 && amount <= 1.0);

    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color withHue(double hue) => hsl
      .withHue(hue % 360.0)
      .toColor();

  Color withSaturation(double saturation) => hsl
      .withSaturation(saturation % 1.0)
      .toColor();

  Color withLightness(double lightness) => hsl
      .withLightness(lightness % 1.0)
      .toColor();
}

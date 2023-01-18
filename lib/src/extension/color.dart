import 'package:flutter/painting.dart';

import '../ui/ui.dart';

extension CarrotColorExtension on Color {
  /// Gets the HSL version of the color.
  HSLColor get hsl => HSLColor.fromColor(this);

  /// Gets the hue of the color.
  double get hue => hsl.hue;

  /// Gets the saturation of the color.
  double get saturation => hsl.saturation;

  /// Gets the lightness of the color.
  double get lightness => hsl.lightness;

  /// Returns `true` if the color is considered dark.
  bool get isDark => lightness <= .5;

  /// Returns `true` if the color is considered light.
  bool get isLight => lightness > .5;

  /// Returns [dark] if the color is dark and returns [light]
  /// if the color is light.
  Color darkOrLight({
    Color dark = CarrotColors.black,
    Color light = CarrotColors.white,
  }) =>
      isLight ? light : dark;

  /// Darkens the color by the given [amount].
  Color darken([double amount = 0.1]) {
    assert(amount >= .0 && amount <= 1.0);

    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// Lightens the color by the given [amount].
  Color lighten([double amount = 0.1]) {
    assert(amount >= .0 && amount <= 1.0);

    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Sets the [hue] of the color and returns the new color.
  Color withHue(double hue) => hsl.withHue(hue % 360.0).toColor();

  /// Sets the [saturation] of the color and returns the new color.
  Color withSaturation(double saturation) => hsl.withSaturation(saturation % 1.0).toColor();

  /// Sets the [lightness] of the color and returns the new color.
  Color withLightness(double lightness) => hsl.withLightness(lightness % 1.0).toColor();
}

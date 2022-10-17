import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../app/extensions/extensions.dart';

/// note:
/// use 0, 10 and 90 for foreground colors.

class CarrotTonalColor extends Color {
  final Map<int, Color> _tones;

  const CarrotTonalColor(super.value, this._tones);

  Color tone(int tone) {
    return withLightness(tone / 100);
  }

  Color operator [](int index) {
    assert(index >= 0 && index <= 100, 'The given tone index should be between 0 and 100.');

    if (!_tones.containsKey(index)) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotTonalColor.[] is called with a missing shade "$index".',
        ),
      ]);
    }

    return _tones[index]!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (runtimeType != other.runtimeType) {
      return false;
    }

    return other is CarrotTonalColor && value == other.value && mapEquals(_tones, other._tones);
  }

  @override
  int get hashCode => super.hashCode ^ _tones.hashCode;

  static CarrotTonalColor fromColor(Color color, [bool isDark = false]) {
    final hsl = HSLColor.fromColor(color);

    return CarrotTonalColor(color.value, {
      0: hsl.withLightness(isDark ? 1 : 0).toColor(),
      10: hsl.withLightness(isDark ? .99 : .1).toColor(),
      20: hsl.withLightness(isDark ? .95 : .2).toColor(),
      30: hsl.withLightness(isDark ? .9 : .3).toColor(),
      40: hsl.withLightness(isDark ? .8 : .4).toColor(),
      50: hsl.withLightness(isDark ? .7 : .5).toColor(),
      60: hsl.withLightness(isDark ? .6 : .6).toColor(),
      70: hsl.withLightness(isDark ? .5 : .7).toColor(),
      80: hsl.withLightness(isDark ? .4 : .8).toColor(),
      90: hsl.withLightness(isDark ? .3 : .9).toColor(),
      95: hsl.withLightness(isDark ? .2 : .95).toColor(),
      99: hsl.withLightness(isDark ? .1 : .99).toColor(),
      100: hsl.withLightness(isDark ? 0 : 1).toColor(),
    });
  }

  static CarrotTonalColor lerp(CarrotTonalColor a, CarrotTonalColor b, double t) {
    return CarrotTonalColor(Color.lerp(a, b, t)!.value, {
      0: Color.lerp(a[0], b[0], t)!,
      10: Color.lerp(a[10], b[10], t)!,
      20: Color.lerp(a[20], b[20], t)!,
      30: Color.lerp(a[30], b[30], t)!,
      40: Color.lerp(a[40], b[40], t)!,
      50: Color.lerp(a[50], b[50], t)!,
      60: Color.lerp(a[60], b[60], t)!,
      70: Color.lerp(a[70], b[70], t)!,
      80: Color.lerp(a[80], b[80], t)!,
      90: Color.lerp(a[90], b[90], t)!,
      95: Color.lerp(a[95], b[95], t)!,
      99: Color.lerp(a[99], b[99], t)!,
      100: Color.lerp(a[100], b[100], t)!,
    });
  }
}

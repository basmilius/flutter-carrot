import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../app/extensions/extensions.dart';

/// note:
/// use 0, 10 and 90 for foreground colors.

final Map<int, Map<int, Color>> _toneCache = {};
const _tones = [
  0,
  10,
  20,
  30,
  40,
  50,
  60,
  70,
  80,
  90,
  95,
  99,
  100,
];
const _tonesDark = {
  0: 100,
  10: 90,
  20: 80,
  30: 70,
  40: 60,
  50: 50,
  60: 40,
  70: 30,
  80: 20,
  90: 10,
  95: 5,
  99: 1,
  100: 0,
};

class CarrotTonalColor extends Color {
  final bool isDark;

  const CarrotTonalColor(super.value, [this.isDark = false]);

  factory CarrotTonalColor.fromColor(Color color, [bool isDark = false]) {
    return CarrotTonalColor(color.value);
  }

  Color tone(int tone) {
    return withLightness(tone / 100);
  }

  Color operator [](int index) {
    assert(_tones.contains(index), 'The requested tone is not available. Choose from $_tones.');

    if (isDark) {
      index = _tonesDark[index]!;
    }

    _toneCache[hashCode] ??= {};
    _toneCache[hashCode]![index] = tone(index);

    debugPrint('${_toneCache[hashCode]![index]} ${tone(index)} $index ${index / 100}');

    return _toneCache[hashCode]![index]!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (runtimeType != other.runtimeType) {
      return false;
    }

    return other is CarrotTonalColor && isDark == other.isDark && value == other.value;
  }

  @override
  int get hashCode => super.hashCode ^ isDark.hashCode;

  static CarrotTonalColor lerp(CarrotTonalColor a, CarrotTonalColor b, double t) {
    return CarrotTonalColor(Color.lerp(a, b, t)!.value);
  }
}

class CarrotTonalColors {
  static const slate = CarrotTonalColor(0xff64748b);
  static const slateDark = CarrotTonalColor(0xff64748b, true);
  static const gray = CarrotTonalColor(0xff6b7280);
  static const grayDark = CarrotTonalColor(0xff6b7280, true);
  static const zinc = CarrotTonalColor(0xff71717a);
  static const zincDark = CarrotTonalColor(0xff71717a, true);
  static const neutral = CarrotTonalColor(0xff737373);
  static const neutralDark = CarrotTonalColor(0xff737373, true);
  static const stone = CarrotTonalColor(0xff78716c);
  static const stoneDark = CarrotTonalColor(0xff78716c, true);

  static const red = CarrotTonalColor(0xffef4444);
  static const redDark = CarrotTonalColor(0xffef4444, true);
  static const orange = CarrotTonalColor(0xfff97316);
  static const orangeDark = CarrotTonalColor(0xfff97316, true);
  static const amber = CarrotTonalColor(0xfff59e0b);
  static const amberDark = CarrotTonalColor(0xfff59e0b, true);
  static const yellow = CarrotTonalColor(0xffeab308);
  static const yellowDark = CarrotTonalColor(0xffeab308, true);
  static const lime = CarrotTonalColor(0xff84cc16);
  static const limeDark = CarrotTonalColor(0xff84cc16, true);
  static const green = CarrotTonalColor(0xff22c55e);
  static const greenDark = CarrotTonalColor(0xff22c55e, true);
  static const emerald = CarrotTonalColor(0xff10b981);
  static const emeraldDark = CarrotTonalColor(0xff10b981, true);
  static const teal = CarrotTonalColor(0xff14b8a6);
  static const tealDark = CarrotTonalColor(0xff14b8a6, true);
  static const cyan = CarrotTonalColor(0xff06b6d4);
  static const cyanDark = CarrotTonalColor(0xff06b6d4, true);
  static const sky = CarrotTonalColor(0xff0ea5e9);
  static const skyDark = CarrotTonalColor(0xff0ea5e9, true);
  static const blue = CarrotTonalColor(0xff3b82f6);
  static const blueDark = CarrotTonalColor(0xff3b82f6, true);
  static const indigo = CarrotTonalColor(0xff6366f1);
  static const indigoDark = CarrotTonalColor(0xff6366f1, true);
  static const violet = CarrotTonalColor(0xff8b5cf6);
  static const violetDark = CarrotTonalColor(0xff8b5cf6, true);
  static const purple = CarrotTonalColor(0xffa855f7);
  static const purpleDark = CarrotTonalColor(0xffa855f7, true);
  static const fuchsia = CarrotTonalColor(0xffd946ef);
  static const fuchsiaDark = CarrotTonalColor(0xffd946ef, true);
  static const pink = CarrotTonalColor(0xffec4899);
  static const pinkDark = CarrotTonalColor(0xffec4899, true);
  static const rose = CarrotTonalColor(0xfff43f5e);
  static const roseDark = CarrotTonalColor(0xfff43f5e, true);
}

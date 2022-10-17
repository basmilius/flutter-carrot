import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class CarrotColor extends Color {
  final Map<int, Color> _swatch;

  const CarrotColor(super.value, this._swatch);

  Color operator [](int index) {
    assert(index >= 0 && index <= 900, 'CarrotColor only has shades between 0 and 900.');

    if (index % 100 > 0) {
      int lowerIndex = (index / 100).floor() * 100;
      int upperIndex = (index / 100).ceil() * 100;

      final a = _swatch[lowerIndex]!;
      final b = _swatch[upperIndex]!;

      return Color.lerp(a, b, (upperIndex - index) / 100)!;
    }

    return _swatch[index]!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return super == other && other is CarrotColor && mapEquals(other._swatch, _swatch);
  }

  @override
  int get hashCode => Object.hash(runtimeType, value, _swatch);

  CarrotColor reverse() => CarrotColor(this[300].value, {
        0: this[900],
        50: this[800],
        100: this[700],
        200: this[600],
        300: this[500],
        400: this[400],
        500: this[300],
        600: this[200],
        700: this[100],
        800: this[50],
        900: this[0],
      });

  static CarrotColor lerp(CarrotColor a, CarrotColor b, double t) {
    return CarrotColor(Color.lerp(a[500], b[500], t)!.value, {
      0: Color.lerp(a[0], b[0], t)!,
      50: Color.lerp(a[50], b[50], t)!,
      100: Color.lerp(a[100], b[100], t)!,
      200: Color.lerp(a[200], b[200], t)!,
      300: Color.lerp(a[300], b[300], t)!,
      400: Color.lerp(a[400], b[400], t)!,
      500: Color.lerp(a[500], b[500], t)!,
      600: Color.lerp(a[600], b[600], t)!,
      700: Color.lerp(a[700], b[700], t)!,
      800: Color.lerp(a[800], b[800], t)!,
      900: Color.lerp(a[900], b[900], t)!,
    });
  }
}

class CarrotColors {
  CarrotColors._();

  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const CarrotColor gray = CarrotColor(0xff6b7280, {
    0: white,
    50: Color(0xfff9fafb),
    100: Color(0xfff3f4f6),
    200: Color(0xffe5e7eb),
    300: Color(0xffd1d5db),
    400: Color(0xff9ca3af),
    500: Color(0xff6b7280),
    600: Color(0xff4b5563),
    700: Color(0xff374151),
    800: Color(0xff1f2937),
    900: Color(0xff111827),
  });

  static const CarrotColor neutral = CarrotColor(0xff737373, {
    0: white,
    50: Color(0xfffafafa),
    100: Color(0xfff5f5f5),
    200: Color(0xffe5e5e5),
    300: Color(0xffd4d4d4),
    400: Color(0xffa3a3a3),
    500: Color(0xff737373),
    600: Color(0xff525252),
    700: Color(0xff404040),
    800: Color(0xff262626),
    900: Color(0xff171717),
  });

  static const CarrotColor slate = CarrotColor(0xff64748b, {
    0: white,
    50: Color(0xfff8fafc),
    100: Color(0xfff1f5f9),
    200: Color(0xffe2e8f0),
    300: Color(0xffcbd5e1),
    400: Color(0xff94a3b8),
    500: Color(0xff64748b),
    600: Color(0xff475569),
    700: Color(0xff334155),
    800: Color(0xff1e293b),
    900: Color(0xff0f172a),
  });

  static const CarrotColor stone = CarrotColor(0xff78716c, {
    0: white,
    50: Color(0xfffafaf9),
    100: Color(0xfff5f5f4),
    200: Color(0xffe7e5e4),
    300: Color(0xffd6d3d1),
    400: Color(0xffa8a29e),
    500: Color(0xff78716c),
    600: Color(0xff57534e),
    700: Color(0xff44403c),
    800: Color(0xff292524),
    900: Color(0xff1c1917),
  });

  static const CarrotColor zinc = CarrotColor(0xff71717a, {
    0: white,
    50: Color(0xfffafafa),
    100: Color(0xfff4f4f5),
    200: Color(0xffe4e4e7),
    300: Color(0xffd4d4d8),
    400: Color(0xffa1a1aa),
    500: Color(0xff71717a),
    600: Color(0xff52525b),
    700: Color(0xff3f3f46),
    800: Color(0xff27272a),
    900: Color(0xff18181b),
  });

  static const CarrotColor amber = CarrotColor(0xfff59e0b, {
    0: white,
    50: Color(0xfffffbeb),
    100: Color(0xfffef3c7),
    200: Color(0xfffde68a),
    300: Color(0xfffcd34d),
    400: Color(0xfffbbf24),
    500: Color(0xfff59e0b),
    600: Color(0xffd97706),
    700: Color(0xffb45309),
    800: Color(0xff92400e),
    900: Color(0xff78350f),
  });

  static const CarrotColor blue = CarrotColor(0xff3b82f6, {
    0: white,
    50: Color(0xffeff6ff),
    100: Color(0xffdbeafe),
    200: Color(0xffbfdbfe),
    300: Color(0xff93c5fd),
    400: Color(0xff60a5fa),
    500: Color(0xff3b82f6),
    600: Color(0xff2563eb),
    700: Color(0xff1d4ed8),
    800: Color(0xff1e40af),
    900: Color(0xff1e3a8a),
  });

  static const CarrotColor cyan = CarrotColor(0xff06b6d4, {
    0: white,
    50: Color(0xffecfeff),
    100: Color(0xffcffafe),
    200: Color(0xffa5f3fc),
    300: Color(0xff67e8f9),
    400: Color(0xff22d3ee),
    500: Color(0xff06b6d4),
    600: Color(0xff0891b2),
    700: Color(0xff0e7490),
    800: Color(0xff155e75),
    900: Color(0xff164e63),
  });

  static const CarrotColor emerald = CarrotColor(0xff10b981, {
    0: white,
    50: Color(0xffecfdf5),
    100: Color(0xffd1fae5),
    200: Color(0xffa7f3d0),
    300: Color(0xff6ee7b7),
    400: Color(0xff34d399),
    500: Color(0xff10b981),
    600: Color(0xff059669),
    700: Color(0xff047857),
    800: Color(0xff065f46),
    900: Color(0xff064e3b),
  });

  static const CarrotColor fuchsia = CarrotColor(0xffd946ef, {
    0: white,
    50: Color(0xfffdf4ff),
    100: Color(0xfffae8ff),
    200: Color(0xfff5d0fe),
    300: Color(0xfff0abfc),
    400: Color(0xffe879f9),
    500: Color(0xffd946ef),
    600: Color(0xffc026d3),
    700: Color(0xffa21caf),
    800: Color(0xff86198f),
    900: Color(0xff701a75),
  });

  static const CarrotColor green = CarrotColor(0xff22c55e, {
    0: white,
    50: Color(0xfff0fdf4),
    100: Color(0xffdcfce7),
    200: Color(0xffbbf7d0),
    300: Color(0xff86efac),
    400: Color(0xff4ade80),
    500: Color(0xff22c55e),
    600: Color(0xff16a34a),
    700: Color(0xff15803d),
    800: Color(0xff166534),
    900: Color(0xff14532d),
  });

  static const CarrotColor indigo = CarrotColor(0xff6366f1, {
    0: white,
    50: Color(0xffeef2ff),
    100: Color(0xffe0e7ff),
    200: Color(0xffc7d2fe),
    300: Color(0xffa5b4fc),
    400: Color(0xff818cf8),
    500: Color(0xff6366f1),
    600: Color(0xff4f46e5),
    700: Color(0xff4338ca),
    800: Color(0xff3730a3),
    900: Color(0xff312e81),
  });

  static const CarrotColor lime = CarrotColor(0xff84cc16, {
    0: white,
    50: Color(0xfff7fee7),
    100: Color(0xffecfccb),
    200: Color(0xffd9f99d),
    300: Color(0xffbef264),
    400: Color(0xffa3e635),
    500: Color(0xff84cc16),
    600: Color(0xff65a30d),
    700: Color(0xff4d7c0f),
    800: Color(0xff3f6212),
    900: Color(0xff365314),
  });

  static const CarrotColor orange = CarrotColor(0xfff97316, {
    0: white,
    50: Color(0xfffff7ed),
    100: Color(0xffffedd5),
    200: Color(0xfffed7aa),
    300: Color(0xfffdba74),
    400: Color(0xfffb923c),
    500: Color(0xfff97316),
    600: Color(0xffea580c),
    700: Color(0xffc2410c),
    800: Color(0xff9a3412),
    900: Color(0xff7c2d12),
  });

  static const CarrotColor pink = CarrotColor(0xffec4899, {
    0: white,
    50: Color(0xfffdf2f8),
    100: Color(0xfffce7f3),
    200: Color(0xfffbcfe8),
    300: Color(0xfff9a8d4),
    400: Color(0xfff472b6),
    500: Color(0xffec4899),
    600: Color(0xffdb2777),
    700: Color(0xffbe185d),
    800: Color(0xff9d174d),
    900: Color(0xff831843),
  });

  static const CarrotColor purple = CarrotColor(0xffa855f7, {
    0: white,
    50: Color(0xfffaf5ff),
    100: Color(0xfff3e8ff),
    200: Color(0xffe9d5ff),
    300: Color(0xffd8b4fe),
    400: Color(0xffc084fc),
    500: Color(0xffa855f7),
    600: Color(0xff9333ea),
    700: Color(0xff7e22ce),
    800: Color(0xff6b21a8),
    900: Color(0xff581c87),
  });

  static const CarrotColor red = CarrotColor(0xffef4444, {
    0: white,
    50: Color(0xfffef2f2),
    100: Color(0xfffee2e2),
    200: Color(0xfffecaca),
    300: Color(0xfffca5a5),
    400: Color(0xfff87171),
    500: Color(0xffef4444),
    600: Color(0xffdc2626),
    700: Color(0xffb91c1c),
    800: Color(0xff991b1b),
    900: Color(0xff7f1d1d),
  });

  static const CarrotColor rose = CarrotColor(0xfff43f5e, {
    0: white,
    50: Color(0xfffff1f2),
    100: Color(0xffffe4e6),
    200: Color(0xfffecdd3),
    300: Color(0xfffda4af),
    400: Color(0xfffb7185),
    500: Color(0xfff43f5e),
    600: Color(0xffe11d48),
    700: Color(0xffbe123c),
    800: Color(0xff9f1239),
    900: Color(0xff881337),
  });

  static const CarrotColor sky = CarrotColor(0xff0ea5e9, {
    0: white,
    50: Color(0xfff0f9ff),
    100: Color(0xffe0f2fe),
    200: Color(0xffbae6fd),
    300: Color(0xff7dd3fc),
    400: Color(0xff38bdf8),
    500: Color(0xff0ea5e9),
    600: Color(0xff0284c7),
    700: Color(0xff0369a1),
    800: Color(0xff075985),
    900: Color(0xff0c4a6e),
  });

  static const CarrotColor teal = CarrotColor(0xff14b8a6, {
    0: white,
    50: Color(0xfff0fdfa),
    100: Color(0xffccfbf1),
    200: Color(0xff99f6e4),
    300: Color(0xff5eead4),
    400: Color(0xff2dd4bf),
    500: Color(0xff14b8a6),
    600: Color(0xff0d9488),
    700: Color(0xff0f766e),
    800: Color(0xff115e59),
    900: Color(0xff134e4a),
  });

  static const CarrotColor violet = CarrotColor(0xff8b5cf6, {
    0: white,
    50: Color(0xfff5f3ff),
    100: Color(0xffede9fe),
    200: Color(0xffddd6fe),
    300: Color(0xffc4b5fd),
    400: Color(0xffa78bfa),
    500: Color(0xff8b5cf6),
    600: Color(0xff7c3aed),
    700: Color(0xff6d28d9),
    800: Color(0xff5b21b6),
    900: Color(0xff4c1d95),
  });

  static const CarrotColor yellow = CarrotColor(0xffeab308, {
    0: white,
    50: Color(0xfffefce8),
    100: Color(0xfffef9c3),
    200: Color(0xfffef08a),
    300: Color(0xfffde047),
    400: Color(0xfffacc15),
    500: Color(0xffeab308),
    600: Color(0xffca8a04),
    700: Color(0xffa16207),
    800: Color(0xff854d0e),
    900: Color(0xff713f12),
  });
}

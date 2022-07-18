import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import '../../ui/theme.dart';

typedef _Walker<D, V> = V? Function(D);

abstract class CarrotComponentTheme {
  @protected
  const CarrotComponentTheme();
}

abstract class CarrotComponentThemeProxy<T extends CarrotComponentThemeProxy<T, D>, D extends CarrotComponentTheme> with _ThemeHelpers {
  final D data;
  final T? parent;

  @protected
  CarrotComponentThemeProxy({
    required this.data,
    this.parent,
  });

  CarrotComponentThemeProxy extend(D? other);

  @protected
  // ignore: library_private_types_in_public_api
  V walk<V>(_Walker<D, V> walker, V defaultValue) {
    return walkLoose(walker) ?? defaultValue;
  }

  @protected
  // ignore: library_private_types_in_public_api
  V? walkLoose<V>(_Walker<D, V> walker) {
    CarrotComponentThemeProxy<T, D>? current = this;
    V? value;

    while (current != null) {
      value = walker(current.data);

      if (value != null) {
        break;
      }

      current = current.parent;
    }

    return value;
  }
}

mixin _ThemeHelpers {
  BuildContext? _context;

  CarrotTheme get _theme {
    _ensureContext();

    return _context!.carrotTheme;
  }

  bool get darkMode => _theme.darkMode;

  CarrotTypography get typography => _theme.typography;

  void build(BuildContext context) {
    _context = context;
  }

  void _ensureContext() {
    assert(_context != null, "CarrotComponentThemeProxy.build() was probably not called.");
  }

  @protected
  Color gray(int shade) => _theme.gray[shade];

  @protected
  Color primary(int shade) => _theme.primary[shade];
}

import 'package:flutter/foundation.dart';

typedef CarrotValueChangedCallback<T> = void Function(T);

class CarrotValueController<T> extends ChangeNotifier with Diagnosticable {
  final CarrotValueChangedCallback<T>? onChanged;

  T _value;

  T get value => _value;

  set value(T value) {
    if (_value == value) {
      return;
    }

    _value = value;
    notifyListeners();
    onChanged?.call(_value);
  }

  CarrotValueController({
    required T value,
    this.onChanged,
  }) : _value = value;
}

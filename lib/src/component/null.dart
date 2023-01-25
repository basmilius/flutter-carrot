import 'package:flutter/widgets.dart';

class CarrotNullElement extends Element {
  CarrotNullElement() : super(const CarrotNullWidget());

  static CarrotNullElement instance = CarrotNullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();
}

class CarrotNullWidget extends Widget {
  const CarrotNullWidget({
    super.key,
  });

  @override
  Element createElement() => throw UnimplementedError();
}

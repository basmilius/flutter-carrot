import 'package:flutter/widgets.dart';

const nothing = CarrotNothing();

class CarrotNothing extends Widget {
  const CarrotNothing({
    super.key,
  });

  @override
  createElement() => _CarrotNothingElement(this);
}

class _CarrotNothingElement extends Element {
  @override
  bool get debugDoingBuild => false;

  _CarrotNothingElement(super.widget);

  @override
  void mount(Element? parent, dynamic newSlot) {
    assert(parent is! MultiChildRenderObjectElement, 'CarrotNothing is probably not needed.');
    super.mount(parent, newSlot);
  }
}

import 'package:flutter/widgets.dart';

import 'base_fades.dart' show FadeInBuilder;

abstract class _FlipInBuilder extends FadeInBuilder {
  late Animation<double> rotation;

  @override
  Widget build(BuildContext context, Widget child) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: transform(),
      child: super.build(context, child),
    );
  }

  @override
  void init(controller) {
    super.init(controller);
    rotation = Tween<double>(begin: 1.5, end: 0.0).animate(controller);
  }

  Matrix4 transform();
}

class FlipInXBuilder extends _FlipInBuilder {
  @override
  transform() => _makeMatrix4(1.0)..rotateX(rotation.value);
}

class FlipInYBuilder extends _FlipInBuilder {
  @override
  transform() => _makeMatrix4(1.0)..rotateY(rotation.value);
}

class FlipInXYBuilder extends _FlipInBuilder {
  @override
  transform() => _makeMatrix4(1.0)
    ..rotateX(rotation.value / -3)
    ..rotateY(rotation.value);
}

Matrix4 _makeMatrix4([double pv = 1.0]) => Matrix4(
  1.0,
  0.0,
  0.0,
  0.0,
  //
  0.0,
  1.0,
  0.0,
  0.0,
  //
  0.0,
  0.0,
  1.0,
  pv * 0.001,
  //
  0.0,
  0.0,
  0.0,
  1.0,
);

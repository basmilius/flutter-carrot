import 'package:flutter/widgets.dart';

class CarrotBouncingScrollPhysics extends BouncingScrollPhysics {
  const CarrotBouncingScrollPhysics() : super(parent: const AlwaysScrollableScrollPhysics());

  const CarrotBouncingScrollPhysics.notAlways();
}

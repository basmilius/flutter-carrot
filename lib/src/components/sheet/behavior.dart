import 'package:flutter/widgets.dart';

import 'physics.dart';

class CarrotSheetBehavior extends ScrollBehavior {
  static const CarrotSheetPhysics _clampingPhysics = CarrotSheetNoMomentumPhysics(parent: RangeMaintainingScrollPhysics());

  @override
  CarrotSheetPhysics getScrollPhysics(BuildContext context) {
    return _clampingPhysics;
  }
}

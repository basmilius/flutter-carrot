import 'package:flutter/widgets.dart';

import 'position.dart';

abstract class CarrotSheetScrollContext extends ScrollContext {
  double? get initialExtent;

  CarrotSheetPosition get position;
}

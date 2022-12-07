import 'package:flutter/widgets.dart';

import 'physics.dart';

class CarrotScrollBehavior extends ScrollBehavior {
  const CarrotScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const CarrotBouncingScrollPhysics();
  }
}

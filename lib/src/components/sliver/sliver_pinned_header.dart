import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CarrotSliverPinnedHeader extends SingleChildRenderObjectWidget {
  const CarrotSliverPinnedHeader({
    super.key,
    required super.child,
  });

  @override
  CarrotSliverPinnedHeaderRenderer createRenderObject(BuildContext context) {
    return CarrotSliverPinnedHeaderRenderer();
  }
}

class CarrotSliverPinnedHeaderRenderer extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    assert(child != null, "Child should not be null.");

    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtend = constraints.axis == Axis.horizontal ? child!.size.width : child!.size.height;
    final paintedChildExtend = math.min(childExtend, constraints.remainingPaintExtent - constraints.overlap);

    geometry = SliverGeometry(
      paintExtent: paintedChildExtend,
      maxPaintExtent: childExtend,
      maxScrollObstructionExtent: childExtend,
      paintOrigin: constraints.overlap,
      scrollExtent: childExtend,
      layoutExtent: math.max(0.0, paintedChildExtend - constraints.scrollOffset),
      hasVisualOverflow: paintedChildExtend < childExtend,
    );
  }

  @override
  double childMainAxisPosition(covariant RenderBox child) {
    return 0;
  }
}

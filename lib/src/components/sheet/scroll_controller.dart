import 'package:flutter/widgets.dart';

import 'context.dart';
import 'position.dart';

class CarrotSheetScrollController extends ScrollController {
  final CarrotSheetScrollContext context;

  CarrotSheetScrollController({
    required this.context,
    super.debugLabel,
    super.initialScrollOffset = .0,
  });

  @override
  CarrotSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      CarrotSheetScrollPosition(
        context: context,
        oldPosition: oldPosition,
        physics: physics,
        sheetContext: this.context,
      );
}

class CarrotSheetScrollPosition extends ScrollPositionWithSingleContext {
  final CarrotSheetScrollContext sheetContext;

  CarrotSheetPosition get sheetPosition => sheetContext.position;

  CarrotSheetScrollPosition({
    required super.context,
    required super.physics,
    required this.sheetContext,
    super.debugLabel,
    super.initialPixels = .0,
    super.keepScrollOffset = true,
    super.oldPosition,
  });

  bool shouldSheetAcceptUserOffset(double delta) {
    final canDragForward = delta >= 0 && pixels <= minScrollExtent;
    final canDragBackwards = delta < 0 && sheetPosition.pixels < sheetPosition.maxScrollExtent && pixels <= minScrollExtent;

    return sheetPosition.physics.shouldAcceptUserOffset(sheetPosition) && (canDragForward || canDragBackwards);
  }

  @override
  void applyUserOffset(double delta) {
    if (sheetPosition.preventingDrag) {
      return;
    }

    if (shouldSheetAcceptUserOffset(delta)) {
      final pixels = sheetPosition.pixels - sheetPosition.physics.applyPhysicsToUserOffset(sheetPosition, delta);

      sheetPosition.forcePixels(pixels.clamp(sheetPosition.minScrollExtent, sheetPosition.maxScrollExtent));
      sheetPosition.beginActivity(_CarrotSheetScrollActivity(sheetPosition));
    } else {
      super.applyUserOffset(delta);
      sheetPosition.goIdle();
    }
  }

  @override
  void goBallistic(double velocity) {
    if (sheetPosition.preventingDrag) {
      beginActivity(BallisticScrollActivity(
        this,
        ScrollSpringSimulation(
          SpringDescription.withDampingRatio(
            mass: .5,
            stiffness: 100.0,
            ratio: 1.1,
          ),
          pixels,
          0,
          velocity,
        ),
        context.vsync,
      ));

      return;
    }

    final sheetDragging = sheetPosition.activity!.isScrolling;

    if (sheetDragging && sheetPosition.hasContentDimensions && !sheetPosition.preventingDrag && sheetPosition.activity!.isScrolling) {
      sheetPosition.goBallistic(velocity);
    } else {
      sheetPosition.goIdle();
    }

    if (!sheetDragging) {
      super.goBallistic(velocity);
      return;
    } else if (velocity > .0 && sheetPosition.pixels >= sheetPosition.maxScrollExtent || (velocity < .0 && pixels > 0)) {
      return;
    } else if (outOfRange) {
      beginActivity(BallisticScrollActivity(
        this,
        ScrollSpringSimulation(
          SpringDescription.withDampingRatio(
            mass: .5,
            stiffness: 100.0,
            ratio: 1.1,
          ),
          pixels,
          0,
          velocity,
        ),
        context.vsync,
      ));

      return;
    }

    goIdle();
  }
}

class _CarrotSheetScrollActivity extends ScrollActivity {
  @override
  bool get isScrolling => true;

  @override
  bool get shouldIgnorePointer => false;

  @override
  double get velocity => .0;

  _CarrotSheetScrollActivity(CarrotSheetPosition super.delegate);
}

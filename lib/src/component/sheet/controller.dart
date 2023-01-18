import 'package:flutter/widgets.dart';

import 'context.dart';
import 'position.dart';

class CarrotSheetController extends ScrollController {
  final ProxyAnimation _animation = ProxyAnimation();

  Animation<double> get animation => _animation;

  @override
  CarrotSheetPosition get position => super.position as CarrotSheetPosition;

  CarrotSheetController({
    super.debugLabel,
    super.initialScrollOffset = 0,
  });

  void updateAnimation() {
    if (hasClients) {
      final position = positions.first;

      if (position is CarrotSheetPosition) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _animation.parent = position.animationController;
        });

        return;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animation.parent = kAlwaysDismissedAnimation;
    });
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    updateAnimation();
  }

  @override
  void detach(ScrollPosition position) {
    super.detach(position);
    updateAnimation();
  }

  @override
  CarrotSheetPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    final initialPixels = (context is CarrotSheetScrollContext) ? context.initialExtent : null;

    return CarrotSheetPosition(
      context: context as CarrotSheetScrollContext,
      initialPixels: initialPixels ?? .0,
      oldPosition: oldPosition,
      physics: physics,
    );
  }

  Future<void> relativeAnimateTo(
    double offset, {
    required Curve curve,
    required Duration duration,
  }) async {
    assert(positions.isNotEmpty, 'ScrollController not attached to any scroll views.');

    await Future.wait<void>([
      for (final position in positions)
        (position as CarrotSheetPosition).relativeAnimateTo(
          offset,
          curve: curve,
          duration: duration,
        ),
    ]);
  }

  void relativeJumpTo(double offset) {
    assert(positions.isNotEmpty, 'ScrollController not attached to any scroll views.');

    for (final position in positions) {
      (position as CarrotSheetPosition).relativeJumpTo(offset);
    }
  }
}

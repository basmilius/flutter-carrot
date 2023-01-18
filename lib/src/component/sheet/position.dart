import 'package:flutter/widgets.dart';

import 'context.dart';
import 'scroll_controller.dart';

class CarrotSheetPosition extends ScrollPositionWithSingleContext {
  late final AnimationController _animationController = AnimationController(vsync: context.vsync);
  late final CarrotSheetScrollController _scrollController = CarrotSheetScrollController(context: context as CarrotSheetScrollContext);

  bool _preventingDrag = false;

  AnimationController get animationController => _animationController;

  bool get preventingDrag => _preventingDrag;

  CarrotSheetScrollController get scrollController => _scrollController;

  CarrotSheetPosition({
    required CarrotSheetScrollContext super.context,
    required super.physics,
    super.debugLabel,
    super.initialPixels = .0,
    super.keepScrollOffset = true,
    super.oldPosition,
  });

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    if (!hasContentDimensions) {
      correctPixels(pixels.clamp(minScrollExtent, maxScrollExtent));
      _animationController.value = _relativeOffsetFromPixels(pixels, minScrollExtent, maxScrollExtent);
    }

    return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
  }

  @override
  Future<void> animateTo(
    double to, {
    required Curve curve,
    required Duration duration,
  }) {
    return super.animateTo(
      to.clamp(minScrollExtent, maxScrollExtent),
      curve: curve,
      duration: duration,
    );
  }

  Future<void> relativeAnimateTo(
    double to, {
    required Curve curve,
    required Duration duration,
  }) {
    assert(to >= 0 && to <= 1);

    return super.animateTo(
      _pixelsFromRelativeOffset(to, minScrollExtent, maxScrollExtent),
      curve: curve,
      duration: duration,
    );
  }

  @override
  void jumpTo(double value) {
    final pixels = value.clamp(minScrollExtent, maxScrollExtent);
    super.jumpTo(pixels);
  }

  void relativeJumpTo(double value) {
    assert(value >= 0 && value <= 1);
    final pixels = _pixelsFromRelativeOffset(value, minScrollExtent, maxScrollExtent);
    super.jumpTo(pixels);
  }

  @override
  void forcePixels(double value) {
    _animationController.value = _relativeOffsetFromPixels(value, minScrollExtent, maxScrollExtent);
    super.forcePixels(value);
  }

  @override
  double setPixels(double newPixels) {
    _animationController.value = _relativeOffsetFromPixels(newPixels, minScrollExtent, maxScrollExtent);
    return super.setPixels(newPixels);
  }

  void disablePreventDrag() {
    _preventingDrag = false;
  }

  void enablePreventDrag() {
    _preventingDrag = true;
  }
}

double _pixelsFromRelativeOffset(double offset, double minScrollExtent, double maxScrollExtent) {
  return minScrollExtent + offset * (maxScrollExtent - minScrollExtent);
}

double _relativeOffsetFromPixels(double pixels, double minScrollExtent, double maxScrollExtent) {
  if (minScrollExtent == maxScrollExtent) {
    return 1;
  }

  return ((pixels - minScrollExtent) / (maxScrollExtent - minScrollExtent)).clamp(.0, 1.0);
}

import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

typedef CarrotOverflowScrollDismissCallback = void Function(double velocity);

class CarrotOverflowScrollController extends ScrollController {
  final bool enableOverflow;
  final CarrotOverflowScrollExtent extent;

  CarrotOverflowScrollExtentState get state => extent.state;

  @override
  CarrotOverflowScrollPosition get position => super.position as CarrotOverflowScrollPosition;

  CarrotOverflowScrollController({
    super.debugLabel,
    super.initialScrollOffset = 0.0,
    required CarrotOverflowScrollDismissCallback onRequestDismiss,
    required VoidCallback onStateChanged,
    this.enableOverflow = true,
  })  : extent = CarrotOverflowScrollExtent(
          enableOverflow: enableOverflow,
          onRequestDismiss: onRequestDismiss,
          onStateChanged: onStateChanged,
        );

  @override
  CarrotOverflowScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      CarrotOverflowScrollPosition(
        context: context,
        physics: physics,
        oldPosition: oldPosition,
        extent: extent,
      );

  @override
  void dispose() {
    extent.dispose();
    super.dispose();
  }
}

class CarrotOverflowScrollExtent {
  final ValueNotifier<CarrotOverflowScrollExtentState> _state;

  final bool enableOverflow;
  final CarrotOverflowScrollDismissCallback onRequestDismiss;
  final VoidCallback onStateChanged;

  double availablePixels;
  bool hasScrolled;

  VoidCallback? _cancelActivity;

  CarrotOverflowScrollExtentState get state => _state.value;

  CarrotOverflowScrollExtent({
    required this.enableOverflow,
    required this.onRequestDismiss,
    required this.onStateChanged,
    bool? hasScrolled,
  })  : availablePixels = double.infinity,
        hasScrolled = hasScrolled ?? false,
        _state = ValueNotifier(const CarrotOverflowScrollExtentState.zero())..addListener(onStateChanged);

  void dispose() {
    _state.removeListener(onStateChanged);
  }

  void update({
    required double availablePixels,
    required double currentPixels,
  }) {
    _cancelActivity?.call();
    _cancelActivity = null;

    hasScrolled = true;

    if (!enableOverflow) {
      currentPixels = currentPixels.clamp(0, availablePixels);
    }

    _state.value = CarrotOverflowScrollExtentState(
      availablePixels: availablePixels.roundToDouble(),
      currentPixels: currentPixels.roundToDouble(),
    );
  }

  void addPixelDelta(double delta) => update(
        availablePixels: availablePixels,
        currentPixels: state.currentPixels + delta,
      );

  void setPixels(double pixels) => update(
        availablePixels: availablePixels,
        currentPixels: pixels,
      );
}

class CarrotOverflowScrollExtentState {
  final double availablePixels;
  final double currentPixels;

  bool get atEnd => currentPixels >= availablePixels;

  bool get atStart => currentPixels <= 0;

  double get overflowEnd => (atEnd ? currentPixels - availablePixels : 0);

  double get overflowStart => (atStart ? -currentPixels : 0);

  const CarrotOverflowScrollExtentState({
    required this.availablePixels,
    required this.currentPixels,
  });

  const CarrotOverflowScrollExtentState.zero()
      : availablePixels = 0,
        currentPixels = 0;
}

class CarrotOverflowScrollPosition extends ScrollPositionWithSingleContext {
  final CarrotOverflowScrollExtent extent;

  VoidCallback? _ballisticCancelCallback;
  VoidCallback? _dragCancelCallback;

  CarrotOverflowScrollPosition({
    required super.context,
    required super.physics,
    super.initialPixels = .0,
    super.keepScrollOffset = true,
    super.oldPosition,
    super.debugLabel,
    required this.extent,
  });

  @override
  void dispose() {
    _ballisticCancelCallback?.call();

    super.dispose();
  }

  @override
  void applyUserOffset(double delta) {
    extent.availablePixels = maxScrollExtent;

    if (!extent.enableOverflow) {
      extent.setPixels(pixels.clamp(0, maxScrollExtent));
      super.applyUserOffset(delta);
    } else if (extent.state.atStart && extent.state.atEnd) {
      extent.addPixelDelta(-delta);
    } else {
      if ((extent.state.atStart && delta > 0) || (extent.state.atEnd && delta < 0)) {
        extent.addPixelDelta(-delta);
      } else if (extent.state.overflowStart > 0 || extent.state.overflowEnd > 0) {
        extent.addPixelDelta(-delta);
      } else {
        extent.setPixels(pixels);
        super.applyUserOffset(delta);
      }
    }
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    _ballisticCancelCallback?.call();

    super.beginActivity(newActivity);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _dragCancelCallback = dragCancelCallback;

    return super.drag(details, dragCancelCallback);
  }

  @override
  void goBallistic(double velocity) {
    var state = extent.state;

    if (!extent.enableOverflow) {
      super.goBallistic(velocity);
      return;
    }

    _dragCancelCallback?.call();
    _dragCancelCallback = null;

    if (extent.state.atStart && velocity < -1600) {
      extent.onRequestDismiss(velocity);
      return;
    }

    if ((velocity == 0.0 && !extent.hasScrolled) || (velocity < 0 && !state.atStart) || (velocity > 0 && !state.atEnd)) {
      super.goBallistic(velocity);
      return;
    }

    final targetPixels = (state.atStart ? 0.0 : (state.atEnd ? state.availablePixels : state.currentPixels)).clamp(0.0, state.availablePixels);

    final simulation = SpringSimulation(
      const SpringDescription(
        damping: 5.0,
        mass: 5.0,
        stiffness: 18,
      ),
      state.currentPixels,
      targetPixels,
      velocity,
      tolerance: const Tolerance(distance: 50),
    );

    final AnimationController ballisticController = AnimationController.unbounded(
      vsync: context.vsync,
    );

    _ballisticCancelCallback = ballisticController.stop;

    ballisticController
      ..addListener(() {
        extent.setPixels(ballisticController.value);

        if ((velocity < 0 && state.atEnd) || (velocity > 0 && state.atStart)) {
          velocity = ballisticController.velocity + (physics.tolerance.velocity * ballisticController.velocity.sign);
          super.goBallistic(velocity);
          ballisticController.stop();
        } else if (ballisticController.isCompleted) {
          super.goBallistic(0);
        }
      })
      ..animateWith(simulation).whenCompleteOrCancel(() {
        _ballisticCancelCallback = null;
        ballisticController.dispose();
      });
  }
}

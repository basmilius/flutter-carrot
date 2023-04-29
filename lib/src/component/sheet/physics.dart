import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

mixin CarrotSheetPhysics on ScrollPhysics {
  bool shouldReload(covariant ScrollPhysics old) => false;
}

class CarrotSheetNeverDraggablePhysics extends NeverScrollableScrollPhysics with CarrotSheetPhysics {
  const CarrotSheetNeverDraggablePhysics({
    super.parent,
  });

  @override
  CarrotSheetNeverDraggablePhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetNeverDraggablePhysics(parent: buildParent(ancestor));
  }
}

class CarrotSheetAlwaysDraggablePhysics extends AlwaysScrollableScrollPhysics with CarrotSheetPhysics {
  const CarrotSheetAlwaysDraggablePhysics({
    super.parent,
  });

  @override
  CarrotSheetAlwaysDraggablePhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetAlwaysDraggablePhysics(parent: buildParent(ancestor));
  }
}

class CarrotSheetBouncingPhysics extends ScrollPhysics with CarrotSheetPhysics {
  final bool overflowViewport;

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  const CarrotSheetBouncingPhysics({
    super.parent,
    this.overflowViewport = false,
  });

  @override
  CarrotSheetBouncingPhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetBouncingPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldReload(covariant ScrollPhysics old) {
    return old is CarrotSheetBouncingPhysics && old.overflowViewport != overflowViewport;
  }

  double frictionFactor(double overscrollFraction) => .1 * math.pow(1 - overscrollFraction, 4);

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.',
          ),
          DiagnosticsProperty<ScrollPhysics>('The physics object in question was', this, style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<ScrollMetrics>('The position object in question was', position, style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());

    if (!overflowViewport) {
      // overscroll
      if (position.viewportDimension <= position.pixels && position.pixels < value) {
        return value - position.pixels;
      }

      // hit top edge
      if (value < position.viewportDimension && position.viewportDimension < position.pixels) {
        return value - position.viewportDimension;
      }
    }

    // underscroll
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }

    // hit top edge
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    return .0;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != .0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) {
      return offset;
    }

    final overscrollPastStart = math.max(position.minScrollExtent - position.pixels, .0);
    final overscrollPastEnd = math.max(position.pixels - position.maxScrollExtent, .0);
    final overscrollPast = math.max(overscrollPastStart, overscrollPastEnd);
    final easing = (overscrollPastStart > .0 && offset < .0) || (overscrollPastEnd > .0 && offset > .0);

    final friction = easing ? frictionFactor((overscrollPast - offset.abs()) / position.viewportDimension) : frictionFactor(overscrollPast / position.viewportDimension);
    final direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign * math.min(.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(), 40000);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);

    if (position.outOfRange) {
      return BouncingScrollSimulation(
        leadingExtent: position.minScrollExtent,
        position: position.pixels,
        spring: const SpringDescription(
          mass: 1.2,
          stiffness: 200.0,
          damping: 25,
        ),
        tolerance: tolerance,
        trailingExtent: position.maxScrollExtent,
        velocity: velocity,
      );
    }

    return super.createBallisticSimulation(position, velocity);
  }
}

class CarrotSheetClampingPhysics extends ScrollPhysics with CarrotSheetPhysics {
  const CarrotSheetClampingPhysics({
    super.parent,
  });

  @override
  CarrotSheetClampingPhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetClampingPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.',
          ),
          DiagnosticsProperty<ScrollPhysics>('The physics object in question was', this, style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<ScrollMetrics>('The position object in question was', position, style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());

    // hit top edge
    if (position.viewportDimension <= position.pixels && position.pixels < value) {
      return value - position.pixels;
    }

    // hit bottom edge
    if (position.pixels < 0 && position.pixels > value) {
      return value - position.pixels;
    }

    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);

    if (position.outOfRange) {
      double? end;

      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }

      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }

      assert(end != null);

      return ScrollSpringSimulation(
        spring,
        position.pixels,
        end!,
        math.min(0.0, velocity),
        tolerance: tolerance,
      );
    }

    if (velocity.abs() < tolerance.velocity) {
      return null;
    }

    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
      return null;
    }

    if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return null;
    }

    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      tolerance: tolerance,
    );
  }
}

class CarrotSheetNoMomentumPhysics extends ScrollPhysics with CarrotSheetPhysics {
  const CarrotSheetNoMomentumPhysics({
    super.parent,
  });

  @override
  CarrotSheetNoMomentumPhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetNoMomentumPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // underscroll
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }

    // overscroll
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) {
      return value - position.pixels;
    }

    // hit top edge
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }

    // hit bottom edge
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);

    if (position.outOfRange) {
      double? end;

      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      } else if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }

      assert(end != null);

      return ScrollSpringSimulation(
        spring,
        position.pixels,
        end!,
        math.min(0.0, velocity),
        tolerance: tolerance,
      );
    }

    return null;
  }
}

class CarrotSheetSnappingPhysics extends ScrollPhysics with CarrotSheetPhysics {
  final bool relative;
  final List<double> stops;

  @override
  bool get allowImplicitScrolling => false;

  const CarrotSheetSnappingPhysics({
    super.parent,
    this.relative = true,
    this.stops = const [],
  });

  @override
  CarrotSheetSnappingPhysics applyTo(ScrollPhysics? ancestor) {
    return CarrotSheetSnappingPhysics(
      parent: buildParent(ancestor),
      relative: relative,
      stops: stops,
    );
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);
    final target = _getTargetPixels(position, tolerance, velocity);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        const SpringDescription(
          damping: 25,
          stiffness: 150,
          mass: 1.2,
        ),
        position.pixels,
        target,
        velocity, //.clamp(-200, 200),
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool shouldReload(covariant ScrollPhysics old) {
    return old is CarrotSheetSnappingPhysics && (old.relative != relative || !listEquals(old.stops, stops));
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    int page = _getPage(position) ?? 0;

    final targetPixels = getPixelsFromPage(position, page.clamp(0, stops.length - 1));

    if (targetPixels > position.pixels && velocity < -tolerance.velocity) {
      --page;
    } else if (targetPixels < position.pixels && velocity > tolerance.velocity) {
      ++page;
    }

    return getPixelsFromPage(position, page.clamp(0, stops.length - 1));
  }

  double extentFor(ScrollMetrics position) {
    if (relative) {
      return position.maxScrollExtent;
    }

    return 1;
  }

  int getPageFromPixels(double pixels, double extent) {
    final actual = math.max(.0, pixels) / math.max(1.0, extent);
    return _nearestStopForExtent(actual);
  }

  double getPixelsFromPage(ScrollMetrics position, int page) {
    if (stops[page].isInfinite) {
      return position.maxScrollExtent;
    }

    return stops[page] * extentFor(position);
  }

  int? _getPage(ScrollMetrics position) {
    assert(!position.hasPixels || position.hasContentDimensions, 'Page value is only available after content dimensions are calculated.');

    return !position.hasPixels
        ? null
        : getPageFromPixels(
            position.pixels.clamp(position.minScrollExtent, position.maxScrollExtent),
            extentFor(position),
          );
  }

  int _nearestStopForExtent(double extent) {
    if (stops.isEmpty) {
      return 0;
    }

    final stop = stops.asMap().entries.reduce(
          (prev, curr) => (curr.value - extent).abs() < (prev.value - extent).abs() ? curr : prev,
        );

    return stop.key;
  }
}

double _applyFriction(
  double extentOutside,
  double absDelta,
  double gamma,
) {
  assert(absDelta > .0);

  double total = .0;

  if (extentOutside > .0) {
    final deltaToLimit = extentOutside / gamma;

    if (absDelta < deltaToLimit) {
      return absDelta * gamma;
    }

    total += extentOutside;
    absDelta -= deltaToLimit;
  }

  return total + absDelta;
}

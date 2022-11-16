import "package:flutter/animation.dart";
import "package:flutter/physics.dart";

/// [Curve] that uses a [SpringSimulation] for the transform. More
/// information about the constructor parameters can be found in
/// the [SpringDescription] class.
class CarrotSpring extends Curve {
  final SpringSimulation _springSimulation;

  /// Creates a spring curve with the given [mass], [stiffness] and
  /// the [damping] coefficient.
  CarrotSpring({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) : _springSimulation = SpringSimulation(
          SpringDescription(
            damping: damping,
            mass: mass,
            stiffness: stiffness,
          ),
          0.0,
          1.0,
          velocity,
        );

  /// Returns the value of the curve at point [t].
  ///
  /// This function muse ensure the following:
  /// - The value of [t] must be between 0.0 and 1.0.
  @override
  double transform(double t) => _springSimulation.x(t) + t * (1 - _springSimulation.x(1.0));
}

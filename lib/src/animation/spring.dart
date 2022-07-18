import "package:flutter/animation.dart";
import "package:flutter/physics.dart";

class CarrotSpring extends Curve {
  final SpringSimulation _springSimulation;

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

  @override
  double transform(double t) => _springSimulation.x(t) + t * (1 - _springSimulation.x(1.0));
}

import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotDisabled extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final double? opacity;
  final Curve? opacityCurve;
  final Duration? opacityDuration;

  const CarrotDisabled({
    super.key,
    required this.child,
    required this.disabled,
  })  : opacity = null,
        opacityCurve = null,
        opacityDuration = null;

  const CarrotDisabled.opacity({
    super.key,
    required this.child,
    required this.disabled,
    double this.opacity = .3,
    Curve this.opacityCurve = CarrotCurves.swiftOutCurve,
    Duration this.opacityDuration = const Duration(milliseconds: 210),
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (opacity != null) {
      content = AnimatedOpacity(
        curve: opacityCurve!,
        duration: opacityDuration!,
        opacity: disabled ? opacity! : 1,
        child: child,
      );
    }

    return ExcludeFocus(
      excluding: disabled,
      child: ExcludeSemantics(
        excluding: disabled,
        child: IgnorePointer(
          ignoring: disabled,
          child: content,
        ),
      ),
    );
  }
}

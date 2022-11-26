import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import 'carrot_theme.dart';

const _kDefaultCurve = CarrotCurves.swiftOutCurve;
const _kDefaultDuration = Duration(milliseconds: 840);

class CarrotAnimatedTheme extends ImplicitlyAnimatedWidget {
  final Widget child;
  final CarrotThemeData data;

  const CarrotAnimatedTheme({
    super.key,
    required this.child,
    required this.data,
    super.curve = _kDefaultCurve,
    super.duration = _kDefaultDuration,
    super.onEnd,
  });

  @override
  createState() => _CarrotAnimatedThemeState();
}

class _CarrotAnimatedThemeState extends AnimatedWidgetBaseState<CarrotAnimatedTheme> {
  CarrotThemeDataTween? _data;

  @override
  Widget build(BuildContext context) {
    return CarrotTheme(
      data: _data!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (value) => CarrotThemeDataTween(begin: value)) as CarrotThemeDataTween;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<CarrotThemeDataTween>('data', _data, showName: false, defaultValue: null));
  }
}

class CarrotThemeDataTween extends Tween<CarrotThemeData> {
  CarrotThemeDataTween({
    super.begin,
    super.end,
  });

  @override
  CarrotThemeData lerp(double t) => CarrotThemeData.lerp(begin!, end!, t);
}

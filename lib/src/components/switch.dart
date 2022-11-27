import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../theme/theme.dart';

typedef CarrotSwitchChangedCallback = void Function(bool);

const _kCurve = CarrotCurves.swiftOutCurve;
const _kDuration = Duration(milliseconds: 210);

class CarrotSwitch extends StatefulWidget {
  final bool value;
  final CarrotSwitchChangedCallback onChanged;

  const CarrotSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  createState() => _CarrotSwitchState();
}

class _CarrotSwitchState extends State<CarrotSwitch> {
  bool _isPressed = false;

  bool get _isActive => widget.value;

  double get _toggleSize {
    final switchTheme = CarrotSwitchTheme.of(context);
    final lowestSize = math.min(switchTheme.size.height, switchTheme.size.width);
    return lowestSize - switchTheme.toggleMargin * 2;
  }

  double get _toggleX {
    final switchTheme = CarrotSwitchTheme.of(context);

    if (_isActive) {
      return switchTheme.size.width - switchTheme.toggleMargin * 2 - _toggleSize;
    }

    return 0;
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isPressed) {
      return;
    }

    final switchTheme = CarrotSwitchTheme.of(context);

    setState(() {
      widget.onChanged(details.localPosition.dx >= switchTheme.size.width / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final switchTheme = CarrotSwitchTheme.of(context);

    return GestureDetector(
      onPanEnd: _onPanEnd,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onTap: () => widget.onChanged(!widget.value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        curve: _kCurve,
        duration: _kDuration,
        decoration: BoxDecoration(
          borderRadius: switchTheme.borderRadius,
          color: widget.value ? switchTheme.backgroundColorActive : switchTheme.backgroundColor,
        ),
        child: SizedBox.fromSize(
          size: switchTheme.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                curve: _kCurve,
                duration: _kDuration,
                top: switchTheme.toggleMargin,
                left: switchTheme.toggleMargin + _toggleX,
                height: _toggleSize,
                width: _toggleSize,
                child: _Toggle(
                  isActive: widget.value,
                  isPressed: _isPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool isActive;
  final bool isPressed;

  const _Toggle({
    required this.isActive,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    final switchTheme = CarrotSwitchTheme.of(context);

    return AnimatedContainer(
      curve: _kCurve,
      duration: _kDuration,
      decoration: BoxDecoration(
        borderRadius: switchTheme.toggleBorderRadius,
        boxShadow: isPressed ? switchTheme.toggleShadowPressed : switchTheme.toggleShadow,
        color: isActive ? switchTheme.toggleColorActive : switchTheme.toggleColor,
      ),
    );
  }
}

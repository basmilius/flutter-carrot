import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import '../ui/ui.dart';

typedef CarrotSwitchChangedCallback = void Function(bool);

const _kCurve = CarrotCurves.swiftOutCurve;
const _kDuration = Duration(milliseconds: 210);

class CarrotSwitch extends StatefulWidget {
  final CarrotColor? color;
  final bool value;
  final CarrotSwitchChangedCallback onChanged;

  const CarrotSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.color,
  });

  @override
  createState() => _CarrotSwitchState();
}

class _CarrotSwitchState extends State<CarrotSwitch> {
  bool _isPressed = false;
  double _x = 0;

  @override
  void didUpdateWidget(CarrotSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _x = widget.value ? 21 : 3;
    });
  }

  @override
  void initState() {
    super.initState();

    _x = widget.value ? 21 : 3;
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

    setState(() {
      _x = details.localPosition.dx >= 24 ? 21 : 3;
      widget.onChanged(_x == 21);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.circular(15),
          color: widget.value ? (widget.color ?? context.carrotTheme.primary) : context.carrotTheme.gray[100],
        ),
        child: SizedBox(
            height: 30,
            width: 48,
            child: Stack(
              children: [
                AnimatedPositioned(
                  curve: _kCurve,
                  duration: _kDuration,
                  top: 3,
                  left: _x,
                  child: _Toggle(
                    isPressed: _isPressed,
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool isPressed;

  const _Toggle({
    required this.isPressed,
});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: _kCurve,
      duration: _kDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: isPressed ? CarrotShadows.large : CarrotShadows.small,
        color: context.carrotTheme.gray[0],
      ),
      height: 24,
      width: 24,
    );
  }
}

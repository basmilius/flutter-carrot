import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bounce_tap.dart';

class CarrotRepeatingBounceTap extends StatefulWidget {
  final Widget child;
  final bool disabled;
  final GestureTapCallback onTap;

  const CarrotRepeatingBounceTap({
    super.key,
    required this.child,
    required this.disabled,
    required this.onTap,
  });

  @override
  createState() => _CarrotRepeatingBounceTapState();
}

class _CarrotRepeatingBounceTapState extends State<CarrotRepeatingBounceTap> {
  Timer? _timer;

  void _onTapCancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTapDown(TapDownDetails details) {
    _timer = Timer(const Duration(milliseconds: 300), _setupRepeatingTimer);
  }

  void _onTapUp(TapUpDetails details) {
    _onTapCancel();
  }

  void _onTick(Timer _) {
    if (widget.disabled) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    HapticFeedback.selectionClick();
    widget.onTap();
  }

  void _setupRepeatingTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 90), _onTick);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disabled,
      child: GestureDetector(
        onTapCancel: _onTapCancel,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        child: CarrotBounceTap(
          scale: .9,
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}

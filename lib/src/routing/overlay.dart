import 'package:flutter/widgets.dart';

import '../component/overlay.dart';

const _kAnimationDuration = Duration(milliseconds: 540);

class CarrotOverlayRoute<T> extends PageRoute<T> {
  final CarrotOverlayBaseBuilder<T> builder;
  final T? defaultValue;
  final bool dismissible;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get reverseTransitionDuration => _kAnimationDuration;

  @override
  Duration get transitionDuration => _kAnimationDuration;

  CarrotOverlayRoute({
    required this.builder,
    required this.defaultValue,
    this.dismissible = false,
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return CarrotOverlayBase<T>(
      animation: animation,
      builder: builder,
      close: _onClose,
      defaultValue: defaultValue,
      dismissible: dismissible,
    );
  }

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    return false;
  }

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    return false;
  }

  void _onClose([T? value]) {
    assert(navigator != null);

    navigator!.pop<T>(value);
  }
}

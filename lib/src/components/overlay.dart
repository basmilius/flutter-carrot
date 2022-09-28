import 'dart:async';

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';

import 'primitive/primitive.dart';
import 'dynamic_viewport_safe_area.dart';

const _kAnimationDuration = Duration(milliseconds: 540);

typedef CarrotOverlayBaseClose<T> = void Function([T?]);
typedef CarrotOverlayBaseBuilder<T> = Widget Function(CarrotOverlayBaseClose<T> close);

enum CarrotOverlayBaseAnimationState {
  forward,
  reverse,
}

typedef CarrotOverlayBuilder<T> = Widget Function(CarrotOverlayBag<T>);

class CarrotOverlay<T> extends StatefulWidget {
  final CarrotOverlayBuilder<T> builder;
  final Completer<T?> completer;
  final T? defaultValue;
  final bool dismissible;
  final OverlayEntry overlayEntry;

  const CarrotOverlay({
    super.key,
    required this.builder,
    required this.completer,
    required this.overlayEntry,
    this.defaultValue,
    this.dismissible = false,
  });

  @override
  createState() => _CarrotOverlay<T>();

  static OverlayEntry entry<T>({
    Key? key,
    required CarrotOverlayBuilder<T> builder,
    required Completer<T?> completer,
    T? defaultValue,
    bool dismissible = false,
    bool maintainState = false,
    bool opaque = false,
  }) {
    OverlayEntry? entry;

    entry = OverlayEntry(
      maintainState: maintainState,
      opaque: opaque,
      builder: (context) => CarrotOverlay<T>(
        key: key,
        builder: builder,
        completer: completer,
        defaultValue: defaultValue,
        dismissible: dismissible,
        overlayEntry: entry!,
      ),
    );

    return entry;
  }
}

class _CarrotOverlay<T> extends State<CarrotOverlay<T>> with SingleTickerProviderStateMixin {
  final GlobalKey contentKey = GlobalKey(debugLabel: "carrot/overlay:content");

  late AnimationController _animationController;
  late ScrollController _scrollController;

  bool _isClosing = false;
  bool _isOpening = false;

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: _kAnimationDuration, vsync: this)
      ..addStatusListener(_handleAnimationStatusChange);

    _scrollController = ScrollController();

    open();
  }

  void close([T? result]) {
    if (_isClosing) {
      return;
    }

    _isClosing = true;

    /// note(Bas): do we want to pass the result before the animation ends?
    widget.completer.complete(result);

    _animationController
      ..value = 1
      ..animateTo(0, duration: _kAnimationDuration);
  }

  void open() {
    if (_isOpening) {
      return;
    }

    _isOpening = true;

    _animationController
      ..value = 0
      ..animateTo(1, duration: _kAnimationDuration);
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }

    if (_isClosing) {
      widget.overlayEntry.remove();
    }

    _isClosing = false;
    _isOpening = false;
  }

  @override
  Widget build(BuildContext context) {
    return CarrotOverlayBase<T>(
      animation: _animationController,
      close: close,
      defaultValue: widget.defaultValue,
      dismissible: widget.dismissible,
      builder: (close) => Builder(
        key: contentKey,
        builder: (context) => widget.builder(CarrotOverlayBag(
          close: close,
          completer: widget.completer,
          scrollController: _scrollController,
        )),
      ),
    );
  }
}

class CarrotOverlayBag<T> {
  final CarrotOverlayBaseClose<T> close;
  final Completer<T?> completer;
  final ScrollController scrollController;

  const CarrotOverlayBag({
    required this.close,
    required this.completer,
    required this.scrollController,
  });
}

class CarrotOverlayBase<T> extends StatefulWidget {
  final Animation<double> animation;
  final CarrotOverlayBaseBuilder<T> builder;
  final CarrotOverlayBaseClose<T> close;
  final T? defaultValue;
  final bool dismissible;

  const CarrotOverlayBase({
    super.key,
    required this.animation,
    required this.builder,
    required this.close,
    required this.defaultValue,
    this.dismissible = false,
  });

  @override
  createState() => _CarrotOverlayBase<T>();
}

class _CarrotOverlayBase<T> extends State<CarrotOverlayBase> with SingleTickerProviderStateMixin {
  final GlobalKey contentKey = GlobalKey(debugLabel: "carrot/overlay:base");

  @override
  CarrotOverlayBase<T> get widget => super.widget as CarrotOverlayBase<T>;

  late Animation<double> _animationBoxOpacity;
  late Animation<double> _animationBoxScale;
  late Animation<double> _animationScrimOpacity;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _initAnimations();
  }

  void _close([T? value]) {
    if (_isClosing || widget.animation.status != AnimationStatus.completed) {
      return;
    }

    _isClosing = true;

    _animationBoxOpacity = CarrotCurveTween<double>(
      begin: 1,
      end: 0,
      curve: CarrotCurves.swiftOutCurve.flipped.withInterval(end: .5),
    ).animate(ReverseAnimation(widget.animation));

    _animationBoxScale = CarrotCurveTween<double>(
      begin: 1,
      end: .9,
      curve: CarrotCurves.swiftOutCurve.flipped.withInterval(end: .5),
    ).animate(ReverseAnimation(widget.animation));

    _animationScrimOpacity = CarrotCurveTween<double>(
      begin: 1,
      end: 0,
      curve: CarrotCurves.swiftOutCurve,
    ).animate(ReverseAnimation(widget.animation));

    widget.close(value);
  }

  void _initAnimations() {
    _animationBoxOpacity = CarrotCurveTween<double>(
      begin: 0,
      end: 1,
      curve: CarrotCurves.springOverDamped.withInterval(begin: .2),
    ).animate(widget.animation);

    _animationBoxScale = CarrotCurveTween<double>(
      begin: 1.2,
      end: 1,
      curve: CarrotCurves.springOverDamped.withInterval(begin: .2),
    ).animate(widget.animation);

    _animationScrimOpacity = CarrotCurveTween<double>(
      begin: 0,
      end: 1,
      curve: CarrotCurves.swiftOutCurve.withInterval(end: .8),
    ).animate(widget.animation);
  }

  void _onScrimTap() {
    if (!widget.dismissible) {
      return;
    }

    _close(widget.defaultValue);
  }

  @override
  Widget build(BuildContext context) {
    return CarrotDynamicViewportSafeArea(
      child: RepaintBoundary(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _animationScrimOpacity,
              child: CarrotScrim(
                color: context.carrotTheme.scrimColor,
                onTap: _onScrimTap,
              ),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation: widget.animation,
                child: Padding(
                  padding: const EdgeInsets.all(27),
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: Builder(
                      key: contentKey,
                      builder: (_) => widget.builder(_close),
                    ),
                  ),
                ),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animationBoxOpacity,
                    child: Transform.scale(
                      scale: _animationBoxScale.value,
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

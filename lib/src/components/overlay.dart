import 'dart:async';

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';

import 'primitive/primitive.dart';
import 'scroll/scroll.dart';

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
  late Animation<double> _animationBoxTranslate;
  late CarrotOverflowScrollController _scrollController;

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
      ..addListener(_handleAnimationChange)
      ..addStatusListener(_handleAnimationStatusChange);

    _scrollController = CarrotOverflowScrollController(
      enableOverflow: widget.dismissible,
      onRequestDismiss: _handleDismiss,
      onStateChanged: () => setState(() {}),
    );

    open();
  }

  void close([T? result, bool withTranslate = false]) {
    if (_isClosing) {
      return;
    }

    _isClosing = true;

    /// note(Bas): do we want to pass the result before the animation ends?
    widget.completer.complete(result);

    if (withTranslate) {
      _animationBoxTranslate = _animationController.curveTween(
        begin: 2,
        end: 0,
        curve: CarrotCurves.springOverDamped.flipped,
      );
    } else {
      _animationBoxTranslate = _animationController.curveTween(
        begin: 0,
        end: 0,
        curve: CarrotCurves.springOverDamped.flipped,
      );
    }

    _animationController
      ..value = 1
      ..animateTo(0, duration: _kAnimationDuration);
  }

  void open() {
    if (_isOpening) {
      return;
    }

    _isOpening = true;

    setState(() {
      _animationBoxTranslate = _animationController.curveTween(
        begin: 0,
        end: 0,
        curve: CarrotCurves.springOverDamped,
      );

      _animationController
        ..value = 0
        ..animateTo(1, duration: _kAnimationDuration);
    });
  }

  void _handleAnimationChange() {}

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

  void _handleDismiss(double velocity) {
    close(null, true);
  }

  @override
  Widget build(BuildContext context) {
    double y = 0;

    final scrollState = _scrollController.state;

    if (scrollState.atStart) {
      y = scrollState.overflowStart;
    } else if (scrollState.atEnd) {
      y = -scrollState.overflowEnd;
    }

    return CarrotOverlayBase<T>(
      animation: _animationController,
      close: close,
      defaultValue: widget.defaultValue,
      dismissible: widget.dismissible,
      builder: (close) => AnimatedBuilder(
        animation: _animationController,
        child: widget.builder(CarrotOverlayBag(
          close: close,
          completer: widget.completer,
          scrollController: _scrollController,
        )),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, y),
            child: Transform.translate(
              offset: Offset(0, _animationBoxTranslate.value * scrollState.availablePixels),
              child: child,
            ),
          );
        },
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
    return RepaintBoundary(
      child: Stack(
        children: [
          FadeTransition(
            opacity: _animationScrimOpacity,
            child: CarrotScrim(
              color: context.carrotTheme.scrimColor,
              onTap: _onScrimTap,
            ),
          ),
          AnimatedBuilder(
            animation: widget.animation,
            child: Padding(
              padding: const EdgeInsets.all(27),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: widget.builder(_close),
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
        ],
      ),
    );
  }
}

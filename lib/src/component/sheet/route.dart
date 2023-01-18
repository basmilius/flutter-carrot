import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import '../../extension/extension.dart';
import '../../routing/routing.dart';
import 'controller.dart';
import 'fit.dart';
import 'physics.dart';
import 'widget.dart';

const _kBottomOffset = -15;
const _kButtonScale = .075;
const _kTransitionDuration = Duration(milliseconds: 420);
const _kWillPopThreshold = .8;

class CarrotSheetRoute<T> extends PageRoute<T> with CarrotDelegatedTransitionsRoute<T> {
  AnimationController? _routeAnimationController;
  late final CarrotSheetController _sheetController;

  final Curve? animationCurve;
  final WidgetBuilder builder;
  final bool draggable;
  final CarrotSheetFit fit;
  final double initialExtent;
  final String? label;
  final CarrotSheetPhysics? physics;
  final List<double>? stops;
  final double willPopThreshold;

  @override
  final Color? barrierColor;

  @override
  final bool barrierDismissible;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  CarrotSheetController get sheetController => _sheetController;

  @override
  bool get opaque => false;

  CarrotSheetRoute({
    super.settings,
    required this.builder,
    this.animationCurve,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.draggable = true,
    this.fit = CarrotSheetFit.expand,
    this.initialExtent = 1,
    this.maintainState = true,
    this.label,
    this.physics,
    this.stops,
    this.transitionDuration = _kTransitionDuration,
    this.willPopThreshold = _kWillPopThreshold,
  }) : super(
          fullscreenDialog: true,
        );

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  void install() {
    _sheetController = createSheetController();
    super.install();
  }

  @override
  AnimationController createAnimationController() {
    assert(_routeAnimationController == null);

    _routeAnimationController = AnimationController(
      duration: transitionDuration,
      vsync: navigator!,
    );

    return _routeAnimationController!;
  }

  CarrotSheetController createSheetController() {
    return CarrotSheetController();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _CarrotSheetRouteContainer(
      route: this,
    );
  }

  @override
  Widget buildSecondaryTransitionForPreviousRoute(BuildContext context, Animation<double> secondaryAnimation, Widget child) {
    final effectiveAnimation = CurvedAnimation(
      curve: const Interval(.5, 1, curve: CarrotCurves.easeInOut),
      parent: secondaryAnimation,
    );

    return AnimatedBuilder(
      animation: effectiveAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, effectiveAnimation.value * _kBottomOffset),
        child: Transform.scale(
          alignment: Alignment.topCenter,
          scale: 1 - effectiveAnimation.value * _kButtonScale,
          child: child,
        ),
      ),
      child: child,
    );
  }

  Widget buildSheet(BuildContext context, Widget child) {
    CarrotSheetPhysics effectivePhysics = CarrotSheetSnappingPhysics(
      parent: physics,
      stops: stops ?? const [0, 1],
    );

    if (!draggable) {
      effectivePhysics = const CarrotSheetNeverDraggablePhysics();
    }

    return CarrotSheet(
      controller: sheetController,
      fit: fit,
      initialExtent: initialExtent,
      physics: effectivePhysics,
      child: child,
    );
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) => previousRoute is CarrotSheetRoute;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) => nextRoute is CarrotSheetRoute;

  @override
  bool canDriveSecondaryTransitionForPreviousRoute(Route<dynamic> previousRoute) => true;

  @protected
  bool shouldPreventPopForExtent(double extent) {
    return extent < willPopThreshold && hasScopedWillPopCallback && controller!.velocity <= 0;
  }
}

class _CarrotSheetRouteContainer extends StatefulWidget {
  final CarrotSheetRoute<dynamic> route;

  const _CarrotSheetRouteContainer({
    required this.route,
  });

  @override
  createState() => _CarrotSheetRouteContainerState();
}

class _CarrotSheetRouteContainerState extends State<_CarrotSheetRouteContainer> with TickerProviderStateMixin {
  bool _isFirstAnimation = true;

  CarrotSheetRoute<dynamic> get route => widget.route;

  AnimationController get _animationController => widget.route._routeAnimationController!;

  CarrotSheetController get _sheetController => widget.route._sheetController;

  @override
  void dispose() {
    _animationController.removeListener(_onRouteAnimationUpdate);
    _sheetController.removeListener(_onSheetExtentUpdate);
    super.dispose();
  }

  @override
  void initState() {
    _animationController.addListener(_onRouteAnimationUpdate);
    _sheetController.addListener(_onSheetExtentUpdate);

    onMounted(() {
      _sheetController.relativeAnimateTo(
        route.initialExtent,
        curve: route.animationCurve ?? CarrotCurves.swiftOutCurve,
        duration: route.transitionDuration,
      );
    });

    super.initState();
  }

  void _onRouteAnimationUpdate() {
    if (_animationController.isCompleted) {
      _isFirstAnimation = false;
    }

    if (!_animationController.isAnimating) {
      return;
    }

    if (_isFirstAnimation || _animationController.value == _sheetController.animation.value) {
      return;
    }

    if (_animationController.status == AnimationStatus.forward) {
      _sheetController.relativeJumpTo(
        _animationController.value._mapDistance(
          fromLow: 0,
          fromHigh: 1,
          toLow: _sheetController.animation.value,
          toHigh: 1,
        ),
      );
    } else {
      _sheetController.relativeJumpTo(
        _animationController.value._mapDistance(
          fromLow: 0,
          fromHigh: 1,
          toLow: 0,
          toHigh: _sheetController.animation.value,
        ),
      );
    }
  }

  void _onSheetExtentUpdate() {
    if (_animationController.value == _sheetController.animation.value) {
      return;
    }

    if (route.isCurrent && _sheetController.position.preventingDrag && route.shouldPreventPopForExtent(_sheetController.animation.value)) {
      preventPop();
      return;
    }

    if (!_animationController.isAnimating) {
      _animationController.value = _sheetController.animation.value._mapDistance(
        fromLow: 0,
        fromHigh: route.initialExtent,
        toLow: 0,
        toHigh: 1,
      );

      if (_sheetController.animation.value == 0) {
        route.navigator?.pop();
      }
    }
  }

  @protected
  void preventPop() async {
    _sheetController.position.enablePreventDrag();
    _sheetController.relativeAnimateTo(
      1,
      curve: CarrotCurves.swiftOutCurve,
      duration: _kTransitionDuration,
    );

    final disposition = await route.willPop();

    if (disposition == RoutePopDisposition.pop) {
      _sheetController.relativeAnimateTo(
        0,
        curve: CarrotCurves.swiftOutCurve,
        duration: _kTransitionDuration,
      );
    } else {
      _sheetController.position.disablePreventDrag();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      label: route.label,
      namesRoute: true,
      scopesRoute: true,
      child: route.buildSheet(
        context,
        Builder(
          builder: route.builder,
        ),
      ),
    );
  }
}

extension on double {
  double _mapDistance({
    required double fromLow,
    required double fromHigh,
    required double toLow,
    required double toHigh,
  }) {
    final offset = toLow;
    final ratio = (toHigh - toLow) / (fromHigh - fromLow);

    return ratio * (this - fromLow) + offset;
  }
}

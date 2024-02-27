import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import 'behavior.dart';
import 'context.dart';
import 'controller.dart';
import 'minimum_interaction_zone.dart';
import 'physics.dart';
import 'position.dart';

class CarrotSheetScrollable extends StatefulWidget {
  final AxisDirection axisDirection;
  final CarrotSheetController? controller;
  final DragStartBehavior dragStartBehavior;
  final bool excludeFromSemantics;
  final double? initialExtent;
  final double minInteractionExtent;
  final ScrollPhysics? physics;
  final String? restorationId;
  final int? semanticChildCount;
  final CarrotSheetBehavior? scrollBehavior;
  final ViewportBuilder viewportBuilder;

  Axis get axis => axisDirectionToAxis(axisDirection);

  const CarrotSheetScrollable({
    super.key,
    required this.viewportBuilder,
    this.axisDirection = AxisDirection.down,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.excludeFromSemantics = false,
    this.initialExtent,
    this.minInteractionExtent = 0,
    this.physics,
    this.restorationId,
    this.semanticChildCount,
    this.scrollBehavior,
  }) : assert(semanticChildCount == null || semanticChildCount >= 0);

  @override
  createState() => _CarrotSheetScrollableState();

  static CarrotSheetScrollableState? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<_CarrotSheetScrollableScope>();
    return widget?.scrollable;
  }

  static Future<void> ensureVisible(
    BuildContext context, {
    double alignment = .0,
    ScrollPositionAlignmentPolicy alignmentPolicy = ScrollPositionAlignmentPolicy.explicit,
    Curve curve = CarrotCurves.swiftOutCurve,
    Duration duration = Duration.zero,
  }) {
    final futures = <Future<void>>[];

    RenderObject? targetRenderObject;
    CarrotSheetScrollableState? scrollable = CarrotSheetScrollable.of(context);

    while (scrollable != null) {
      futures.add(scrollable.position.ensureVisible(
        context.findRenderObject()!,
        alignment: alignment,
        alignmentPolicy: alignmentPolicy,
        curve: curve,
        duration: duration,
        targetRenderObject: targetRenderObject,
      ));

      targetRenderObject = targetRenderObject ?? context.findRenderObject();
      context = scrollable.context;
      scrollable = CarrotSheetScrollable.of(context);
    }

    if (futures.isEmpty || duration == Duration.zero) {
      return Future<void>.value();
    }

    if (futures.length == 1) {
      return futures.single;
    }

    return Future.wait<void>(futures).then<void>((List<void> _) => null);
  }
}

abstract class CarrotSheetScrollableState {
  BuildContext get context;

  CarrotSheetController get controller;

  AxisDirection get axisDirection;

  double? get initialExtent;

  BuildContext? get notificationContext;

  CarrotSheetPosition get position;

  String? get restorationId;

  BuildContext get storageContext;

  TickerProvider get vsync;
}

class _CarrotSheetScrollableState extends State<CarrotSheetScrollable> with RestorationMixin, TickerProviderStateMixin implements CarrotSheetScrollContext, CarrotSheetScrollableState {
  final GlobalKey<RawGestureDetectorState> _gestureDetectorKey = GlobalKey();
  final GlobalKey _ignorePointerKey = GlobalKey();
  final GlobalKey _scrollSemanticsKey = GlobalKey();

  final _CarrotSheetRestorableScrollOffset _persistedScrollOffset = _CarrotSheetRestorableScrollOffset();
  late CarrotSheetBehavior _configuration;
  CarrotSheetController? _fallbackScrollController;
  ScrollPhysics? _physics;
  CarrotSheetPosition? _position;

  Drag? _drag;
  Map<Type, GestureRecognizerFactory> _gestureRecognizers = const {};
  ScrollHoldController? _hold;
  bool _shouldIgnorePointer = false;
  bool? _lastCanDrag;
  Axis? _lastAxisDirection;

  CarrotSheetController get _effectiveScrollController => widget.controller ?? _fallbackScrollController!;

  @override
  CarrotSheetController get controller => _effectiveScrollController;

  @override
  AxisDirection get axisDirection => widget.axisDirection;

  @override
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(context);

  @override
  double? get initialExtent => widget.initialExtent;

  @override
  BuildContext? get notificationContext => _gestureDetectorKey.currentContext;

  @override
  CarrotSheetPosition get position => _position!;

  @override
  String? get restorationId => widget.restorationId;

  @override
  BuildContext get storageContext => context;

  @override
  TickerProvider get vsync => this;

  @override
  void didChangeDependencies() {
    _updatePosition();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CarrotSheetScrollable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        assert(_fallbackScrollController != null);
        assert(widget.controller != null);

        _fallbackScrollController!.detach(position);
        _fallbackScrollController!.dispose();
        _fallbackScrollController = null;
      } else {
        oldWidget.controller?.detach(position);

        if (widget.controller == null) {
          _fallbackScrollController = CarrotSheetController();
        }
      }

      _effectiveScrollController.attach(position);
    }

    if (_shouldUpdatePosition(oldWidget)) {
      _updatePosition();
    }
  }

  @override
  void dispose() {
    widget.controller?.detach(position);
    _fallbackScrollController?.detach(position);
    _fallbackScrollController?.dispose();

    position.dispose();
    _persistedScrollOffset.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.controller == null) {
      _fallbackScrollController = CarrotSheetController();
    }

    super.initState();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_persistedScrollOffset, 'offset');

    assert(_position != null);

    if (_persistedScrollOffset.value != null) {
      position.restoreOffset(
        _persistedScrollOffset.value!,
        initialRestore: initialRestore,
      );
    }
  }

  @override
  void saveOffset(double offset) {
    assert(debugIsSerializableForRestoration(offset));

    _persistedScrollOffset.value = offset;
    ServicesBinding.instance.restorationManager.flushData();
  }

  bool _shouldPhysicsUpdate(ScrollPhysics? newPhysics, ScrollPhysics? oldPhysics) {
    if (newPhysics is! CarrotSheetPhysics || oldPhysics is! CarrotSheetPhysics) {
      return false;
    }

    return newPhysics.shouldReload(oldPhysics);
  }

  bool _shouldUpdatePosition(CarrotSheetScrollable oldWidget) {
    ScrollPhysics? newPhysics = widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context);
    ScrollPhysics? oldPhysics = oldWidget.physics ?? oldWidget.scrollBehavior?.getScrollPhysics(context);

    do {
      if (newPhysics?.runtimeType != oldPhysics.runtimeType || _shouldPhysicsUpdate(newPhysics, oldPhysics)) {
        return true;
      }

      newPhysics = newPhysics?.parent;
      oldPhysics = oldPhysics?.parent;
    } while (newPhysics != null || oldPhysics != null);

    return widget.controller?.runtimeType != oldWidget.controller?.runtimeType;
  }

  void _updatePosition() {
    _configuration = widget.scrollBehavior ?? CarrotSheetBehavior();
    _physics = _configuration.getScrollPhysics(context);

    if (widget.physics != null) {
      _physics = widget.physics!.applyTo(_physics);
    } else if (widget.scrollBehavior != null) {
      _physics = widget.scrollBehavior!.getScrollPhysics(context).applyTo(_physics);
    }

    final oldPosition = _position;
    if (oldPosition != null) {
      _effectiveScrollController.detach(oldPosition);
      scheduleMicrotask(oldPosition.dispose);
    }

    _position = _effectiveScrollController.createScrollPosition(
      _physics!,
      this,
      oldPosition,
    );

    assert(_position != null);

    _effectiveScrollController.attach(position);
  }

  @override
  @protected
  void setSemanticsActions(Set<SemanticsAction> actions) {
    if (_gestureDetectorKey.currentState != null) {
      _gestureDetectorKey.currentState!.replaceSemanticsActions(actions);
    }
  }

  @override
  @protected
  void setCanDrag(bool canDrag) {
    if (canDrag == _lastCanDrag && (!canDrag || widget.axis == _lastAxisDirection)) {
      return;
    }

    if (!canDrag) {
      _gestureRecognizers = const {};
      _handleDragCancel();
    } else {
      switch (widget.axis) {
        case Axis.horizontal:
          _gestureRecognizers = {
            HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
              (instance) {
                instance
                  ..onCancel = _handleDragCancel
                  ..onDown = _handleDragDown
                  ..onEnd = _handleDragEnd
                  ..onStart = _handleDragStart
                  ..onUpdate = _handleDragUpdate
                  ..minFlingDistance = _physics?.minFlingDistance
                  ..maxFlingVelocity = _physics?.maxFlingVelocity
                  ..minFlingVelocity = _physics?.minFlingVelocity
                  ..velocityTrackerBuilder = _configuration.velocityTrackerBuilder(context)
                  ..dragStartBehavior = widget.dragStartBehavior;
              },
            ),
          };
          break;

        case Axis.vertical:
          _gestureRecognizers = {
            VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (instance) {
                instance
                  ..onCancel = _handleDragCancel
                  ..onDown = _handleDragDown
                  ..onEnd = _handleDragEnd
                  ..onStart = _handleDragStart
                  ..onUpdate = _handleDragUpdate
                  ..minFlingDistance = _physics?.minFlingDistance
                  ..maxFlingVelocity = _physics?.maxFlingVelocity
                  ..minFlingVelocity = _physics?.minFlingVelocity
                  ..velocityTrackerBuilder = _configuration.velocityTrackerBuilder(context)
                  ..dragStartBehavior = widget.dragStartBehavior;
              },
            ),
          };
          break;
      }
    }

    _lastAxisDirection = widget.axis;
    _lastCanDrag = canDrag;

    if (_gestureDetectorKey.currentState != null) {
      _gestureDetectorKey.currentState!.replaceGestureRecognizers(_gestureRecognizers);
    }
  }

  @override
  @protected
  void setIgnorePointer(bool value) {
    if (_shouldIgnorePointer == value) {
      return;
    }

    _shouldIgnorePointer = value;

    if (_ignorePointerKey.currentContext != null) {
      final renderBox = _ignorePointerKey.currentContext!.findRenderObject()! as RenderIgnorePointer;
      renderBox.ignoring = _shouldIgnorePointer;
    }
  }

  void _disposeDrag() {
    _drag = null;
  }

  void _disposeHold() {
    _hold = null;
  }

  void _handleDragCancel() {
    assert(_drag == null || _hold == null);
    _drag?.cancel();
    _hold?.cancel();
    assert(_drag == null);
    assert(_hold == null);
  }

  void _handleDragDown(DragDownDetails details) {
    assert(_drag == null);
    assert(_hold == null);
    _hold = position.hold(_disposeHold);
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(_drag == null || _hold == null);
    _drag?.end(details);
    assert(_drag == null);
  }

  void _handleDragStart(DragStartDetails details) {
    assert(_drag == null);
    _drag = position.drag(details, _disposeDrag);
    assert(_drag != null);
    assert(_hold == null);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(_drag == null || _hold == null);
    _drag?.update(details);
  }

  void _handlePointerScroll(PointerEvent event) {
    assert(event is PointerScrollEvent);

    final delta = _pointerSignalEventDelta(event as PointerScrollEvent);
    final targetScrollOffset = _targetScrollOffsetForPointerScroll(delta);

    if (delta != .0 && targetScrollOffset != position.pixels) {
      position.pointerScroll(delta);
    }
  }

  double _pointerSignalEventDelta(PointerScrollEvent event) {
    double delta = widget.axis == Axis.horizontal ? event.scrollDelta.dx : event.scrollDelta.dy;

    if (axisDirectionIsReversed(widget.axisDirection)) {
      delta *= -1;
    }

    return delta;
  }

  void _receivedPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || _position == null) {
      return;
    }

    if (_physics != null && _physics!.shouldAcceptUserOffset(position)) {
      return;
    }

    final delta = _pointerSignalEventDelta(event);
    final targetScrollOffset = _targetScrollOffsetForPointerScroll(delta);

    if (delta != .0 && targetScrollOffset != position.pixels) {
      GestureBinding.instance.pointerSignalResolver.register(event, _handlePointerScroll);
    }
  }

  double _targetScrollOffsetForPointerScroll(double delta) {
    return math.min(
      math.max(position.pixels + delta, position.minScrollExtent),
      position.maxScrollExtent,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<ScrollPosition>('position', position));
    properties.add(DiagnosticsProperty<ScrollPhysics>('physics', _physics));
  }

  @override
  Widget build(BuildContext context) {
    assert(_position != null);

    Widget result = _CarrotSheetScrollableScope(
      position: position,
      scrollable: this,
      child: Listener(
        onPointerSignal: _receivedPointerSignal,
        child: RawGestureDetector(
          key: _gestureDetectorKey,
          behavior: HitTestBehavior.deferToChild,
          excludeFromSemantics: widget.excludeFromSemantics,
          gestures: _gestureRecognizers,
          child: Semantics(
            explicitChildNodes: !widget.excludeFromSemantics,
            child: CarrotSheetMinimumInteractionZone(
              direction: flipAxisDirection(widget.axisDirection),
              extent: widget.minInteractionExtent,
              child: widget.viewportBuilder(context, position),
            ),
          ),
        ),
      ),
    );

    if (!widget.excludeFromSemantics) {
      result = _CarrotSheetScrollSemantics(
        key: _scrollSemanticsKey,
        allowImplicitScrolling: _physics!.allowImplicitScrolling,
        position: position,
        semanticChildCount: widget.semanticChildCount,
        child: result,
      );
    }

    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: result,
    );
  }
}

class _CarrotSheetRestorableScrollOffset extends RestorableValue<double?> {
  @override
  bool get enabled => value != null;

  @override
  double? createDefaultValue() => null;

  @override
  void didUpdateValue(double? oldValue) {
    notifyListeners();
  }

  @override
  double fromPrimitives(Object? data) {
    return data! as double;
  }

  @override
  Object? toPrimitives() {
    return value;
  }
}

class _CarrotSheetScrollableScope extends InheritedWidget {
  final ScrollPosition position;
  final _CarrotSheetScrollableState scrollable;

  const _CarrotSheetScrollableScope({
    required super.child,
    required this.position,
    required this.scrollable,
  });

  @override
  bool updateShouldNotify(_CarrotSheetScrollableScope oldWidget) {
    return position != oldWidget.position;
  }
}

class _CarrotSheetScrollSemantics extends SingleChildRenderObjectWidget {
  final bool allowImplicitScrolling;
  final ScrollPosition position;
  final int? semanticChildCount;

  const _CarrotSheetScrollSemantics({
    super.key,
    super.child,
    required this.allowImplicitScrolling,
    required this.position,
    required this.semanticChildCount,
  });

  @override
  _CarrotSheetScrollSemanticsRenderObject createRenderObject(BuildContext context) {
    return _CarrotSheetScrollSemanticsRenderObject(
      allowImplicitScrolling: allowImplicitScrolling,
      position: position,
      semanticChildCount: semanticChildCount,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _CarrotSheetScrollSemanticsRenderObject renderObject) {
    renderObject
      ..allowImplicitScrolling = allowImplicitScrolling
      ..position = position
      ..semanticChildCount = semanticChildCount;
  }
}

class _CarrotSheetScrollSemanticsRenderObject extends RenderProxyBox {
  bool _allowImplicitScrolling;
  ScrollPosition _position;
  int? _semanticChildCount;

  SemanticsNode? _innerNode;

  bool get allowImplicitScrolling => _allowImplicitScrolling;

  ScrollPosition get position => _position;

  int? get semanticChildCount => _semanticChildCount;

  set allowImplicitScrolling(bool value) {
    if (value == _allowImplicitScrolling) {
      return;
    }

    _allowImplicitScrolling = value;
    markNeedsSemanticsUpdate();
  }

  set position(ScrollPosition value) {
    if (value == _position) {
      return;
    }

    _position.removeListener(markNeedsSemanticsUpdate);
    _position = value;
    _position.addListener(markNeedsSemanticsUpdate);
    markNeedsSemanticsUpdate();
  }

  set semanticChildCount(int? value) {
    if (value == _semanticChildCount) {
      return;
    }

    _semanticChildCount = value;
    markNeedsSemanticsUpdate();
  }

  _CarrotSheetScrollSemanticsRenderObject({
    required bool allowImplicitScrolling,
    required ScrollPosition position,
    required int? semanticChildCount,
    RenderBox? child,
  })  : _allowImplicitScrolling = allowImplicitScrolling,
        _position = position,
        _semanticChildCount = semanticChildCount,
        super(child) {
    position.addListener(markNeedsSemanticsUpdate);
  }

  @override
  void assembleSemanticsNode(SemanticsNode node, SemanticsConfiguration config, Iterable<SemanticsNode> children) {
    if (children.isEmpty || !children.first.isTagged(RenderViewport.useTwoPaneSemantics)) {
      super.assembleSemanticsNode(node, config, children);
      return;
    }

    _innerNode ??= SemanticsNode(showOnScreen: showOnScreen);
    _innerNode!.rect = node.rect;

    int? firstVisibleIndex;
    final List<SemanticsNode> excluded = [_innerNode!];
    final List<SemanticsNode> included = [];

    for (final child in children) {
      assert(child.isTagged(RenderViewport.useTwoPaneSemantics));

      if (child.isTagged(RenderViewport.excludeFromScrolling)) {
        excluded.add(child);
      } else {
        if (!child.hasFlag(SemanticsFlag.isHidden)) {
          firstVisibleIndex ??= child.indexInParent;
        }
        included.add(child);
      }
    }

    config.scrollIndex = firstVisibleIndex;
    node.updateWith(config: null, childrenInInversePaintOrder: excluded);
    _innerNode!.updateWith(config: config, childrenInInversePaintOrder: included);
  }

  @override
  void clearSemantics() {
    super.clearSemantics();
    _innerNode = null;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = true;

    if (position.haveDimensions) {
      config
        ..hasImplicitScrolling = _allowImplicitScrolling
        ..scrollPosition = _position.pixels
        ..scrollExtentMax = _position.maxScrollExtent
        ..scrollExtentMin = _position.minScrollExtent
        ..scrollChildCount = _semanticChildCount;
    }
  }
}

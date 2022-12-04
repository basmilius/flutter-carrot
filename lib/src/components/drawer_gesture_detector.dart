import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../routing/routing.dart';
import '../ui/color.dart';
import 'primitive/primitive.dart';

typedef CarrotDrawerOpenChangedCallback = void Function(bool);

const double _drawerEdgeDetect = 15.0;
const Duration _drawerSettleDuration = Duration(milliseconds: 246);

enum CarrotDrawerAlignment {
  start,
  end,
}

enum CarrotDrawerBehavior {
  appear,
  offset,
  over,
  push,
  resize,
  resizeOffset,
}

class CarrotDrawerGestureDetector extends StatefulWidget {
  final CarrotDrawerAlignment alignment;
  final CarrotDrawerBehavior behavior;
  final Widget child;
  final Widget drawer;
  final double drawerWidth;
  final bool isOpen;
  final Color? scrimColor;
  final CarrotDrawerOpenChangedCallback? onOpenChanged;

  const CarrotDrawerGestureDetector({
    super.key,
    required this.child,
    required this.drawer,
    this.alignment = CarrotDrawerAlignment.start,
    this.behavior = CarrotDrawerBehavior.push,
    this.drawerWidth = 300.0,
    this.isOpen = false,
    this.scrimColor,
    this.onOpenChanged,
  });

  @override
  createState() => _CarrotDrawerGestureDetectorState();

  static CarrotDrawerController of(BuildContext context) {
    final state = context.findAncestorStateOfType<_CarrotDrawerGestureDetectorState>();

    if (state == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotDrawerGestureDetector.of() called with a context that does not contain a CarrotDrawerGestureDetector.',
        ),
      ]);
    }

    return state;
  }
}

class _CarrotDrawerGestureDetectorState extends State<CarrotDrawerGestureDetector> with SingleTickerProviderStateMixin implements CarrotDrawerController {
  final GlobalKey _drawerKey = GlobalKey();
  final GlobalKey _drawerGestureDetectorKey = GlobalKey();

  late AnimationController _controller;
  late ColorTween _scrimColorTween;

  bool _didMove = false;
  bool _wasOpen = false;

  @override
  bool get isOpen => _controller.value > .5;

  bool get _isResizeMode => widget.behavior == CarrotDrawerBehavior.resize || widget.behavior == CarrotDrawerBehavior.resizeOffset;

  @override
  void didUpdateWidget(CarrotDrawerGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen != oldWidget.isOpen && (_controller.status == AnimationStatus.completed || _controller.status == AnimationStatus.dismissed)) {
      if (widget.isOpen) {
        open();
      } else {
        close();
      }
    }

    if (widget.scrimColor != oldWidget.scrimColor) {
      _scrimColorTween = _buildScrimColorTween();
    }
  }

  @override
  void dispose() {
    _routingListenerRemove();
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.isOpen ? 1.0 : 0.0,
      duration: _drawerSettleDuration,
      vsync: this,
    );

    _controller
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);

    onMounted(() {
      _scrimColorTween = _buildScrimColorTween();
      _routingListenerAdd();
    });
  }

  @override
  void close() {
    _controller.fling(velocity: -1.0);
    _wasOpen = false;
    widget.onOpenChanged?.call(false);
  }

  @override
  void open() {
    _controller.fling();
    _wasOpen = true;
    widget.onOpenChanged?.call(true);
  }

  void _animationChanged() {
    setState(() {});
  }

  void _animationStatusChanged(AnimationStatus status) {
    // todo(Bas): History stack.
  }

  ColorTween _buildScrimColorTween() {
    return ColorTween(
      begin: CarrotColors.transparent,
      end: widget.scrimColor ?? context.carrotTheme.defaults.scrim,
    );
  }

  void _handleRoutingChange() {
    close();
  }

  void _routingListenerAdd() {
    CarrotRouter.of(context).addListener(_handleRoutingChange);
  }

  void _routingListenerRemove() {
    CarrotRouter.of(context).removeListener(_handleRoutingChange);
  }

  void _move(DragUpdateDetails details) {
    if (isOpen && _isResizeMode && widget.alignment == CarrotDrawerAlignment.start && details.localPosition.dx > widget.drawerWidth) {
      return;
    }

    double delta = details.primaryDelta! / widget.drawerWidth;

    switch (widget.alignment) {
      case CarrotDrawerAlignment.start:
        _controller.value += delta;
        break;

      case CarrotDrawerAlignment.end:
        _controller.value -= delta;
        break;
    }

    if (isOpen != _wasOpen) {
      widget.onOpenChanged?.call(isOpen);
    }

    _didMove = true;
    _wasOpen = isOpen;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed || !_didMove) {
      return;
    }

    _didMove = false;

    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / widget.drawerWidth;

      switch (widget.alignment) {
        case CarrotDrawerAlignment.start:
          _controller.fling(velocity: visualVelocity);
          widget.onOpenChanged?.call(visualVelocity > 0);
          break;

        case CarrotDrawerAlignment.end:
          _controller.fling(velocity: -visualVelocity);
          widget.onOpenChanged?.call(visualVelocity < 0);
          break;
      }
    } else if (!isOpen) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool drawerIsStart = widget.alignment == CarrotDrawerAlignment.start;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final double dragAreaWidth = _drawerEdgeDetect + (drawerIsStart ? padding.left : padding.right);
    final double offsetMultiplier = drawerIsStart ? 1 : -1;

    EdgeInsets childInsets = EdgeInsets.zero;
    Offset childOffset = const Offset(0, 0);
    Offset drawerOffset = const Offset(0, 0);
    bool scrimVisible = true;

    switch (widget.behavior) {
      case CarrotDrawerBehavior.appear:
        childOffset = Offset(_controller.value * widget.drawerWidth / 2 * offsetMultiplier, 0);
        drawerOffset = Offset((1 - _controller.value) * widget.drawerWidth * offsetMultiplier, 0);
        break;

      case CarrotDrawerBehavior.offset:
        childOffset = Offset(_controller.value * widget.drawerWidth / 2 * offsetMultiplier, 0);
        drawerOffset = Offset((1 - _controller.value) * widget.drawerWidth / 2 * offsetMultiplier, 0);
        break;

      case CarrotDrawerBehavior.over:
        break;

      case CarrotDrawerBehavior.push:
        childOffset = Offset(_controller.value * widget.drawerWidth * offsetMultiplier, 0);
        break;

      case CarrotDrawerBehavior.resize:
        childInsets = EdgeInsets.only(
          left: drawerIsStart ? _controller.value * widget.drawerWidth : 0,
          right: drawerIsStart ? 0 : _controller.value * widget.drawerWidth,
        );
        scrimVisible = false;
        break;

      case CarrotDrawerBehavior.resizeOffset:
        childInsets = EdgeInsets.only(
          left: drawerIsStart ? _controller.value * widget.drawerWidth : 0,
          right: drawerIsStart ? 0 : _controller.value * widget.drawerWidth,
        );
        drawerOffset = Offset((1 - _controller.value) * widget.drawerWidth / 2 * offsetMultiplier, 0);
        scrimVisible = false;
        break;
    }

    if (_controller.status == AnimationStatus.dismissed) {
      return Stack(
        children: [
          widget.child,
          Align(
            alignment: drawerIsStart ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
            child: GestureDetector(
              key: _drawerGestureDetectorKey,
              behavior: HitTestBehavior.translucent,
              dragStartBehavior: DragStartBehavior.start,
              excludeFromSemantics: true,
              onHorizontalDragUpdate: _move,
              onHorizontalDragEnd: _settle,
              child: Container(
                width: dragAreaWidth,
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      key: _drawerGestureDetectorKey,
      dragStartBehavior: DragStartBehavior.start,
      excludeFromSemantics: true,
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: RepaintBoundary(
        child: Stack(
          children: [
            Transform.translate(
              offset: childOffset,
              child: Padding(
                padding: childInsets,
                child: widget.child,
              ),
            ),
            if (scrimVisible)
              CarrotScrim(
                color: _scrimColorTween.evaluate(_controller),
                label: context.carrotStrings.drawerClose,
                onTap: close,
              ),
            Align(
              alignment: drawerIsStart ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
              child: Align(
                alignment: drawerIsStart ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                widthFactor: _controller.value,
                child: RepaintBoundary(
                  child: FocusScope(
                    key: _drawerKey,
                    child: SizedBox(
                      width: widget.drawerWidth,
                      child: ClipRect(
                        child: Transform.translate(
                          offset: drawerOffset,
                          child: widget.drawer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class CarrotDrawerController {
  bool get isOpen;

  void close();

  void open();
}

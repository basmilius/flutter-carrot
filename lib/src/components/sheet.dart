import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import '../ui/color.dart';

import 'primitive/primitive.dart';

const Duration _sheetSettleDuration = Duration(milliseconds: 246);

typedef CarrotSheetBuilder = Widget Function(BuildContext, CarrotSheetEntry);
typedef CarrotSheetOnCloseCallback = void Function();
typedef CarrotSheetOnOpenCallback = void Function();

enum CarrotSheetAlign {
  end,
  start,
}

enum CarrotSheetAxis {
  horizontal,
  vertical,
}

class CarrotSheetEntry {
  final CarrotSheetAlign align;
  final CarrotSheetAxis axis;
  final CarrotSheetBuilder builder;
  final Color? scrimColor;

  const CarrotSheetEntry({
    required this.builder,
    this.align = CarrotSheetAlign.start,
    this.axis = CarrotSheetAxis.horizontal,
    this.scrimColor,
  });
}

class CarrotSheetGestureDetector extends StatefulWidget {
  final CarrotSheetAlign align;
  final CarrotSheetAxis axis;
  final Widget child;
  final bool hasFocus;
  final Color? scrimColor;
  final CarrotSheetOnCloseCallback onClose;
  final CarrotSheetOnOpenCallback onOpen;

  const CarrotSheetGestureDetector({
    super.key,
    required this.child,
    required this.hasFocus,
    required this.onClose,
    required this.onOpen,
    this.align = CarrotSheetAlign.start,
    this.axis = CarrotSheetAxis.horizontal,
    this.scrimColor,
  });

  @override
  createState() => _CarrotSheetGestureDetector();

  static CarrotSheetController of(BuildContext context) {
    var state = context.findAncestorStateOfType<_CarrotSheetGestureDetector>();

    if (state == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotSheetGestureDetector.of() called with a context that does not contain a CarrotSheetGestureDetector.',
        ),
      ]);
    }

    return state;
  }
}

class _CarrotSheetGestureDetector extends State<CarrotSheetGestureDetector> with SingleTickerProviderStateMixin implements CarrotSheetController {
  late AnimationController _controller;
  late ColorTween _scrimColorTween;

  bool _didMove = false;
  Size _sheetSize = Size.zero;

  @override
  bool get isOpen => _controller.value > .5;

  @override
  bool get isHorizontal => widget.axis == CarrotSheetAxis.horizontal;

  @override
  bool get isVertical => widget.axis == CarrotSheetAxis.vertical;

  @override
  bool get isEnd => widget.align == CarrotSheetAlign.end;

  @override
  bool get isStart => widget.align == CarrotSheetAlign.start;

  Offset get _translate => Offset(_translateX, _translateY);

  double get _translateX => isHorizontal ? (1 - _controller.value) * _sheetSize.width * (isStart ? -1 : 1) : 0;

  double get _translateY => isVertical ? (1 - _controller.value) * _sheetSize.height * (isStart ? -1 : 1) : 0;

  AlignmentDirectional get _baseAlignment {
    if (isHorizontal && isStart) {
      return AlignmentDirectional.centerStart;
    } else if (isHorizontal && isEnd) {
      return AlignmentDirectional.centerEnd;
    } else if (isVertical && isStart) {
      return AlignmentDirectional.topCenter;
    } else if (isVertical && isEnd) {
      return AlignmentDirectional.bottomCenter;
    }

    return AlignmentDirectional.center;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrimColorTween = _buildScrimColorTween();
  }

  @override
  void didUpdateWidget(CarrotSheetGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrimColor != oldWidget.scrimColor) {
      _scrimColorTween = _buildScrimColorTween();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _sheetSettleDuration,
      value: .0,
      vsync: this,
    );

    _controller
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);

    onMounted(open);
  }

  @override
  void close() {
    _controller.fling(velocity: -1.0);
  }

  @override
  void open() {
    _controller.fling(velocity: 1.0);
  }

  void _animationChanged() {
    setState(() {});
  }

  void _animationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onOpen();
    } else if (status == AnimationStatus.dismissed) {
      widget.onClose();
    }
  }

  ColorTween _buildScrimColorTween() {
    return ColorTween(
      begin: CarrotColors.transparent,
      end: widget.scrimColor ?? context.carrotTheme.defaults.scrim,
    );
  }

  void _move(DragUpdateDetails details) {
    if (isHorizontal && isStart) {
      _controller.value += details.delta.dx / _sheetSize.width;
    } else if (isHorizontal && isEnd) {
      _controller.value -= details.delta.dx / _sheetSize.width;
    } else if (isVertical && isStart) {
      _controller.value += details.delta.dy / _sheetSize.height;
    } else if (isVertical && isEnd) {
      _controller.value -= details.delta.dy / _sheetSize.height;
    }

    _didMove = true;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed || !_didMove) {
      return;
    }

    _didMove = false;

    double velocityPixelsPerSecond = isHorizontal ? details.velocity.pixelsPerSecond.dx : details.velocity.pixelsPerSecond.dy;
    if (velocityPixelsPerSecond.abs() >= 365.0) {
      double visualVelocity = velocityPixelsPerSecond / (isHorizontal ? _sheetSize.width : _sheetSize.height);

      if (isStart) {
        _controller.fling(velocity: visualVelocity);
      } else {
        _controller.fling(velocity: -visualVelocity);
      }
    } else if (!isOpen) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      excludeFromSemantics: true,
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      onVerticalDragUpdate: _move,
      onVerticalDragEnd: _settle,
      child: RepaintBoundary(
        child: Stack(
          children: [
            CarrotScrim(
              color: _scrimColorTween.evaluate(_controller),
              label: "Close sheet", // todo(Bas): Make localizable.
              opacity: widget.hasFocus ? 1 : .5,
              onTap: close,
            ),
            Align(
              alignment: _baseAlignment,
              child: AnimatedScale(
                curve: CarrotCurves.springOverDamped,
                duration: const Duration(milliseconds: 540),
                scale: widget.hasFocus ? 1 : .85,
                child: Transform.translate(
                  offset: _translate,
                  child: CarrotSizeMeasureChild(
                    child: Opacity(
                      opacity: _sheetSize == Size.zero ? 0 : 1,
                      child: widget.child,
                    ),
                    onChange: (size) => _sheetSize = size,
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

abstract class CarrotSheetController {
  bool get isOpen;

  bool get isHorizontal;

  bool get isVertical;

  bool get isEnd;

  bool get isStart;

  void close();

  void open();
}

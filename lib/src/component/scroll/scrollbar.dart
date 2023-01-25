import 'package:flutter/cupertino.dart' show CupertinoDynamicColor;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const Radius _defaultRadius = Radius.circular(3.0);
const Radius _defaultRadiusWhileDragging = Radius.circular(6.0);
const double _defaultThickness = 3.0;
const double _defaultThicknessWhileDragging = 9.0;

const double _scrollbarMinSize = 36.0;
const double _scrollbarMinOverscrollSize = 9.0;

const double _scrollbarCrossAxisMargin = 3.0;
const double _scrollbarMainAxisMargin = 3.0;

const Duration _scrollbarTimeToFade = Duration(milliseconds: 1200);
const Duration _scrollbarFadeDuration = Duration(milliseconds: 240);
const Duration _scrollbarResizeDuration = Duration(milliseconds: 120);

const Color _scrollbarColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x59000000),
  darkColor: Color(0x80FFFFFF),
);

class CarrotScrollbar extends RawScrollbar {
  final Radius radiusWhileDragging;
  final double thicknessWhileDragging;

  const CarrotScrollbar({
    super.key,
    required super.child,
    super.controller,
    super.notificationPredicate = defaultScrollNotificationPredicate,
    super.padding = EdgeInsets.zero,
    super.radius = _defaultRadius,
    super.scrollbarOrientation,
    super.thickness = _defaultThickness,
    super.thumbVisibility = false,
    this.radiusWhileDragging = _defaultRadiusWhileDragging,
    this.thicknessWhileDragging = _defaultThicknessWhileDragging,
  })  : assert(thicknessWhileDragging < double.infinity),
        super(
          fadeDuration: _scrollbarFadeDuration,
          timeToFade: _scrollbarTimeToFade,
          pressDuration: const Duration(milliseconds: 90),
        );

  @override
  createState() => _CarrotScrollbarState();
}

class _CarrotScrollbarState extends RawScrollbarState<CarrotScrollbar> {
  late AnimationController _thicknessAnimationController;

  double _pressStartAxisPosition = 0.0;

  Radius get _radius => Radius.lerp(widget.radius, widget.radiusWhileDragging, _thicknessAnimationController.value)!;

  double get _thickness => widget.thickness! + _thicknessAnimationController.value * (widget.thicknessWhileDragging - widget.thickness!);

  @override
  void dispose() {
    _thicknessAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _thicknessAnimationController = AnimationController(
      vsync: this,
      duration: _scrollbarResizeDuration,
    );

    _thicknessAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = CupertinoDynamicColor.resolve(_scrollbarColor, context)
      ..textDirection = Directionality.of(context)
      ..thickness = _thickness
      ..crossAxisMargin = _scrollbarCrossAxisMargin
      ..mainAxisMargin = _scrollbarMainAxisMargin
      ..radius = _radius
      ..padding = MediaQuery.of(context).padding.add(widget.padding ?? EdgeInsets.zero) as EdgeInsets
      ..minLength = _scrollbarMinSize
      ..minOverscrollLength = _scrollbarMinOverscrollSize
      ..scrollbarOrientation = widget.scrollbarOrientation;
  }

  @override
  void handleThumbPress() {
    if (getScrollbarDirection() == null) {
      return;
    }

    super.handleThumbPress();

    _thicknessAnimationController.forward().then<void>((_) => HapticFeedback.mediumImpact());
  }

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);

    switch (getScrollbarDirection()!) {
      case Axis.horizontal:
        _pressStartAxisPosition = localPosition.dx;
        break;

      case Axis.vertical:
        _pressStartAxisPosition = localPosition.dy;
        break;
    }
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    final Axis? direction = getScrollbarDirection();

    if (direction == null) {
      return;
    }

    _thicknessAnimationController.reverse();

    super.handleThumbPressEnd(localPosition, velocity);

    switch (direction) {
      case Axis.horizontal:
        if (velocity.pixelsPerSecond.dx.abs() < 10 && (localPosition.dx - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;

      case Axis.vertical:
        if (velocity.pixelsPerSecond.dy.abs() < 10 && (localPosition.dy - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;
    }
  }
}

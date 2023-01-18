import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../extension/extension.dart';
import 'primitive/primitive.dart';

const _kDefaultPopupDuration = Duration(milliseconds: 210);

enum CarrotPopupPlacement {
  center,
  end,
  full,
  start,
}

enum CarrotPopupPosition {
  above,
  below,
  side,
}

Future<T?> showCarrotPopup<T>({
  required WidgetBuilder builder,
  required BuildContext context,
  required Offset targetOffset,
  Offset offset = Offset.zero,
  CarrotPopupPlacement placement = CarrotPopupPlacement.start,
  CarrotPopupPosition position = CarrotPopupPosition.below,
}) {
  final navigator = Navigator.of(context, rootNavigator: true);

  assert(debugCheckHasDirectionality(context));

  final itemRect = targetOffset & Size.zero;

  return navigator.push(_CarrotPopupRoute<T>(
    barrierColor: context.carrotTheme.defaults.scrim.withOpacity(.25),
    content: CarrotSizeMeasureProvider(
      builder: builder,
    ),
    offset: offset,
    openerRect: itemRect,
    placement: placement,
    placementOffset: targetOffset,
    position: position,
    target: targetOffset,
  ));
}

class CarrotPopup<T> extends StatefulWidget {
  final Widget child;
  final WidgetBuilder content;
  final CarrotPopupController controller;
  final Offset offset;
  final CarrotPopupPlacement placement;
  final CarrotPopupPosition position;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;

  const CarrotPopup({
    super.key,
    required this.content,
    required this.controller,
    required this.offset,
    required this.placement,
    required this.position,
    required this.child,
    this.onClose,
    this.onOpen,
  });

  @override
  createState() => CarrotPopupState<T>();
}

class CarrotPopupState<T> extends State<CarrotPopup<T>> {
  late final CarrotPopupController _controller;
  _CarrotPopupRoute<T>? _route;

  bool get isOpen => _route != null;

  @override
  void didUpdateWidget(CarrotPopup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _removeController();
      _registerController();
    }
  }

  @override
  void dispose() {
    _removeController();
    _removePopupRoute();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerController();
  }

  Future<void> open() {
    assert(_route == null, 'A popup can only be opened once.');

    final navigator = Navigator.of(context, rootNavigator: true);
    final navigatorRenderObject = navigator.context.findRenderObject();
    final itemBox = context.findRenderObject()! as RenderBox;

    Offset leftTarget = itemBox.localToGlobal(
      itemBox.size.centerLeft(Offset.zero),
      ancestor: navigatorRenderObject,
    );

    Offset centerTarget = itemBox.localToGlobal(
      itemBox.size.center(Offset.zero),
      ancestor: navigatorRenderObject,
    );

    Offset rightTarget = itemBox.localToGlobal(
      itemBox.size.centerRight(Offset.zero),
      ancestor: navigatorRenderObject,
    );

    assert(debugCheckHasDirectionality(context));
    final directionality = Directionality.of(context);

    final directionalityTarget = () {
      switch (widget.placement) {
        case CarrotPopupPlacement.start:
          return directionality == TextDirection.rtl ? leftTarget : rightTarget;

        case CarrotPopupPlacement.end:
          return directionality == TextDirection.rtl ? rightTarget : leftTarget;

        default:
          return centerTarget;
      }
    }();

    final directionalityPlacement = () {
      switch (widget.placement) {
        case CarrotPopupPlacement.start:
          if (directionality == TextDirection.rtl) {
            return CarrotPopupPlacement.end;
          }
          return widget.placement;

        case CarrotPopupPlacement.end:
          if (directionality == TextDirection.rtl) {
            return CarrotPopupPlacement.start;
          }
          return widget.placement;

        default:
          return widget.placement;
      }
    }();

    final itemRect = directionalityTarget & itemBox.size;

    _route = _CarrotPopupRoute<T>(
      barrierColor: context.carrotTheme.defaults.scrim.withOpacity(.25),
      content: CarrotSizeMeasureProvider(
        builder: widget.content,
      ),
      offset: widget.offset,
      openerRect: itemRect,
      placement: directionalityPlacement,
      placementOffset: directionalityTarget,
      position: widget.position,
      target: centerTarget,
    );

    return navigator.push(_route!).then((newValue) {
      _removePopupRoute();
      _controller._open = false;
      widget.onClose?.call();

      if (!mounted || newValue == null) {
        return;
      }
    });
  }

  void _handleControllerChange() {
    if (!mounted) {
      return;
    }

    if (!isOpen && _controller._open) {
      open();
      widget.onOpen?.call();
    } else if (isOpen && !_controller._open) {
      Navigator.of(context, rootNavigator: true).pop();
      widget.onClose?.call();
    }
  }

  void _registerController() {
    _controller = widget.controller;
    _controller.addListener(_handleControllerChange);
  }

  void _removeController() {
    _controller.removeListener(_handleControllerChange);
  }

  void _removePopupRoute() {
    _route?._dismiss();
    _route = null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    return widget.child;
  }
}

class CarrotPopupController extends ChangeNotifier with Diagnosticable {
  bool _open = false;

  bool get isClosed => !_open;

  bool get isOpen => _open;

  void close() {
    _open = false;
    notifyListeners();
  }

  void open() {
    _open = true;
    notifyListeners();
  }

  void toggle() {
    if (_open) {
      close();
    } else {
      open();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(FlagProperty(
      'open',
      value: _open,
      ifFalse: 'Closed',
      defaultValue: false,
    ));
  }
}

class _CarrotPopupRoute<T> extends PopupRoute<T> {
  final Widget content;
  final Offset offset;
  final Rect openerRect;
  final CarrotPopupPlacement placement;
  final Offset placementOffset;
  final CarrotPopupPosition position;
  final Offset target;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final Duration transitionDuration;

  @override
  bool get barrierDismissible => true;

  _CarrotPopupRoute({
    required this.content,
    required this.offset,
    required this.openerRect,
    required this.placement,
    required this.placementOffset,
    required this.position,
    required this.target,
    this.barrierColor,
    this.barrierLabel,
    this.transitionDuration = _kDefaultPopupDuration,
  });

  void _dismiss() {
    if (!isActive) {
      return;
    }

    navigator?.removeRoute(this);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (context, constraints) => _CarrotPopupPageRoute<T>(
        constraints: constraints,
        content: content,
        offset: offset,
        openerRect: openerRect,
        placement: placement,
        placementOffset: placementOffset,
        position: position,
        route: this,
        target: target,
      ),
    );
  }
}

class _CarrotPopupPageRoute<T> extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget content;
  final Offset offset;
  final Rect openerRect;
  final CarrotPopupPlacement placement;
  final Offset placementOffset;
  final CarrotPopupPosition position;
  final _CarrotPopupRoute<T> route;
  final Offset target;
  final TextStyle? textStyle;

  const _CarrotPopupPageRoute({
    super.key,
    required this.constraints,
    required this.content,
    required this.offset,
    required this.openerRect,
    required this.placement,
    required this.placementOffset,
    required this.position,
    required this.route,
    required this.target,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final textDirection = Directionality.maybeOf(context);
    final menu = _CarrotPopupMenu<T>(
      constraints: constraints,
      openerRect: openerRect,
      route: route,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeLeft: true,
      removeRight: true,
      removeBottom: true,
      child: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);

          return SizedBox.fromSize(
            size: mediaQuery.size,
            child: CustomSingleChildLayout(
              delegate: _CarrotPopupMenuLayout<T>(
                offset: offset,
                openerRect: openerRect,
                placement: placement,
                placementOffset: placementOffset,
                position: position,
                route: route,
                screenSize: mediaQuery.size,
                target: target,
                textDirection: textDirection,
              ),
              child: menu,
            ),
          );
        },
      ),
    );
  }
}

class _CarrotPopupMenu<T> extends StatefulWidget {
  final Color? color;
  final BoxConstraints constraints;
  final Rect openerRect;
  final _CarrotPopupRoute<T> route;

  const _CarrotPopupMenu({
    super.key,
    this.color,
    required this.constraints,
    required this.openerRect,
    required this.route,
  });

  @override
  createState() => _CarrotPopupMenuState<T>();
}

class _CarrotPopupMenuState<T> extends State<_CarrotPopupMenu<T>> {
  late final CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();

    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: CarrotCurves.swiftOutCurve,
      reverseCurve: CarrotCurves.swiftOutCurveReversed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Semantics(
        explicitChildNodes: true,
        namesRoute: true,
        scopesRoute: true,
        child: widget.route.content,
      ),
    );
  }
}

class _CarrotPopupMenuLayout<T> extends SingleChildLayoutDelegate {
  final Offset offset;
  final Rect openerRect;
  final CarrotPopupPlacement placement;
  final Offset placementOffset;
  final CarrotPopupPosition position;
  final _CarrotPopupRoute<T> route;
  final Size screenSize;
  final Offset target;
  final TextDirection? textDirection;

  const _CarrotPopupMenuLayout({
    required this.offset,
    required this.openerRect,
    required this.placement,
    required this.placementOffset,
    required this.position,
    required this.route,
    required this.screenSize,
    required this.target,
    this.textDirection,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final isCloseToBottom = target.dy > screenSize.height / 3;

    if (isCloseToBottom) {
      return BoxConstraints(
        maxHeight: target.dy - openerRect.height,
        maxWidth: constraints.maxWidth,
      );
    }

    return BoxConstraints(
      maxHeight: screenSize.height - target.dy - openerRect.height,
      maxWidth: constraints.maxWidth,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final defaultOffset = position == CarrotPopupPosition.side
        ? _horizontalPositionDependentBox(
            childSize: childSize,
            horizontalOffset: offset.dy,
            preferLeft: placement == CarrotPopupPlacement.end,
            margin: offset.dx,
            size: size,
            target: target,
          )
        : positionDependentBox(
            childSize: childSize,
            margin: offset.dx,
            size: size,
            target: target,
            verticalOffset: offset.dy,
            preferBelow: () {
              if (position == CarrotPopupPosition.below) {
                return screenSize.height > target.dy + childSize.height;
              } else if (position == CarrotPopupPosition.above) {
                return 0 > target.dy - childSize.height;
              } else {
                return true;
              }
            }(),
          );

    if (position == CarrotPopupPosition.side) {
      return Offset(defaultOffset.dx, defaultOffset.dy);
    }

    switch (placement) {
      case CarrotPopupPlacement.center:
        return defaultOffset;

      case CarrotPopupPlacement.end:
        return Offset(placementOffset.dx - childSize.width, defaultOffset.dy);

      case CarrotPopupPlacement.full:
        return Offset.zero;

      case CarrotPopupPlacement.start:
        return Offset(placementOffset.dx, placementOffset.dy);
    }
  }

  @override
  bool shouldRelayout(_CarrotPopupMenuLayout<T> oldDelegate) {
    return oldDelegate.target == target || oldDelegate.placementOffset == placementOffset || oldDelegate.openerRect != openerRect;
  }
}

Offset _horizontalPositionDependentBox({
  required Size childSize,
  required bool preferLeft,
  required Size size,
  required Offset target,
  double horizontalOffset = .0,
  double margin = 9.0,
}) {
  // Horizontal direction
  final fitsLeft = target.dx + horizontalOffset + childSize.width <= size.width - margin;
  final fitsRight = target.dx - horizontalOffset - childSize.width >= margin;
  final left = preferLeft ? fitsLeft || !fitsRight : (!fitsRight || !fitsLeft);

  final x = left ? math.min(target.dx + horizontalOffset, size.width - margin) : math.max(target.dx - horizontalOffset - childSize.width, margin);

  late double y;

  if (size.height - margin * 2.0 < childSize.height) {
    y = (size.height - childSize.height) / 2.0;
  } else {
    final normalizedTargetY = target.dy.clamp(margin, size.height - margin);
    final edge = margin + childSize.height / 2.0;

    if (normalizedTargetY < edge) {
      y = margin;
    } else if (normalizedTargetY > size.height - edge) {
      y = size.height - margin - childSize.height;
    } else {
      y = normalizedTargetY - childSize.height / 2.0;
    }
  }

  return Offset(x, y);
}

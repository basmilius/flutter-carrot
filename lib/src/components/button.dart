import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';

import 'basic.dart';
import 'icon.dart';

enum CarrotButtonSize {
  tiny,
  small,
  medium,
  large,
}

class CarrotButton extends StatefulWidget {
  final BoxDecoration decoration;
  final BoxDecoration decorationTap;
  final List<Widget> children;
  final Duration duration;
  final FocusNode? focusNode;
  final String? icon;
  final String? iconAfter;
  final CarrotIconStyle iconAfterStyle;
  final CarrotIconStyle iconStyle;
  final EdgeInsets? padding;
  final double scale;
  final double scaleTap;
  final CarrotButtonSize size;
  final TextStyle textStyle;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const CarrotButton({
    super.key,
    required this.decoration,
    required this.decorationTap,
    required this.children,
    required this.duration,
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.iconAfterStyle = CarrotIconStyle.regular,
    this.iconStyle = CarrotIconStyle.regular,
    this.padding,
    this.scale = 1.0,
    this.scaleTap = .985,
    this.size = CarrotButtonSize.medium,
    this.textStyle = const TextStyle(),
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  createState() => _CarrotButton();
}

class _CarrotButton extends State<CarrotButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Decoration> _decorationAnimation;
  late Animation<double> _scaleAnimation;

  late Widget _content;

  bool get _canTap {
    return widget.onTap != null;
  }

  EdgeInsets get _padding {
    EdgeInsets padding = EdgeInsets.zero;

    if (widget.padding != null) {
      padding = widget.padding!;
    } else {
      switch (widget.size) {
        case CarrotButtonSize.tiny:
          padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
          break;

        case CarrotButtonSize.small:
          padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0);
          break;

        case CarrotButtonSize.medium:
          padding = const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0);
          break;

        case CarrotButtonSize.large:
          padding = const EdgeInsets.symmetric(horizontal: 27.0, vertical: 18.0);
          break;
      }
    }

    return padding;
  }

  @override
  void didUpdateWidget(CarrotButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didChangeChildren = oldWidget.children != widget.children || oldWidget.icon != widget.icon || oldWidget.iconAfter != widget.iconAfter || oldWidget.iconAfterStyle != widget.iconAfterStyle || oldWidget.iconStyle != widget.iconStyle;

    if (didChangeChildren) {
      _initChildren();
    }

    if (oldWidget.duration != widget.duration) {
      _animationController.duration = widget.duration;
      _initAnimation();
    }

    if (oldWidget.decoration != widget.decoration || oldWidget.decorationTap != widget.decorationTap) {
      _initAnimation();
      _initChildren();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: widget.duration, vsync: this);

    _initAnimation();
    _initChildren();
  }

  void _initAnimation() {
    _decorationAnimation = DecorationTween(begin: widget.decoration, end: widget.decorationTap).animate(CarrotSwiftOutCurveAnimation(parent: _animationController));
    _scaleAnimation = Tween<double>(begin: widget.scale, end: widget.scaleTap).animate(CarrotSwiftOutCurveAnimation(parent: _animationController));
  }

  void _initChildren() {
    List<Widget> children = [
      ...widget.children.map((child) => Flexible(
            child: child,
          ))
    ];

    final iconTextStyle = widget.textStyle.copyWith(
      fontSize: widget.size == CarrotButtonSize.tiny ? 16 : 21,
    );

    if (widget.icon != null) {
      children.insert(
          0,
          DefaultTextStyle(
            style: iconTextStyle,
            child: CarrotIcon(
              glyph: widget.icon!,
              style: widget.iconStyle,
            ),
          ));
    }

    if (widget.iconAfter != null) {
      children.add(DefaultTextStyle(
        style: iconTextStyle,
        child: CarrotIcon(
          glyph: widget.iconAfter!,
          style: widget.iconAfterStyle,
        ),
      ));
    }

    _content = CarrotRow(
      gap: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _onTapDown() {
    if (!_canTap) {
      return;
    }

    _animationController.forward();
  }

  void _onTapUp() {
    if (!_canTap) {
      return;
    }

    _animationController.reverse();
  }

  void _onPanCancel() {
    _onTapUp();
  }

  void _onPanDown(DragDownDetails details) {
    _onTapDown();
  }

  void _onPanEnd(DragEndDetails details) {
    _onTapUp();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onPanDown: _onPanDown,
        onPanEnd: _onPanEnd,
        onPanCancel: _onPanCancel,
        onTap: _onTap,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        onTapCancel: widget.onTapCancel,
        child: Focus(
          canRequestFocus: _canTap,
          focusNode: widget.focusNode,
          child: AnimatedBuilder(
              animation: _animationController,
              child: Padding(
                padding: _padding,
                child: DefaultTextStyle(
                  style: widget.textStyle.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: _content,
                ),
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: DecoratedBox(
                    decoration: _decorationAnimation.value,
                    child: child,
                  ),
                );
              }),
        ),
      ),
    );
  }
}

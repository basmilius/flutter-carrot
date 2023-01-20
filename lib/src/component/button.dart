import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../data/data.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';
import '../ui/ui.dart';
import 'icon.dart';
import 'primitive/primitive.dart';
import 'row.dart';

part 'contained_button.dart';

part 'contained_button_theme.dart';

part 'custom_button.dart';

part 'link_button.dart';

part 'link_button_theme.dart';

part 'text_button.dart';

part 'text_button_theme.dart';

enum CarrotButtonSize {
  tiny,
  small,
  medium,
  large,
}

enum _CarrotButtonType {
  icon,
  normal,
}

const _paddings = {
  CarrotButtonSize.tiny: EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 6.0,
  ),
  CarrotButtonSize.small: EdgeInsets.symmetric(
    horizontal: 15.0,
    vertical: 9.0,
  ),
  CarrotButtonSize.medium: EdgeInsets.symmetric(
    horizontal: 18.0,
    vertical: 12.0,
  ),
  CarrotButtonSize.large: EdgeInsets.symmetric(
    horizontal: 27.0,
    vertical: 18.0,
  ),
};

abstract class _CarrotButton extends StatefulWidget {
  final _CarrotButtonType type;
  final Curve curve;
  final List<Widget> children;
  final Duration duration;
  final FocusNode? focusNode;
  final String? icon;
  final String? iconAfter;
  final CarrotButtonSize size;
  final GestureTapCallback? onTap;

  const _CarrotButton({
    super.key,
    required this.children,
    this.type = _CarrotButtonType.normal,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 210),
    this.focusNode,
    this.icon,
    this.iconAfter,
    this.size = CarrotButtonSize.medium,
    this.onTap,
  });

  @protected
  _CarrotButtonStyle _getStyle(BuildContext context);

  @protected
  TextStyle _mergeTextStyle(
    BuildContext context, [
    TextStyle? other,
  ]) {
    TextStyle style = context.carrotTypography.base;

    if (size == CarrotButtonSize.tiny) {
      style = style.copyWith(
        fontSize: 14,
      );
    }

    if (other != null) {
      style = style.merge(other);
    }

    return style;
  }

  @override
  createState() => _CarrotButtonState();
}

class _CarrotButtonState extends State<_CarrotButton> with SingleTickerProviderStateMixin {
  late Widget _content;
  late _CarrotButtonStyle _style;

  bool get _canTap {
    return widget.onTap != null;
  }

  EdgeInsets get _padding {
    EdgeInsets padding = EdgeInsets.zero;

    if (_style.padding != null) {
      padding = _style.padding!;
    } else {
      padding = _paddings[widget.size]!;
    }

    if (widget.type == _CarrotButtonType.icon) {
      padding = EdgeInsets.all(padding.top);
    }

    return padding;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initStyle();
    _initChildren();
  }

  @override
  void didUpdateWidget(_CarrotButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didChangeChildren = oldWidget.children != widget.children || oldWidget.icon != widget.icon || oldWidget.iconAfter != widget.iconAfter;

    if (didChangeChildren) {
      _initChildren();
    }
  }

  void _initChildren() {
    List<Widget> children = [
      ...widget.children.map((child) => Flexible(
            child: child,
          ))
    ];

    final iconTextStyle = _style.textStyle.copyWith(
      fontSize: widget.size == CarrotButtonSize.tiny ? 16 : 21,
    );

    if (widget.icon != null) {
      children.insert(
        0,
        DefaultTextStyle(
          style: iconTextStyle,
          child: CarrotIcon(
            glyph: widget.icon!,
          ),
        ),
      );
    }

    if (widget.iconAfter != null) {
      children.add(
        DefaultTextStyle(
          style: iconTextStyle,
          child: CarrotIcon(
            glyph: widget.iconAfter!,
          ),
        ),
      );
    }

    _content = CarrotRow(
      gap: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void _initStyle() {
    _style = widget._getStyle(context);
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.carrotTheme.isAnimating ? Duration.zero : widget.duration;

    return RepaintBoundary(
      child: CarrotBounceTapBuilder(
        curve: widget.curve,
        duration: duration,
        scale: _style.tapScale,
        onTap: widget.onTap,
        builder: (context, isTapDown) => Focus(
          canRequestFocus: _canTap,
          focusNode: widget.focusNode,
          child: AnimatedContainer(
            curve: widget.curve,
            duration: duration,
            decoration: isTapDown ? _style.decorationActive : _style.decoration,
            child: Padding(
              padding: _padding,
              child: DefaultTextStyle(
                style: _style.textStyle.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                child: _content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarrotButtonStyle {
  final BoxDecoration decoration;
  final BoxDecoration decorationActive;
  final EdgeInsets? padding;
  final double tapScale;
  final TextStyle textStyle;
  final TextStyle textStyleActive;

  const _CarrotButtonStyle({
    required this.decoration,
    required this.decorationActive,
    required this.padding,
    required this.tapScale,
    required this.textStyle,
    required this.textStyleActive,
  });
}

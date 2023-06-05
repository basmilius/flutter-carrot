import 'package:flutter/widgets.dart';

import '../extension/extension.dart';
import '../ui/shadow.dart';
import 'primitive/primitive.dart';

enum CarrotCardMediaAlignment {
  start,
  end,
}

enum CarrotCardMediaAxis {
  horizontal,
  vertical,
}

class CarrotCard extends StatelessWidget {
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Widget child;
  final BoxConstraints? constraints;
  final Color? color;
  final List<BoxShadow> shadow;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const CarrotCard({
    super.key,
    required this.child,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.color,
    this.constraints,
    this.shadow = CarrotShadows.small,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  const CarrotCard.flat({
    super.key,
    required this.child,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.color,
    this.constraints,
    this.shadow = CarrotShadows.none,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    final carrotTheme = context.carrotTheme;
    final backgroundColor = color ?? carrotTheme.defaults.content;

    Border? border;

    if (borderWidth == null || borderWidth! > 0.0) {
      border = Border.all(
        color: borderColor ?? carrotTheme.gray[300].withOpacity(0.6),
        width: borderWidth ?? 0.5,
      );
    }

    return CarrotBounceTapBuilder.child(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        constraints: constraints,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius ?? carrotTheme.borderRadius,
          boxShadow: shadow,
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }

  factory CarrotCard.withMedia({
    required Widget media,
    Widget? child,
    CarrotCardMediaAlignment mediaAlignment = CarrotCardMediaAlignment.start,
    CarrotCardMediaAxis mediaAxis = CarrotCardMediaAxis.horizontal,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? color,
    List<BoxShadow> shadow = CarrotShadows.small,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
  }) {
    Widget? contentContainer;
    Widget mediaContainer;

    if (mediaAxis == CarrotCardMediaAxis.horizontal) {
      mediaContainer = Expanded(
        flex: 3,
        child: media,
      );

      if (child != null) {
        contentContainer = Expanded(
          flex: 6,
          child: child,
        );
      }
    } else {
      mediaContainer = AspectRatio(
        aspectRatio: 16 / 9,
        child: media,
      );

      contentContainer = child;
    }

    var children = (mediaAlignment == CarrotCardMediaAlignment.start ? [mediaContainer, contentContainer] : [contentContainer, mediaContainer]).whereType<Widget>().toList();

    return CarrotCard(
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      color: color,
      shadow: shadow,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: IntrinsicHeight(
        child: mediaAxis == CarrotCardMediaAxis.horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
      ),
    );
  }
}

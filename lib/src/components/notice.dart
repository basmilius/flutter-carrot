import 'package:flutter/widgets.dart';

import '../app/app.dart';
import '../ui/ui.dart';

import 'basic.dart';

class CarrotNotice extends StatelessWidget {
  final Widget? child;
  final CarrotColor? color;
  final bool isBordered;
  final bool isFluid;
  final bool isSerious;
  final List<BoxShadow> shadow;
  final Widget? icon;
  final Widget? message;
  final Widget? title;

  const CarrotNotice({
    super.key,
    this.color,
    this.child,
    this.isBordered = true,
    this.isFluid = false,
    this.isSerious = false,
    this.shadow = CarrotShadows.none,
    this.icon,
    this.message,
    this.title,
  });

  const CarrotNotice.serious({
    super.key,
    this.color,
    this.child,
    this.isBordered = true,
    this.isFluid = false,
    this.shadow = CarrotShadows.none,
    this.icon,
    this.message,
    this.title,
  }) : isSerious = true;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.carrotTheme;

    final palette = color ?? appTheme.primary;
    BorderRadius? radius;
    BorderRadius lineRadius;

    if (isFluid) {
      radius = null;
    } else {
      radius = appTheme.borderRadius;
    }

    if (isFluid) {
      lineRadius = const BorderRadius.only(
        topRight: Radius.circular(3),
        bottomRight: Radius.circular(3),
      );
    } else {
      lineRadius = const BorderRadius.all(Radius.circular(3));
    }

    Widget content = CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 3,
      children: [
        if (title != null) ...[
          DefaultTextStyle(
            style: appTheme.typography.headline6.copyWith(
              color: palette[appTheme.darkMode ? 500 : 600],
              height: 1.2,
            ),
            child: title!,
          ),
        ],
        if (message != null) ...[
          DefaultTextStyle(
            style: appTheme.typography.body1.copyWith(
              color: palette[appTheme.darkMode ? 300 : 900],
              fontSize: 15,
              height: 1.2,
            ),
            child: message!,
          ),
        ],
        if (child != null) child!,
      ],
    );

    Widget body;

    if (icon == null) {
      body = content;
    } else {
      body = CarrotRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        gap: 15,
        children: [
          DefaultTextStyle(
            style: appTheme.typography.body1.copyWith(
              color: palette[900],
              fontSize: 22,
              height: 1.4,
            ),
            child: icon!,
          ),
          Expanded(
            child: content,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: isFluid ? Border.symmetric(horizontal: BorderSide(color: palette[appTheme.darkMode ? 800 : 200])) : null,
        borderRadius: radius,
        color: isFluid || isSerious ? palette[appTheme.darkMode ? 900 : 100] : CarrotColors.transparent,
      ),
      child: Stack(
        children: [
          if (isBordered)
            Positioned(
              top: isSerious ? 15 : 6,
              left: isSerious ? 12 : 0,
              bottom: isSerious ? 15 : 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: lineRadius,
                  color: palette[500],
                ),
                child: const SizedBox(width: 3),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: isFluid || isSerious ? 15 : 3,
              left: isBordered
                  ? (isSerious ? 24 : 15)
                  : isFluid || isSerious
                      ? 15
                      : 0,
              right: isFluid || isSerious ? 15 : 0,
              bottom: isFluid || isSerious ? 15 : 3,
            ),
            child: body,
          ),
        ],
      ),
    );
  }

  factory CarrotNotice.withButton({
    required Widget button,
    required CarrotColor color,
    bool isBordered = true,
    bool isFluid = false,
    bool isSerious = false,
    List<BoxShadow> shadow = CarrotShadows.none,
    Widget? icon,
    Widget? message,
    Widget? title,
  }) {
    return CarrotNotice.withButtons(
      color: color,
      isBordered: isBordered,
      isFluid: isFluid,
      isSerious: isSerious,
      shadow: shadow,
      icon: icon,
      message: message,
      title: title,
      buttons: [button],
    );
  }

  factory CarrotNotice.withButtons({
    required List<Widget> buttons,
    required CarrotColor color,
    bool isBordered = true,
    bool isFluid = false,
    bool isSerious = false,
    List<BoxShadow> shadow = CarrotShadows.none,
    Widget? icon,
    Widget? message,
    Widget? title,
  }) {
    return CarrotNotice(
      color: color,
      isBordered: isBordered,
      isFluid: isFluid,
      isSerious: isSerious,
      shadow: shadow,
      icon: icon,
      message: message,
      title: title,
      child: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Wrap(
          direction: Axis.horizontal,
          runSpacing: 9,
          spacing: 9,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: buttons,
        ),
      ),
    );
  }
}
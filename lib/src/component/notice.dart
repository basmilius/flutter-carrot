import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../data/data.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';
import '../ui/ui.dart';
import 'column.dart';
import 'container.dart';
import 'row.dart';

part 'notice_theme.dart';

class CarrotNotice extends StatelessWidget {
  final Widget? child;
  final CarrotColor? color;
  final bool isContainer;
  final bool isFluid;
  final Widget? icon;
  final Widget? message;
  final EdgeInsets padding;
  final Widget? title;

  const CarrotNotice({
    super.key,
    this.color,
    this.child,
    this.isContainer = false,
    this.isFluid = false,
    this.icon,
    this.message,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 15,
    ),
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final noticeTheme = CarrotNoticeTheme.of(context);

    final palette = color ?? appTheme.primary;
    final radius = isFluid ? null : appTheme.borderRadius;

    Widget content = CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 3,
      children: [
        if (title != null) ...[
          DefaultTextStyle(
            style: appTheme.typography.headline6.copyWith(
              color: palette[noticeTheme.titleShade],
              height: 1.2,
            ),
            child: title!,
          ),
        ],
        if (message != null) ...[
          DefaultTextStyle(
            style: appTheme.typography.body1.copyWith(
              color: palette[noticeTheme.foregroundShade],
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
              color: palette[noticeTheme.iconShade],
              fontSize: 20,
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

    if (isContainer) {
      body = CarrotContainer(
        child: body,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: palette[noticeTheme.backgroundShade],
      ),
      child: Padding(
        padding: padding,
        child: body,
      ),
    );
  }

  factory CarrotNotice.withButton({
    required Widget button,
    required CarrotColor color,
    bool isFluid = false,
    Widget? icon,
    Widget? message,
    Widget? title,
  }) {
    return CarrotNotice.withButtons(
      color: color,
      isFluid: isFluid,
      icon: icon,
      message: message,
      title: title,
      buttons: [button],
    );
  }

  factory CarrotNotice.withButtons({
    required List<Widget> buttons,
    required CarrotColor color,
    bool isFluid = false,
    Widget? icon,
    Widget? message,
    Widget? title,
  }) {
    return CarrotNotice(
      color: color,
      isFluid: isFluid,
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

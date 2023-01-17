import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';
import '../data/data.dart';
import '../theme/theme.dart';

import '../ui/ui.dart';
import 'app_bar_buttons.dart';

part 'app_bar_theme.dart';

enum CarrotAppBarSystemOverlayStyle {
  auto,
  light,
  dark,
  disabled,
}

class CarrotAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Curve curve;
  final Duration duration;
  final bool isTransparent;
  final CarrotAppBarSystemOverlayStyle systemOverlayStyle;
  final List<Widget>? after;
  final List<Widget>? before;
  final Widget? title;

  @override
  Size get preferredSize => const Size.fromHeight(30.0);

  const CarrotAppBar({
    super.key,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 540),
    this.isTransparent = false,
    this.systemOverlayStyle = CarrotAppBarSystemOverlayStyle.auto,
    this.after,
    this.before,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final appBarTheme = CarrotAppBarTheme.of(context);
    final localDuration = context.carrotTheme.isAnimating ? Duration.zero : duration;

    switch (systemOverlayStyle) {
      case CarrotAppBarSystemOverlayStyle.auto:
        SystemChrome.setSystemUIOverlayStyle(isTransparent || appBarTheme.background == null || appBarTheme.background!.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
        break;

      case CarrotAppBarSystemOverlayStyle.light:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        break;

      case CarrotAppBarSystemOverlayStyle.dark:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        break;

      case CarrotAppBarSystemOverlayStyle.disabled:
        break;
    }

    return AnimatedContainer(
      curve: curve,
      duration: localDuration,
      decoration: isTransparent ? const BoxDecoration() : appBarTheme.decoration,
      child: AnimatedDefaultTextStyle(
        curve: curve,
        duration: localDuration,
        style: context.carrotTypography.body1.merge(appBarTheme.textStyle),
        child: _CarrotAppBarBody(
          after: after,
          before: before,
          title: title,
        ),
      ),
    );
  }
}

class _CarrotAppBarBody extends StatelessWidget {
  final List<Widget>? after;
  final List<Widget>? before;
  final Widget? title;

  const _CarrotAppBarBody({
    this.after,
    this.before,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.safeAreaReal.top,
        left: 15,
        right: 15,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (before != null)
              Align(
                alignment: Alignment.centerLeft,
                child: CarrotAppBarButtons(
                  alignment: MainAxisAlignment.start,
                  children: before!,
                ),
              ),
            if (title != null)
              Align(
                alignment: Alignment.center,
                child: title,
              ),
            if (after != null)
              Align(
                alignment: Alignment.centerRight,
                child: CarrotAppBarButtons(
                  alignment: MainAxisAlignment.end,
                  children: after!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

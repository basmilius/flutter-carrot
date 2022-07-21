import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';
import '../ui/shadow.dart';

import 'filter/backdrop_blur_container.dart';
import 'app_bar_buttons.dart';

enum CarrotAppBarSystemOverlayStyle {
  auto,
  light,
  dark,
  disabled,
}

class CarrotAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double blur;
  final Color color;
  final Curve curve;
  final Duration duration;
  final bool isTransparent;
  final List<BoxShadow> shadow;
  final CarrotAppBarSystemOverlayStyle systemOverlayStyle;
  final Color? textColor;
  final List<Shadow> textShadow;
  final List<Widget>? after;
  final List<Widget>? before;
  final Widget? title;

  @override
  Size get preferredSize => const Size.fromHeight(120.0);

  const CarrotAppBar({
    super.key,
    this.blur = 15.0,
    this.color = const Color(0xFFFFFFFF),
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 540),
    this.isTransparent = false,
    this.shadow = CarrotShadows.small,
    this.systemOverlayStyle = CarrotAppBarSystemOverlayStyle.auto,
    this.textColor,
    this.textShadow = const [],
    this.after,
    this.before,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    switch (systemOverlayStyle) {
      case CarrotAppBarSystemOverlayStyle.auto:
        SystemChrome.setSystemUIOverlayStyle(isTransparent || color.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
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

    return Stack(
      children: [
        if (blur > 0.0)
          Positioned.fill(
            child: CarrotAnimatedBackdropBlurContainer(
              curve: curve,
              duration: duration,
              sigmaX: isTransparent ? 0.0 : blur,
              sigmaY: isTransparent ? 0.0 : blur,
            ),
          ),
        Positioned.fill(
          child: AnimatedOpacity(
            curve: curve,
            duration: duration,
            opacity: isTransparent ? 0 : 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: color.darken(.025),
                    width: 1.0,
                  ),
                ),
                boxShadow: shadow,
                color: color,
              ),
            ),
          ),
        ),
        AnimatedDefaultTextStyle(
          curve: curve,
          duration: duration,
          style: context.carrotTheme.typography.body2.copyWith(
            color: textColor,
            shadows: textShadow,
          ),
          child: _CarrotAppBarBody(
            after: after,
            before: before,
            title: title,
          ),
        ),
      ],
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
        constraints: const BoxConstraints.expand(height: 72.0),
        child: Stack(
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

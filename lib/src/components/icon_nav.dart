import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';
import '../routing/routing.dart';
import '../ui/ui.dart';

import 'filter/filter.dart';
import 'primitive/primitive.dart';
import 'basic.dart';

typedef CarrotIconNavChanged = void Function(int);

enum CarrotIconNavRouterMode {
  push,
  replace,
}

class CarrotIconNav extends StatefulWidget {
  final double blur;
  final Color? color;
  final Curve curve;
  final Duration duration;
  final Color? iconColor;
  final Color? iconColorActive;
  final bool isLabelAlwaysVisible;
  final bool isSafeAreaAware;
  final List<CarrotIconNavItem> items;
  final Color? labelColor;
  final Color? labelColorActive;
  final List<BoxShadow> shadow;
  final int? activeIndex;
  final CarrotRouter? router;
  final CarrotIconNavRouterMode routerMode;
  final CarrotIconNavChanged? onChanged;

  const CarrotIconNav({
    super.key,
    required this.items,
    this.activeIndex,
    this.blur = .0,
    this.color,
    this.curve = CarrotCurves.swiftOutCurve,
    this.duration = const Duration(milliseconds: 390),
    this.iconColor,
    this.iconColorActive,
    this.isLabelAlwaysVisible = false,
    this.isSafeAreaAware = true,
    this.labelColor,
    this.labelColorActive,
    this.router,
    this.routerMode = CarrotIconNavRouterMode.push,
    this.shadow = CarrotShadows.small,
    this.onChanged,
  }) : assert((router != null && activeIndex == null) || (router == null && activeIndex != null), "CarrotIconNav must have either a router or an activeIndex.");

  @override
  createState() => _CarrotIconNav();
}

class _CarrotIconNav extends State<CarrotIconNav> {
  CarrotRouter? _router;

  int? get activeIndex => _router != null ? widget.items.indexWhere((item) => _router?.routerDelegate.matches.matches.first.subloc == item.route) : widget.activeIndex;

  @override
  void dispose() {
    _router?.removeListener(_onRouteChanged);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _router = widget.router;
    _router?.addListener(_onRouteChanged);
  }

  @override
  void didUpdateWidget(CarrotIconNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.router != oldWidget.router) {
      setState(() {
        _router = widget.router;
      });
    }
  }

  void _onItemTap(CarrotIconNavItem item, int index) {
    if (_router != null && item.route != null) {
      switch (widget.routerMode) {
        case CarrotIconNavRouterMode.push:
          _router!.push(item.route!);
          break;

        case CarrotIconNavRouterMode.replace:
          _router!.go(item.route!);
          break;
      }
    } else {
      widget.onChanged?.call(index);
    }
  }

  void _onRouteChanged() async {
    // todo(Bas): figure out why this is necessary
    await Future.delayed(const Duration(microseconds: 1));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CarrotBackdropBlurContainer(
      sigmaX: widget.blur,
      sigmaY: widget.blur,
      curve: widget.curve,
      decoration: BoxDecoration(
        boxShadow: widget.shadow,
        color: widget.color ?? context.carrotTheme.gray[0],
      ),
      duration: widget.duration,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: widget.isSafeAreaAware ? context.safeArea.bottom : 0,
      ),
      child: CarrotRow(
        gap: 3,
        children: [
          for (int index = 0; index < widget.items.length; ++index)
            _CarrotIconNavItem(
              iconNav: widget,
              isActive: index == activeIndex,
              item: widget.items.elementAt(index),
              onTap: () => _onItemTap(widget.items.elementAt(index), index),
            ),
        ],
      ),
    );
  }
}

class CarrotIconNavItem {
  final Widget icon;
  final Widget label;
  final String? route;

  const CarrotIconNavItem({
    required this.icon,
    required this.label,
    this.route,
  });
}

class _CarrotIconNavItem extends StatelessWidget {
  final CarrotIconNav iconNav;
  final CarrotIconNavItem item;
  final bool isActive;
  final GestureTapCallback onTap;

  const _CarrotIconNavItem({
    required this.iconNav,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = (isActive ? iconNav.iconColorActive : iconNav.iconColor) ?? context.carrotTheme.primary;
    Color labelColor = (isActive ? iconNav.labelColorActive : iconNav.labelColor) ?? (isActive ? context.carrotTheme.primary : context.carrotTheme.gray[400]);

    return Expanded(
      child: CarrotBounceTap(
        duration: const Duration(milliseconds: 240),
        scale: .9,
        onTap: onTap,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: CarrotColors.transparent,
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
              child: CarrotColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: 3,
                children: [
                  AnimatedSlide(
                    curve: iconNav.curve,
                    duration: iconNav.duration,
                    offset: isActive || iconNav.isLabelAlwaysVisible ? Offset.zero : const Offset(0, .5),
                    child: AnimatedDefaultTextStyle(
                      curve: iconNav.curve,
                      duration: iconNav.duration,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 20,
                      ),
                      child: item.icon,
                    ),
                  ),
                  AnimatedSlide(
                    curve: iconNav.curve,
                    duration: iconNav.duration,
                    offset: isActive || iconNav.isLabelAlwaysVisible ? Offset.zero : const Offset(0, 1),
                    child: AnimatedOpacity(
                      curve: iconNav.curve,
                      duration: iconNav.duration,
                      opacity: isActive || iconNav.isLabelAlwaysVisible ? 1 : 0,
                      child: AnimatedDefaultTextStyle(
                        curve: iconNav.curve,
                        duration: iconNav.duration,
                        style: context.carrotTheme.typography.body1.copyWith(
                          color: labelColor,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                        child: item.label,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

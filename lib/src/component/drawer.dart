import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../extension/extension.dart';
import 'primitive/primitive.dart';
import 'row.dart';
import 'scroll/scroll.dart';
import 'sliver/sliver.dart';

typedef CarrotDrawerMenuItemTap = void Function(int);

class CarrotDrawer extends StatelessWidget {
  final Widget? child;
  final Widget? footer;
  final Widget? header;
  final Color? backgroundColor;

  const CarrotDrawer({
    super.key,
    this.child,
    this.footer,
    this.header,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    var background = backgroundColor ?? context.carrotTheme.defaults.content;

    Widget contentSliver;

    if (header == null && footer == null && child != null) {
      contentSliver = SliverPadding(
        padding: context.safeAreaReal,
        sliver: child,
      );
    } else if (child != null) {
      contentSliver = child!;
    } else {
      contentSliver = const SliverFillRemaining(
        hasScrollBody: false,
      );
    }

    return RepaintBoundary(
      child: AnimatedContainer(
        curve: CarrotCurves.swiftOutCurve,
        duration: const Duration(
          milliseconds: 300,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border(
            right: BorderSide(width: 1, color: background.darken(.0125)),
          ),
        ),
        child: CarrotScrollbar(
          child: CustomScrollView(
            physics: const CarrotBouncingScrollPhysics(),
            slivers: [
              if (header != null) ...[
                CarrotSliverPinnedHeader(
                  child: header!,
                ),
              ],
              contentSliver,
              if (footer != null) ...[
                SliverFillRemaining(
                  fillOverscroll: false,
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      footer!,
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CarrotDrawerMenu extends StatelessWidget {
  final int activeIndex;
  final List<CarotDrawerMenuObject> items;

  const CarrotDrawerMenu({
    super.key,
    this.activeIndex = 0,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => items[index] is CarrotDrawerMenuItem
            ? _CarrotDrawerMenuItem(
                item: items[index] as CarrotDrawerMenuItem,
              )
            : const _CarrotDrawerMenuSeparator(),
        childCount: items.length,
      ),
    );
  }
}

abstract class CarotDrawerMenuObject {
  const CarotDrawerMenuObject();
}

class CarrotDrawerMenuItem extends CarotDrawerMenuObject {
  final double gap;
  final Widget? icon;
  final Widget? iconAfter;
  final Widget label;
  final GestureTapCallback? onTap;

  const CarrotDrawerMenuItem({
    required this.label,
    this.gap = 24.0,
    this.icon,
    this.iconAfter,
    this.onTap,
  });
}

class CarrotDrawerMenuSeparator extends CarotDrawerMenuObject {
  const CarrotDrawerMenuSeparator();
}

class _CarrotDrawerMenuItem extends StatelessWidget {
  final CarrotDrawerMenuItem item;

  const _CarrotDrawerMenuItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotBounceTapBuilder.child(
      scale: .96,
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 18,
        ),
        child: CarrotRow(
          gap: item.gap,
          children: [
            if (item.icon != null) item.icon!,
            Expanded(
              child: item.label,
            ),
            if (item.iconAfter != null) item.iconAfter!,
          ],
        ),
      ),
    );
  }
}

class _CarrotDrawerMenuSeparator extends StatelessWidget {
  const _CarrotDrawerMenuSeparator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 21.0,
    );
  }
}

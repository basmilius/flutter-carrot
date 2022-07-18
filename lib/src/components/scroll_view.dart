import 'package:flutter/widgets.dart';

import 'scroll/scroll.dart';

class CarrotScrollView extends StatelessWidget {
  final Widget child;
  final bool isReversed;
  final bool isScrollbarAlwaysVisible;
  final bool isScrollbarVisible;
  final EdgeInsets? padding;
  final ScrollPhysics physics;
  final ScrollController scrollController;
  final EdgeInsets scrollPadding;

  const CarrotScrollView({
    super.key,
    required this.child,
    required this.scrollController,
    this.isReversed = false,
    this.isScrollbarAlwaysVisible = false,
    this.isScrollbarVisible = true,
    this.padding,
    this.physics = const CarrotBouncingScrollPhysics(),
    this.scrollPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      physics: physics,
      reverse: isReversed,
      child: child,
    );

    return RepaintBoundary(
      child: !isScrollbarVisible
          ? scrollView
          : CarrotScrollbar(
              controller: scrollController,
              thumbVisibility: isScrollbarAlwaysVisible,
              padding: scrollPadding,
              child: scrollView,
            ),
    );
  }
}

class CarrotPrimaryScrollView extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;

  const CarrotPrimaryScrollView({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

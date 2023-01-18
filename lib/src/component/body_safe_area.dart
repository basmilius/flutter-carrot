import 'package:flutter/widgets.dart';

import '../extension/extension.dart';

class CarrotBodySafeArea extends StatelessWidget {
  final Widget child;
  final bool contentBehindAppBar;
  final bool contentBehindBottomBar;
  final EdgeInsets extraPadding;

  const CarrotBodySafeArea({
    super.key,
    required this.child,
    this.contentBehindAppBar = false,
    this.contentBehindBottomBar = false,
    this.extraPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.safeAreaReal.add(extraPadding);

    return Padding(
      padding: padding.add(EdgeInsets.only(
        top: !contentBehindAppBar ? context.carrotScaffold.appBarSize.height - context.safeAreaReal.top : 0,
        bottom: !contentBehindBottomBar ? context.carrotScaffold.bottomBarSize.height - context.safeAreaReal.bottom : 0,
      )),
      child: child,
    );
  }
}

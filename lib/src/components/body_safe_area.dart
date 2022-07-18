import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';

class CarrotBodySafeArea extends StatelessWidget {
  final Widget child;
  final bool contentBehindAppBar;
  final EdgeInsets extraPadding;

  const CarrotBodySafeArea({
    super.key,
    required this.child,
    this.contentBehindAppBar = false,
    this.extraPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = context.safeAreaReal.add(extraPadding);

    return Padding(
      padding: padding.add(EdgeInsets.only(
        top: !contentBehindAppBar ? context.carrotScaffold.appBarSize.height - context.safeAreaReal.top : 0,
      )),
      child: child,
    );
  }
}

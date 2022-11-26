import 'package:flutter/widgets.dart';

import '../app/app.dart';
import 'basic.dart';

class CarrotCardContent extends StatelessWidget {
  final Widget? body;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final double? gap;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets padding;
  final Widget? title;

  const CarrotCardContent({
    super.key,
    this.body,
    this.children = const [],
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.gap,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 21,
      vertical: 18,
    ),
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CarrotColumn(
        crossAxisAlignment: crossAxisAlignment,
        gap: gap,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (title != null) ...[
            DefaultTextStyle(
              style: context.carrotTypography.headline4,
              child: title!,
            ),
            if (body != null) ...[
              const SizedBox(height: 9),
            ],
          ],
          if (body != null) body!,
          ...children,
        ],
      ),
    );
  }
}

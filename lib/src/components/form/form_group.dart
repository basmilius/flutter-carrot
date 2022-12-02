import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import '../basic.dart';

class CarrotFormGroup extends StatelessWidget {
  final Widget child;
  final bool optional;
  final Widget label;

  const CarrotFormGroup({
    super.key,
    required this.child,
    required this.label,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    final carrotTheme = context.carrotTheme;

    return CarrotColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      gap: 9,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CarrotRow(
          gap: 9,
          children: [
            DefaultTextStyle(
              style: carrotTheme.typography.headline6,
              child: label,
            ),
            if (optional)
              DefaultTextStyle(
                style: carrotTheme.typography.body2,
                child: const Text('(optional)'), // todo(Bas): translations
              ),
          ],
        ),
        child,
      ],
    );
  }
}

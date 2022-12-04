import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import '../column.dart';
import 'form_group_addition.dart';

class CarrotFormGroup extends StatelessWidget {
  final Widget child;
  final Widget? error;
  final Widget? hint;
  final Widget label;
  final bool optional;

  const CarrotFormGroup({
    super.key,
    required this.child,
    required this.label,
    this.error,
    this.hint,
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
        DefaultTextStyle(
          style: carrotTheme.typography.headline6.copyWith(
            fontSize: 14.0,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                if (label is Text)
                  TextSpan(
                    text: (label as Text).data,
                  ),
                if (label is! Text)
                  WidgetSpan(
                    child: label,
                  ),
                if (optional)
                  TextSpan(
                    text: ' ${context.carrotStrings.formOptional}',
                    style: carrotTheme.typography.body2.copyWith(
                      fontSize: 14.0,
                    ),
                  ),
              ],
            ),
            style: carrotTheme.typography.headline6.copyWith(
              fontSize: 14.0,
            ),
          ),
        ),
        child,
        if (error != null)
          CarrotFormGroupAddition(
            color: carrotTheme.error,
            icon: 'circle-exclamation',
            message: error!,
          ),
        if (hint != null)
          CarrotFormGroupAddition(
            icon: 'circle-info',
            message: hint!,
          ),
      ],
    );
  }
}

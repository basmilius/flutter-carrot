import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import '../../theme/theme.dart';

class CarrotFormField extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final double minHeight;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CarrotFormField({
    super.key,
    required this.child,
    this.enabled = true,
    this.minHeight = 45,
    this.padding,
    this.onTap,
  }) : assert(minHeight >= 0);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return Semantics(
      enabled: enabled,
      onTap: onTap,
      child: ExcludeFocus(
        excluding: !enabled,
        child: IgnorePointer(
          ignoring: !enabled,
          child: ClipRRect(
            borderRadius: appTheme.borderRadius,
            child: Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(
                minHeight: minHeight,
              ),
              decoration: BoxDecoration(
                border: formFieldTheme.border,
                borderRadius: appTheme.borderRadius,
                color: formFieldTheme.backgroundColor,
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

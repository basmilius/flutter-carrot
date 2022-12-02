import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import '../../theme/theme.dart';

class CarrotFormField extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CarrotFormField({
    super.key,
    required this.child,
    this.enabled = true,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final textFieldTheme = CarrotTextFieldTheme.of(context);

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
              constraints: const BoxConstraints(
                minHeight: 45,
              ),
              decoration: BoxDecoration(
                border: textFieldTheme.border,
                borderRadius: appTheme.borderRadius,
                color: textFieldTheme.backgroundColor,
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

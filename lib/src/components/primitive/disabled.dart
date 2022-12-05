import 'package:flutter/widgets.dart';

class CarrotDisabled extends StatelessWidget {
  final Widget child;
  final bool disabled;

  const CarrotDisabled({
    super.key,
    required this.child,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: disabled,
      child: ExcludeSemantics(
        excluding: disabled,
        child: IgnorePointer(
          ignoring: disabled,
          child: child,
        ),
      ),
    );
  }
}

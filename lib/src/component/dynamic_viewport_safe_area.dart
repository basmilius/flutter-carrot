import 'package:flutter/widgets.dart';

class CarrotDynamicViewportSafeArea extends StatelessWidget {
  final Widget child;

  const CarrotDynamicViewportSafeArea({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: child,
    );
  }
}

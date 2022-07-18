import 'package:flutter/widgets.dart';

class CarrotContainer extends StatelessWidget {
  final Widget child;
  final double width;

  const CarrotContainer({
    super.key,
    required this.child,
    this.width = 810,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: width,
        ),
        child: child,
      ),
    );
  }
}

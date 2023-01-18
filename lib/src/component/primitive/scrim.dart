import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';

class CarrotScrim extends StatelessWidget {
  final Color? color;
  final String label;
  final double opacity;
  final VoidCallback onTap;

  const CarrotScrim({
    super.key,
    required this.color,
    required this.onTap,
    this.label = "Tap to close",
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlockSemantics(
        child: ExcludeSemantics(
          excluding: false,
          child: GestureDetector(
            onTap: onTap,
            child: Semantics(
              label: label,
              child: MouseRegion(
                child: AnimatedOpacity(
                  curve: CarrotCurves.springOverDamped,
                  duration: const Duration(milliseconds: 540),
                  opacity: opacity,
                  child: Container(
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

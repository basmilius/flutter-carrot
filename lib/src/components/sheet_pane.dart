import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import '../ui/ui.dart';

class CarrotSheetPane extends StatelessWidget {
  final Widget child;
  final bool isHandleVisible;

  const CarrotSheetPane({
    super.key,
    required this.child,
    required this.isHandleVisible,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: appTheme.radius * 2,
        ),
        boxShadow: CarrotShadows.xl,
        color: appTheme.defaults.content,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: appTheme.radius * 2,
        ),
        child: IntrinsicHeight(
          child: _CarrotSheetPaneStack(
            isHandleVisible: isHandleVisible,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _CarrotSheetPaneStack extends StatelessWidget {
  final Widget child;
  final bool isHandleVisible;

  const _CarrotSheetPaneStack({
    required this.child,
    required this.isHandleVisible,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;

    if (!isHandleVisible) {
      return child;
    }

    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 30,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    appTheme.defaults.content,
                    appTheme.defaults.content.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          height: 6,
          width: 39,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: appTheme.gray[200],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

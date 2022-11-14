import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';
import 'behavior.dart';
import 'controller.dart';
import 'default_sheet_controller.dart';
import 'fit.dart';
import 'physics.dart';
import 'resizable.dart';
import 'route.dart';
import 'scrollable.dart';
import 'viewport.dart';

class CarrotSheet extends StatelessWidget {
  final Widget child;
  final Clip? clipBehavior;
  final CarrotSheetController? controller;
  final CarrotSheetFit fit;
  final double? initialExtent;
  final double? maxExtent;
  final double? minExtent;
  final double minInteractionExtent;
  final double? minResizableExtent;
  final EdgeInsets padding;
  final CarrotSheetPhysics? physics;
  final bool resizable;

  const CarrotSheet({
    super.key,
    required this.child,
    this.clipBehavior,
    this.controller,
    this.fit = CarrotSheetFit.loose,
    this.initialExtent,
    this.maxExtent,
    this.minExtent,
    this.minInteractionExtent = 21.0,
    this.minResizableExtent,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.resizable = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? CarrotSheetDefaultController.of(context);
    final initialExtent = this.initialExtent?.clamp(minExtent ?? .0, maxExtent ?? double.infinity);

    return CarrotSheetScrollable(
      axisDirection: AxisDirection.down,
      controller: effectiveController,
      initialExtent: initialExtent,
      minInteractionExtent: minInteractionExtent,
      physics: physics,
      scrollBehavior: CarrotSheetBehavior(),
      viewportBuilder: (context, offset) => _CarrotSheetDefaultScrollController(
        child: CarrotSheetViewport(
          axisDirection: AxisDirection.down,
          clipBehavior: Clip.antiAlias,
          fit: fit,
          maxExtent: maxExtent,
          minExtent: minExtent,
          offset: offset,
          child: Padding(
            padding: padding,
            child: CarrotSheetResizableChild(
              minExtent: minResizableExtent ?? .0,
              offset: offset,
              resizable: resizable,
              child: Builder(
                key: const Key('carrot:sheet:child'),
                builder: (_) => child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static show({
    required WidgetBuilder builder,
    required BuildContext context,
    Color? barrierColor,
    CarrotSheetFit fit = CarrotSheetFit.expand,
    double initialExtent = 1,
    String? label,
    CarrotSheetPhysics? physics,
    List<double>? stops,
    double willPopThreshold = .8,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      CarrotSheetRoute(
        barrierColor: barrierColor ?? context.carrotTheme.defaults.scrim,
        builder: builder,
        fit: fit,
        initialExtent: initialExtent,
        label: label,
        physics: physics,
        stops: stops,
        willPopThreshold: willPopThreshold,
      ),
    );
  }

  static CarrotSheetScrollableState? of(BuildContext context) {
    return CarrotSheetScrollable.of(context);
  }
}

class _CarrotSheetDefaultScrollController extends StatelessWidget {
  final Widget child;

  const _CarrotSheetDefaultScrollController({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: CarrotSheetScrollable.of(context)!.position.scrollController,
      child: child,
    );
  }
}

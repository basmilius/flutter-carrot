import 'package:flutter/widgets.dart';

import 'controller.dart';

typedef CarrotSheetControllerCallback = void Function(CarrotSheetController);

class CarrotSheetDefaultController extends StatefulWidget {
  final Widget child;
  final CarrotSheetControllerCallback? onCreated;

  const CarrotSheetDefaultController({
    super.key,
    required this.child,
    this.onCreated,
  });

  @override
  createState() => CarrotSheetDefaultControllerState();

  static CarrotSheetController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CarrotSheetInheritedController>()?.controller;
  }
}

class CarrotSheetDefaultControllerState extends State<CarrotSheetDefaultController> {
  late final CarrotSheetController controller = CarrotSheetController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.onCreated?.call(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _CarrotSheetInheritedController(
      controller: controller,
      child: widget.child,
    );
  }
}

class _CarrotSheetInheritedController extends InheritedWidget {
  final CarrotSheetController controller;

  const _CarrotSheetInheritedController({
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(_CarrotSheetInheritedController oldWidget) {
    return false;
  }
}

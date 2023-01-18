import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CarrotSheetMinimumInteractionZone extends SingleChildRenderObjectWidget {
  final AxisDirection direction;
  final double extent;

  const CarrotSheetMinimumInteractionZone({
    super.key,
    required super.child,
    required this.direction,
    required this.extent,
  });

  @override
  CarrotSheetMinimumInteractionZoneRenderObject createRenderObject(BuildContext context) {
    return CarrotSheetMinimumInteractionZoneRenderObject(direction, extent);
  }

  @override
  void updateRenderObject(BuildContext context, CarrotSheetMinimumInteractionZoneRenderObject renderObject) {
    renderObject
      ..direction = direction
      ..extent = extent;
  }
}

class CarrotSheetMinimumInteractionZoneRenderObject extends RenderProxyBox {
  AxisDirection _direction;
  double _extent;

  AxisDirection get direction => _direction;

  double get extent => _extent;

  set direction(AxisDirection value) {
    if (value == _direction) {
      return;
    }

    _direction = value;
  }

  set extent(double value) {
    if (value == _extent) {
      return;
    }

    _extent = value;
  }

  CarrotSheetMinimumInteractionZoneRenderObject(AxisDirection direction, double extent)
      : _direction = direction,
        _extent = extent;

  @override
  bool hitTestSelf(Offset position) {
    Rect minInteractionZone;

    switch (direction) {
      case AxisDirection.up:
        minInteractionZone = Rect.fromLTRB(0, size.height - extent, size.width, size.height);
        break;

      case AxisDirection.down:
        minInteractionZone = Rect.fromLTRB(0, 0, size.width, extent);
        break;

      case AxisDirection.right:
        minInteractionZone = Rect.fromLTRB(0, 0, extent, size.height);
        break;

      case AxisDirection.left:
        minInteractionZone = Rect.fromLTRB(size.width - extent, 0, size.width, size.height);
        break;
    }

    return minInteractionZone.contains(position);
  }
}

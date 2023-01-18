import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CarrotSheetResizableChild extends SingleChildRenderObjectWidget {
  final double minExtent;
  final bool resizable;
  final ViewportOffset offset;

  const CarrotSheetResizableChild({
    super.key,
    required super.child,
    required this.offset,
    required this.resizable,
    this.minExtent = 0,
  });

  @override
  CarrotSheetResizableChildRenderObject createRenderObject(BuildContext context) {
    return CarrotSheetResizableChildRenderObject(
      minExtent: minExtent,
      offset: offset,
      resizable: resizable,
    );
  }

  @override
  void updateRenderObject(BuildContext context, CarrotSheetResizableChildRenderObject renderObject) {
    renderObject
      ..minExtent = minExtent
      ..offset = offset
      ..resizable = resizable;
  }
}

class CarrotSheetResizableChildRenderObject extends RenderShiftedBox {
  double _minExtent;
  ViewportOffset _offset;
  bool _resizable;

  double get minExtent => _minExtent;

  ViewportOffset get offset => _offset;

  bool get resizable => _resizable;

  set minExtent(double value) {
    if (value == _minExtent) {
      return;
    }

    _minExtent = value;

    if (!resizable) {
      return;
    }

    markNeedsLayout();
  }

  set offset(ViewportOffset value) {
    if (value == _offset) {
      return;
    }

    if (attached) {
      _offset.removeListener(_hasScrolled);
    }

    _offset = value;

    if (attached) {
      _offset.addListener(_hasScrolled);
    }

    if (!resizable) {
      return;
    }

    markNeedsLayout();
  }

  set resizable(bool value) {
    if (value == _resizable) {
      return;
    }

    _resizable = value;
    markNeedsLayout();
  }

  CarrotSheetResizableChildRenderObject({
    required double minExtent,
    required ViewportOffset offset,
    RenderBox? child,
    bool resizable = true,
  })  : _offset = offset,
        _minExtent = minExtent,
        _resizable = resizable,
        super(child);

  void _hasScrolled() {
    if (!resizable) {
      return;
    }

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _offset.addListener(_hasScrolled);
  }

  @override
  void detach() {
    _offset.removeListener(_hasScrolled);
    super.detach();
  }

  @override
  void performLayout() {
    final childParentData = child!.parentData! as BoxParentData;

    if (!resizable) {
      child!.layout(
        constraints,
        parentUsesSize: true,
      );

      size = child!.size;
      childParentData.offset = Offset.zero;
      return;
    }

    final extent = math.max(_offset.pixels, minExtent);

    child!.layout(
      BoxConstraints(
        maxHeight: extent,
        minHeight: extent,
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
      ),
      parentUsesSize: true,
    );

    if (!constraints.hasTightHeight) {
      size = Size(child!.size.width, constraints.constrainHeight(child!.size.height));
      childParentData.offset = Offset.zero;
    } else {
      size = constraints.biggest;
      childParentData.offset = Offset.zero;
    }
  }
}

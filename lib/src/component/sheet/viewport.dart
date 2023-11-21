import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import 'fit.dart';

class CarrotSheetViewport extends SingleChildRenderObjectWidget {
  final AxisDirection axisDirection;
  final Clip clipBehavior;
  final CarrotSheetFit fit;
  final double? maxExtent;
  final double? minExtent;
  final ViewportOffset offset;

  const CarrotSheetViewport({
    super.key,
    super.child,
    required this.clipBehavior,
    required this.fit,
    required this.offset,
    this.axisDirection = AxisDirection.down,
    this.maxExtent,
    this.minExtent,
  });

  @override
  CarrotSheetRenderViewport createRenderObject(BuildContext context) {
    return CarrotSheetRenderViewport(
      axisDirection: axisDirection,
      clipBehavior: clipBehavior,
      fit: fit,
      maxExtent: maxExtent,
      minExtent: minExtent,
      offset: offset,
    );
  }

  @override
  void updateRenderObject(BuildContext context, CarrotSheetRenderViewport renderObject) {
    renderObject
      ..axisDirection = axisDirection
      ..clipBehavior = clipBehavior
      ..fit = fit
      ..maxExtent = maxExtent
      ..minExtent = minExtent
      ..offset = offset;
  }
}

class CarrotSheetRenderViewport extends RenderBox with RenderObjectWithChildMixin<RenderBox> implements RenderAbstractViewport {
  final LayerHandle<ClipRectLayer> _clipRectLayer = LayerHandle<ClipRectLayer>();

  AxisDirection _axisDirection;
  double _cacheExtent;
  Clip _clipBehavior;
  CarrotSheetFit _fit;
  double? _maxExtent;
  double? _minExtent;
  ViewportOffset _offset;
  double? _childExtentBeforeOverflow;
  bool _isOverflow = false;

  double get _maxScrollExtent {
    assert(hasSize);

    if (_childExtentBeforeOverflow != null) {
      return _childExtentBeforeOverflow!;
    }

    if (child == null) {
      return .0;
    }

    return axis == Axis.horizontal ? math.max(.0, child!.size.width - size.width) : math.max(.0, child!.size.height);
  }

  double get _minScrollExtent {
    assert(hasSize);
    return minExtent ?? .0;
  }

  Offset get _paintOffset => _paintOffsetForPosition(offset.pixels);

  double get _viewportExtent {
    assert(hasSize);
    return axis == Axis.horizontal ? size.width : size.height;
  }

  Axis get axis => axisDirectionToAxis(_axisDirection);

  AxisDirection get axisDirection => _axisDirection;

  double get cacheExtent => _cacheExtent;

  Clip get clipBehavior => _clipBehavior;

  CarrotSheetFit get fit => _fit;

  bool get isOverflow => _isOverflow;

  double? get maxExtent => _maxExtent;

  double? get minExtent => _minExtent;

  ViewportOffset get offset => _offset;

  @override
  bool get isRepaintBoundary => true;

  set axisDirection(AxisDirection value) {
    if (value == _axisDirection) {
      return;
    }

    _axisDirection = value;
    markNeedsLayout();
  }

  set cacheExtent(double value) {
    if (value == _cacheExtent) {
      return;
    }

    _cacheExtent = value;
    markNeedsLayout();
  }

  set clipBehavior(Clip value) {
    if (value == _clipBehavior) {
      return;
    }

    _clipBehavior = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  set fit(CarrotSheetFit value) {
    if (value == _fit) {
      return;
    }

    _fit = value;
    markNeedsLayout();
  }

  set maxExtent(double? value) {
    if (value == _maxExtent) {
      return;
    }

    _maxExtent = value;
    markNeedsLayout();
  }

  set minExtent(double? value) {
    if (value == _minExtent) {
      return;
    }

    _minExtent = value;
    markNeedsLayout();
  }

  set offset(ViewportOffset value) {
    if (value == _offset) {
      return;
    }

    if (attached) {
      _offset.removeListener(_hasDragged);
    }

    _offset = value;

    if (attached) {
      _offset.addListener(_hasDragged);
    }

    markNeedsLayout();
  }

  CarrotSheetRenderViewport({
    required Clip clipBehavior,
    required ViewportOffset offset,
    AxisDirection axisDirection = AxisDirection.down,
    double cacheExtent = RenderAbstractViewport.defaultCacheExtent,
    RenderBox? child,
    CarrotSheetFit fit = CarrotSheetFit.expand,
    double? maxExtent,
    double? minExtent,
  })  : _axisDirection = axisDirection,
        _cacheExtent = cacheExtent,
        _clipBehavior = clipBehavior,
        _fit = fit,
        _maxExtent = maxExtent,
        _minExtent = minExtent,
        _offset = offset;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _offset.addListener(_hasDragged);
  }

  @override
  void detach() {
    super.detach();
    _offset.removeListener(_hasDragged);
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ParentData) {
      child.parentData = ParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return child == null ? constraints.smallest : constraints.biggest;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.maxHeight;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return constraints.maxHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return constraints.maxHeight;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final paintOffset = _paintOffset;
    transform.translate(paintOffset.dx, paintOffset.dy);
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject? child) {
    if (child != null && _shouldClipAtPaintOffset(_paintOffset)) {
      return Offset.zero & size;
    }

    return null;
  }

  @override
  Rect describeSemanticsClip(RenderObject child) {
    switch (axis) {
      case Axis.horizontal:
        return Rect.fromLTRB(
          semanticBounds.left - cacheExtent,
          semanticBounds.top,
          semanticBounds.right + cacheExtent,
          semanticBounds.bottom,
        );

      case Axis.vertical:
        return Rect.fromLTRB(
          semanticBounds.left,
          semanticBounds.top - cacheExtent,
          semanticBounds.right,
          semanticBounds.bottom + cacheExtent,
        );
    }
  }

  @override
  RevealedOffset getOffsetToReveal(
    RenderObject target,
    double alignment, {
    Axis? axis,
    Rect? rect,
  }) {
    rect ??= target.paintBounds;

    if (target is! RenderBox) {
      return RevealedOffset(
        offset: offset.pixels,
        rect: rect,
      );
    }

    final targetBox = target;
    final transform = targetBox.getTransformTo(child);
    final bounds = MatrixUtils.transformRect(transform, rect);
    final contentSize = child!.size;

    final double leadingScrollOffset;
    final double targetMainAxisExtent;
    final double mainAxisExtent;

    switch (axisDirection) {
      case AxisDirection.up:
        mainAxisExtent = size.height;
        leadingScrollOffset = contentSize.height - bounds.bottom;
        targetMainAxisExtent = bounds.height;
        break;

      case AxisDirection.right:
        mainAxisExtent = size.width;
        leadingScrollOffset = bounds.left;
        targetMainAxisExtent = bounds.width;
        break;

      case AxisDirection.down:
        mainAxisExtent = size.height;
        leadingScrollOffset = bounds.top;
        targetMainAxisExtent = bounds.height;
        break;

      case AxisDirection.left:
        mainAxisExtent = size.width;
        leadingScrollOffset = contentSize.width - bounds.right;
        targetMainAxisExtent = bounds.width;
        break;
    }

    final targetOffset = leadingScrollOffset - (mainAxisExtent - targetMainAxisExtent) * alignment;
    final targetRect = bounds.shift(_paintOffsetForPosition(targetOffset));

    return RevealedOffset(
      offset: targetOffset,
      rect: targetRect,
    );
  }

  @override
  bool hitTestChildren(
    BoxHitTestResult result, {
    required Offset position,
  }) {
    if (child == null) {
      return false;
    }

    return result.addWithPaintOffset(
      hitTest: (result, transformed) {
        assert(transformed == position + -_paintOffset);
        return child!.hitTest(result, position: transformed);
      },
      offset: _paintOffset,
      position: position,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }

    final paintOffset = _paintOffset;

    void paintContents(PaintingContext context, Offset offset) {
      context.paintChild(child!, offset + paintOffset);
    }

    if (_shouldClipAtPaintOffset(paintOffset) && clipBehavior != Clip.none) {
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        paintContents,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      paintContents(context, offset);
    }
  }

  @override
  void performLayout() {
    final constraints = this.constraints;

    if (child == null) {
      size = constraints.smallest;
    } else {
      final expand = fit == CarrotSheetFit.expand;
      final maxExtent = this.maxExtent ?? constraints.maxHeight;
      double maxHeight = maxExtent.clamp(.0, constraints.maxHeight);
      double minHeight = expand ? maxHeight : .0;

      if (_isOverflow) {
        final overflowHeight = _childExtentBeforeOverflow! + offset.pixels;
        maxHeight = overflowHeight;
        minHeight = overflowHeight;
      }

      final childConstraints = BoxConstraints(
        minHeight: minHeight,
        maxHeight: maxHeight,
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
      );

      child!.layout(childConstraints, parentUsesSize: true);
      size = constraints.biggest;
    }

    offset.applyViewportDimension(_viewportExtent);
    offset.applyContentDimensions(_minScrollExtent, _maxScrollExtent);
  }

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Curve curve = CarrotCurves.swiftOutCurve,
    Duration duration = Duration.zero,
  }) {
    return;
  }

  void _hasDragged() {
    if (!_isOverflow && offset.pixels > child!.size.height) {
      _childExtentBeforeOverflow ??= child!.size.height;
      _isOverflow = true;
      markNeedsLayout();
    } else if (_isOverflow && offset.pixels < _childExtentBeforeOverflow!) {
      _childExtentBeforeOverflow = null;
      _isOverflow = false;
      markNeedsLayout();
    }

    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Offset _paintOffsetForPosition(double position) {
    switch (axisDirection) {
      case AxisDirection.up:
        return Offset(.0, position = child!.size.height + size.height);

      case AxisDirection.down:
        return Offset(.0, -position + size.height);

      case AxisDirection.left:
        return Offset(position - child!.size.width + size.width, .0);

      case AxisDirection.right:
        return Offset(-position, .0);
    }
  }

  bool _shouldClipAtPaintOffset(Offset paintOffset) {
    assert(child != null);

    return paintOffset.dx < 0 || paintOffset.dy < 0 || paintOffset.dx + child!.size.width > size.width || paintOffset.dy + child!.size.height > size.height;
  }
}

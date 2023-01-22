import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CarrotSliverClip extends SingleChildRenderObjectWidget {
  final bool clipOverlap;

  const CarrotSliverClip({
    super.key,
    required super.child,
    this.clipOverlap = true,
  });

  @override
  CarrotSliverClipRenderer createRenderObject(BuildContext context) {
    return CarrotSliverClipRenderer(
      clipOverlap: clipOverlap,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant CarrotSliverClipRenderer renderObject) {
    renderObject.clipOverlap = clipOverlap;
  }
}

class CarrotSliverClipRenderer extends RenderProxySliver {
  bool _clipOverlap;
  Rect? _clipRect;

  bool get clipOverlap => _clipOverlap;

  set clipOverlap(bool value) {
    if (_clipOverlap == value) {
      return;
    }

    _clipOverlap = value;
    markNeedsPaint();
  }

  Rect? get clipRect => _clipRect;

  CarrotSliverClipRenderer({
    required bool clipOverlap,
  }) : _clipOverlap = clipOverlap;

  Rect calculateClipRect() {
    final axisDirection = applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection);
    final overlapCorrection = (clipOverlap ? constraints.overlap : .0);

    switch (axisDirection) {
      case AxisDirection.up:
        return Rect.fromLTWH(
          0,
          0,
          constraints.crossAxisExtent,
          geometry!.paintExtent - overlapCorrection,
        );

      case AxisDirection.down:
        return Rect.fromLTWH(
          0,
          geometry!.paintOrigin + overlapCorrection,
          constraints.crossAxisExtent,
          geometry!.paintExtent - overlapCorrection,
        );

      case AxisDirection.left:
        return Rect.fromLTWH(
          0,
          0,
          geometry!.paintExtent - overlapCorrection,
          constraints.crossAxisExtent,
        );

      case AxisDirection.right:
        return Rect.fromLTWH(
          geometry!.paintOrigin + overlapCorrection,
          0,
          geometry!.paintExtent - overlapCorrection,
          constraints.crossAxisExtent,
        );
    }
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    final overlapCorrection = (clipOverlap ? constraints.overlap : .0);

    return child != null &&
        child!.geometry!.hitTestExtent > 0 &&
        mainAxisPosition > (geometry!.paintOrigin + overlapCorrection) &&
        mainAxisPosition < (geometry!.paintOrigin + overlapCorrection + (constraints.axis == Axis.vertical ? clipRect!.height : clipRect!.width)) &&
        child!.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipRect = calculateClipRect();

    layer = context.pushClipRect(
      needsCompositing,
      offset,
      clipRect!,
      super.paint,
      oldLayer: layer as ClipRectLayer?,
    );
  }
}

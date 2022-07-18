import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';

import 'button.dart';

const double _toolbarHeight = 45.0;
const double _toolbarContentDistance = 18.0;
const double _toolbarScreenPadding = 12.0;
const Size _toolbarArrowSize = Size(15.0, 6.0);

typedef CarrotTextSelectionToolbarBuilder = Widget Function(BuildContext context, Offset anchor, bool isAbove, Widget child);

class CarrotTextSelectionToolbar extends StatelessWidget {
  final Offset anchorAbove;
  final Offset anchorBelow;
  final CarrotTextSelectionToolbarBuilder builder;
  final List<Widget> children;

  const CarrotTextSelectionToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.children,
    this.builder = _defaultToolbarBuilder,
  }) : assert(children.length > 0);

  static Widget _defaultToolbarBuilder(BuildContext context, Offset anchor, bool isAbove, Widget child) {
    return _CarrotTextSelectionToolbarShape(
      anchor: anchor,
      isAbove: isAbove,
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.carrotTheme.gray[700]),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final double paddingAbove = mediaQuery.padding.top + _toolbarScreenPadding;
    final double toolbarHeightNeeded = paddingAbove + _toolbarContentDistance + _toolbarHeight;
    final bool fitsAbove = anchorAbove.dy >= toolbarHeightNeeded;
    const Offset contentPaddingAdjustment = Offset(.0, _toolbarContentDistance);
    final Offset localAdjustment = Offset(_toolbarScreenPadding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _toolbarScreenPadding,
        paddingAbove,
        _toolbarScreenPadding,
        _toolbarScreenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbove - localAdjustment - contentPaddingAdjustment,
          anchorBelow: anchorBelow - localAdjustment + contentPaddingAdjustment,
        ),
        child: CarrotTextSelectionToolbarContent(
          anchor: fitsAbove ? anchorAbove : anchorBelow,
          builder: builder,
          isAbove: fitsAbove,
          children: children,
        ),
      ),
    );
  }
}

class CarrotTextSelectionToolbarButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const CarrotTextSelectionToolbarButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  CarrotTextSelectionToolbarButton.text({
    super.key,
    required BuildContext context,
    required String text,
    this.onPressed,
  }) : child = CarrotButton(
          decoration: BoxDecoration(
            color: context.carrotTheme.gray[900],
          ),
          decorationTap: BoxDecoration(
            color: context.carrotTheme.gray[800],
          ),
          duration: const Duration(milliseconds: 240),
          padding: const EdgeInsets.all(18),
          scaleTap: 1,
          onTap: onPressed,
          children: [
            Text(
              text,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class CarrotTextSelectionToolbarContent extends StatefulWidget {
  final Offset anchor;
  final CarrotTextSelectionToolbarBuilder builder;
  final List<Widget> children;
  final bool isAbove;

  const CarrotTextSelectionToolbarContent({
    super.key,
    required this.anchor,
    required this.builder,
    required this.children,
    required this.isAbove,
  });

  @override
  createState() => _CarrotTextSelectionToolbarContent();
}

class _CarrotTextSelectionToolbarContent extends State<CarrotTextSelectionToolbarContent> with TickerProviderStateMixin {
  late AnimationController _controller;
  int _page = 0;
  int? _nextPage;

  void _handleNextPage() {
    _controller.reverse();
    _controller.addStatusListener(_statusListener);
    _nextPage = _page + 1;
  }

  void _handlePreviousPage() {
    _controller.reverse();
    _controller.addStatusListener(_statusListener);
    _nextPage = _page - 1;
  }

  void _statusListener(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) {
      return;
    }

    setState(() {
      _page = _nextPage!;
      _nextPage = null;
    });

    _controller.forward();
    _controller.removeStatusListener(_statusListener);
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.children != oldWidget.children) {
      _page = 0;
      _nextPage = null;
      _controller.forward();
      _controller.removeStatusListener(_statusListener);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context,
        widget.anchor,
        widget.isAbove,
        FadeTransition(
          opacity: _controller,
          child: _CarrotTextSelectionToolbarItems(
            dividerWidth: 1.0 / MediaQuery.of(context).devicePixelRatio,
            page: _page,
            backButton: CarrotTextSelectionToolbarButton.text(
              context: context,
              text: "◀",
              onPressed: _handlePreviousPage,
            ),
            nextButton: CarrotTextSelectionToolbarButton.text(
              context: context,
              text: "▶",
              onPressed: _handleNextPage,
            ),
            nextButtonDisabled: CarrotTextSelectionToolbarButton.text(
              context: context,
              text: "▶",
            ),
            children: widget.children,
          ),
        ));
  }
}

class _CarrotTextSelectionToolbarItems extends RenderObjectWidget {
  final Widget backButton;
  final List<Widget> children;
  final double dividerWidth;
  final Widget nextButton;
  final Widget nextButtonDisabled;
  final int page;

  const _CarrotTextSelectionToolbarItems({
    required this.backButton,
    required this.children,
    required this.dividerWidth,
    required this.nextButton,
    required this.nextButtonDisabled,
    required this.page,
  });

  @override
  createElement() => _CarrotTextSelectionToolbarItemsElement(this);

  @override
  createRenderObject(BuildContext context) => _RenderCarrotTextSelectionToolbarItems(
        dividerWidth: dividerWidth,
        page: page,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderCarrotTextSelectionToolbarItems renderObject) {
    renderObject
      ..dividerWidth = dividerWidth
      ..page = page;
  }
}

class _CarrotTextSelectionToolbarItemsElement extends RenderObjectElement {
  late List<Element> _children;
  final Map<_CarrotTextSelectionToolbarItemsSlot, Element> slotToChild = <_CarrotTextSelectionToolbarItemsSlot, Element>{};
  final Set<Element> _forgottenChildren = HashSet<Element>();

  @override
  _RenderCarrotTextSelectionToolbarItems get renderObject => super.renderObject as _RenderCarrotTextSelectionToolbarItems;

  @override
  _CarrotTextSelectionToolbarItems get widget => super.widget as _CarrotTextSelectionToolbarItems;

  _CarrotTextSelectionToolbarItemsElement(
    _CarrotTextSelectionToolbarItems widget,
  ) : super(widget);

  void _mountChild(Widget widget, _CarrotTextSelectionToolbarItemsSlot slot) {
    final Element? oldChild = slotToChild[slot];
    final Element? newChild = updateChild(oldChild, widget, slot);

    if (oldChild != null) {
      slotToChild.remove(slot);
    }

    if (newChild != null) {
      slotToChild[slot] = newChild;
    }
  }

  void _updateRenderObject(RenderBox? child, _CarrotTextSelectionToolbarItemsSlot slot) {
    switch (slot) {
      case _CarrotTextSelectionToolbarItemsSlot.backButton:
        renderObject.backButton = child;
        break;
      case _CarrotTextSelectionToolbarItemsSlot.nextButton:
        renderObject.nextButton = child;
        break;
      case _CarrotTextSelectionToolbarItemsSlot.nextButtonDisabled:
        renderObject.nextButtonDisabled = child;
        break;
    }
  }

  @override
  void forgetChild(Element child) {
    assert(slotToChild.containsValue(child) || _children.contains(child));
    assert(!_forgottenChildren.contains(child));

    if (slotToChild.containsKey(child.slot)) {
      slotToChild.remove(child.slot! as _CarrotTextSelectionToolbarItemsSlot);
    } else {
      _forgottenChildren.add(child);
    }

    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    if (slot is _CarrotTextSelectionToolbarItemsSlot) {
      assert(child is RenderBox);
      _updateRenderObject(child as RenderBox, slot);
      assert(renderObject.slottedChildren.containsKey(slot));
      return;
    }

    if (slot is IndexedSlot) {
      assert(renderObject.debugValidateChild(child));
      renderObject.insert(child as RenderBox, after: slot.value?.renderObject as RenderBox?);
      return;
    }

    assert(false, "slot must be _CarrotTextSelectionToolbarItemsSlot or IndexedSlot");
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);

    _mountChild(widget.backButton, _CarrotTextSelectionToolbarItemsSlot.backButton);
    _mountChild(widget.nextButton, _CarrotTextSelectionToolbarItemsSlot.nextButton);
    _mountChild(widget.nextButtonDisabled, _CarrotTextSelectionToolbarItemsSlot.nextButtonDisabled);

    _children = List<Element>.filled(widget.children.length, _NullElement.instance);

    Element? previousChild;

    for (int i = 0; i < _children.length; ++i) {
      final newChild = inflateWidget(widget.children[i], IndexedSlot<Element?>(i, previousChild));
      _children[i] = newChild;
      previousChild = newChild;
    }
  }

  @override
  void moveRenderObjectChild(RenderObject child, IndexedSlot<Element> oldSlot, IndexedSlot<Element> newSlot) {
    assert(child.parent == renderObject);

    renderObject.move(child as RenderBox, after: newSlot.value.renderObject as RenderBox?);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    if (slot is _CarrotTextSelectionToolbarItemsSlot) {
      assert(child is RenderBox);
      assert(renderObject.slottedChildren.containsKey(slot));
      _updateRenderObject(null, slot);
      assert(!renderObject.slottedChildren.containsKey(slot));
      return;
    }

    assert(slot is IndexedSlot);
    assert(child.parent == renderObject);

    renderObject.remove(child as RenderBox);
  }

  @override
  void update(_CarrotTextSelectionToolbarItems newWidget) {
    super.update(newWidget);

    assert(widget == newWidget);

    _mountChild(widget.backButton, _CarrotTextSelectionToolbarItemsSlot.backButton);
    _mountChild(widget.nextButton, _CarrotTextSelectionToolbarItemsSlot.nextButton);
    _mountChild(widget.nextButtonDisabled, _CarrotTextSelectionToolbarItemsSlot.nextButtonDisabled);

    _children = updateChildren(_children, widget.children, forgottenChildren: _forgottenChildren);
    _forgottenChildren.clear();
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    slotToChild.values.forEach(visitor);

    for (final child in _children) {
      if (!_forgottenChildren.contains(child)) {
        visitor(child);
      }
    }
  }

  static bool _shouldPaint(Element child) {
    return (child.renderObject!.parentData! as ToolbarItemsParentData).shouldPaint;
  }

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    for (final child in slotToChild.values) {
      if (_shouldPaint(child) && !_forgottenChildren.contains(child)) {
        visitor(child);
      }
    }

    _children.where((child) => !_forgottenChildren.contains(child) && _shouldPaint(child)).forEach(visitor);
  }
}

class _CarrotTextSelectionToolbarShape extends SingleChildRenderObjectWidget {
  final Offset _anchor;
  final bool _isAbove;

  const _CarrotTextSelectionToolbarShape({
    super.child,
    required Offset anchor,
    required bool isAbove,
  })  : _anchor = anchor,
        _isAbove = isAbove;

  @override
  _RenderCarrotTextSelectionToolbarShape createRenderObject(BuildContext context) => _RenderCarrotTextSelectionToolbarShape(
        _anchor,
        _isAbove,
        context.carrotTheme.borderRadius.topLeft,
        null,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderCarrotTextSelectionToolbarShape renderObject) {
    renderObject
      ..anchor = _anchor
      ..isAbove = _isAbove;
  }
}

class _RenderCarrotTextSelectionToolbarItems extends RenderBox with ContainerRenderObjectMixin<RenderBox, ToolbarItemsParentData>, RenderBoxContainerDefaultsMixin<RenderBox, ToolbarItemsParentData> {
  double _dividerWidth;
  int _page;
  RenderBox? _backButton;
  RenderBox? _nextButton;
  RenderBox? _nextButtonDisabled;

  double get dividerWidth => _dividerWidth;

  int get page => _page;

  RenderBox? get backButton => _backButton;

  RenderBox? get nextButton => _nextButton;

  RenderBox? get nextButtonDisabled => _nextButtonDisabled;

  set dividerWidth(double value) {
    if (value == _dividerWidth) {
      return;
    }

    _dividerWidth = value;
    markNeedsLayout();
  }

  set page(int value) {
    if (value == _page) {
      return;
    }

    _page = value;
    markNeedsLayout();
  }

  set backButton(RenderBox? value) {
    _backButton = _updateChild(_backButton, value, _CarrotTextSelectionToolbarItemsSlot.backButton);
  }

  set nextButton(RenderBox? value) {
    _nextButton = _updateChild(_nextButton, value, _CarrotTextSelectionToolbarItemsSlot.nextButton);
  }

  set nextButtonDisabled(RenderBox? value) {
    _nextButtonDisabled = _updateChild(_nextButtonDisabled, value, _CarrotTextSelectionToolbarItemsSlot.nextButtonDisabled);
  }

  final Map<_CarrotTextSelectionToolbarItemsSlot, RenderBox> slottedChildren = <_CarrotTextSelectionToolbarItemsSlot, RenderBox>{};

  _RenderCarrotTextSelectionToolbarItems({
    required double dividerWidth,
    required int page,
  })  : _dividerWidth = dividerWidth,
        _page = page;

  bool _isSlottedChild(RenderBox child) => child == _backButton || child == _nextButton || child == _nextButtonDisabled;

  RenderBox? _updateChild(RenderBox? oldChild, RenderBox? newChild, _CarrotTextSelectionToolbarItemsSlot slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      slottedChildren.remove(slot);
    }

    if (newChild != null) {
      slottedChildren[slot] = newChild;
      adoptChild(newChild);
    }

    return newChild;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    for (final RenderBox child in slottedChildren.values) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();

    for (final RenderBox child in slottedChildren.values) {
      child.detach();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;

    while (child != null) {
      final ToolbarItemsParentData childParentData = child.parentData! as ToolbarItemsParentData;

      if (!childParentData.shouldPaint) {
        child = childParentData.previousSibling;
        continue;
      }

      if (hitTestChild(child, result, position: position)) {
        return true;
      }

      child = childParentData.previousSibling;
    }

    return hitTestChild(_backButton, result, position: position) || hitTestChild(_nextButton, result, position: position) || hitTestChild(_nextButtonDisabled, result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    visitChildren((renderObjectChild) {
      final RenderBox child = renderObjectChild as RenderBox;
      final ToolbarItemsParentData childParentData = child.parentData! as ToolbarItemsParentData;

      if (childParentData.shouldPaint) {
        final Offset childOffset = childParentData.offset + offset;
        context.paintChild(child, childOffset);
      }
    });
  }

  @override
  void performLayout() {
    if (firstChild == null) {
      size = constraints.smallest;
      return;
    }

    _backButton!.layout(constraints.loosen(), parentUsesSize: true);
    _nextButton!.layout(constraints.loosen(), parentUsesSize: true);
    _nextButtonDisabled!.layout(constraints.loosen(), parentUsesSize: true);

    final double subsequentPageButtonsWidth = _backButton!.size.width + _nextButton!.size.width;
    double currentButtonPosition = .0;
    late double toolbarWidth, greatestHeight = .0, firstPageWidth;
    int currentPage = 0;
    int i = -1;

    visitChildren((renderObjectChild) {
      ++i;

      final RenderBox child = renderObjectChild as RenderBox;
      final ToolbarItemsParentData childParentData = child.parentData! as ToolbarItemsParentData;

      if (_isSlottedChild(child) || currentPage > _page) {
        return;
      }

      double paginationButtonsWidth = currentPage == 0
          ? i == childCount - 1
              ? .0
              : _nextButton!.size.width
          : subsequentPageButtonsWidth;

      child.layout(
        BoxConstraints.loose(Size(
          (currentPage == 0 ? constraints.maxWidth : firstPageWidth) - paginationButtonsWidth,
          constraints.maxHeight,
        )),
        parentUsesSize: true,
      );

      greatestHeight = child.size.height > greatestHeight ? child.size.height : greatestHeight;

      final double currentWidth = currentButtonPosition + paginationButtonsWidth + child.size.width;

      if (currentWidth > constraints.maxWidth) {
        ++currentPage;

        currentButtonPosition = _backButton!.size.width + _dividerWidth;
        paginationButtonsWidth = _backButton!.size.width + _nextButton!.size.width;

        child.layout(
          BoxConstraints.loose(Size(
            firstPageWidth - paginationButtonsWidth,
            constraints.maxHeight,
          )),
          parentUsesSize: true,
        );
      }

      childParentData.offset = Offset(currentButtonPosition, .0);
      currentButtonPosition += child.size.width + _dividerWidth;
      childParentData.shouldPaint = currentPage == page;

      if (currentPage == 0) {
        firstPageWidth = currentButtonPosition + _nextButton!.size.width;
      }

      if (currentPage == page) {
        toolbarWidth = currentButtonPosition;
      }
    });

    assert(page <= currentPage);

    if (currentPage > 0) {
      final ToolbarItemsParentData backButtonParentData = _backButton!.parentData! as ToolbarItemsParentData;
      final ToolbarItemsParentData nextButtonParentData = _nextButton!.parentData! as ToolbarItemsParentData;
      final ToolbarItemsParentData nextButtonDisabledParentData = _nextButtonDisabled!.parentData! as ToolbarItemsParentData;

      if (page == currentPage) {
        nextButtonDisabledParentData.offset = Offset(toolbarWidth, .0);
        nextButtonDisabledParentData.shouldPaint = true;
        toolbarWidth += nextButtonDisabled!.size.width;
      } else {
        nextButtonParentData.offset = Offset(toolbarWidth, .0);
        nextButtonParentData.shouldPaint = true;
        toolbarWidth += nextButton!.size.width;
      }

      if (page > 0) {
        backButtonParentData.offset = Offset.zero;
        backButtonParentData.shouldPaint = true;
      }
    } else {
      toolbarWidth -= _dividerWidth;
    }

    size = constraints.constrain(Size(toolbarWidth, greatestHeight));
  }

  @override
  void redepthChildren() {
    visitChildren((renderObjectChild) => redepthChild(renderObjectChild));
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ToolbarItemsParentData) {
      child.parentData = ToolbarItemsParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_backButton != null) {
      visitor(_backButton!);
    }

    if (_nextButton != null) {
      visitor(_nextButton!);
    }

    if (_nextButtonDisabled != null) {
      visitor(_nextButtonDisabled!);
    }

    super.visitChildren(visitor);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitChildren((renderObjectChild) {
      final RenderBox child = renderObjectChild as RenderBox;
      final ToolbarItemsParentData childParentData = child.parentData! as ToolbarItemsParentData;

      if (childParentData.shouldPaint) {
        visitor(renderObjectChild);
      }
    });
  }

  static bool hitTestChild(RenderBox? child, BoxHitTestResult result, {required Offset position}) {
    if (child == null) {
      return false;
    }

    final ToolbarItemsParentData childParentData = child.parentData! as ToolbarItemsParentData;

    if (!childParentData.shouldPaint) {
      return false;
    }

    return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        });
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final value = <DiagnosticsNode>[];

    visitChildren((renderObjectChild) {
      final RenderBox child = renderObjectChild as RenderBox;

      if (child == _backButton) {
        value.add(child.toDiagnosticsNode(name: "back button"));
      } else if (child == _nextButton) {
        value.add(child.toDiagnosticsNode(name: "next button"));
      } else if (child == _nextButtonDisabled) {
        value.add(child.toDiagnosticsNode(name: "next button disabled"));
      } else {
        value.add(child.toDiagnosticsNode(name: "menu item"));
      }
    });

    return value;
  }
}

class _RenderCarrotTextSelectionToolbarShape extends RenderShiftedBox {
  final Radius radius;

  Offset _anchor;
  bool _isAbove;

  final LayerHandle<ClipPathLayer> _clipPathLayer = LayerHandle<ClipPathLayer>();
  final BoxConstraints _heightConstraint = BoxConstraints.tightFor(height: _toolbarHeight + _toolbarArrowSize.height);

  _RenderCarrotTextSelectionToolbarShape(
    this._anchor,
    this._isAbove,
    this.radius,
    RenderBox? child,
  ) : super(child);

  @override
  bool get isRepaintBoundary => true;

  Offset get anchor => _anchor;

  bool get isAbove => _isAbove;

  set anchor(Offset value) {
    if (_anchor == value) {
      return;
    }

    _anchor = value;
    markNeedsLayout();
  }

  set isAbove(bool value) {
    if (_isAbove == value) {
      return;
    }

    _isAbove = value;
    markNeedsLayout();
  }

  Path _clipPath() {
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    final Path rrect = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset(0.0, _toolbarArrowSize.height) &
              Size(
                child!.size.width,
                child!.size.height - _toolbarArrowSize.height * 2,
              ),
          radius,
        ),
      );

    final Offset localAnchor = globalToLocal(_anchor);
    final double centerX = childParentData.offset.dx + child!.size.width / 2;
    final double arrowXOffsetFromCenter = localAnchor.dx - centerX;
    final double arrowTipX = child!.size.width / 2 + arrowXOffsetFromCenter;

    final double arrowBaseY = _isAbove ? child!.size.height - _toolbarArrowSize.height : _toolbarArrowSize.height;
    final double arrowTipY = _isAbove ? child!.size.height : 0;

    final Path arrow = Path()
      ..moveTo(arrowTipX, arrowTipY)
      ..lineTo(arrowTipX - _toolbarArrowSize.width / 2, arrowBaseY)
      ..lineTo(arrowTipX + _toolbarArrowSize.width / 2, arrowBaseY)
      ..close();

    return Path.combine(PathOperation.union, rrect, arrow);
  }

  @override
  void dispose() {
    _clipPathLayer.layer = null;

    super.dispose();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    final Rect hitBox = Rect.fromLTWH(
      childParentData.offset.dx,
      childParentData.offset.dy + _toolbarArrowSize.height,
      child!.size.width,
      child!.size.height - _toolbarArrowSize.height * 2,
    );

    if (!hitBox.contains(position)) {
      return false;
    }

    return super.hitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }

    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    _clipPathLayer.layer = context.pushClipPath(
      needsCompositing,
      offset + childParentData.offset,
      Offset.zero & child!.size,
      _clipPath(),
      (innerContext, innerOffset) => innerContext.paintChild(child!, innerOffset),
      oldLayer: _clipPathLayer.layer,
    );
  }

  @override
  void performLayout() {
    if (child == null) {
      return;
    }

    final BoxConstraints enforcedConstraint = constraints.loosen();
    child!.layout(_heightConstraint.enforce(enforcedConstraint), parentUsesSize: true);

    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(0.0, _isAbove ? _toolbarArrowSize.height : 0.0);

    size = Size(
      child!.size.width,
      child!.size.height - _toolbarArrowSize.height,
    );
  }
}

enum _CarrotTextSelectionToolbarItemsSlot {
  backButton,
  nextButton,
  nextButtonDisabled,
}

class _NullElement extends Element {
  static _NullElement instance = _NullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();

  _NullElement() : super(_NullWidget());

  @override
  void performRebuild() {}
}

class _NullWidget extends Widget {
  @override
  createElement() => throw UnimplementedError();
}

import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// todo(Bas): Remove this custom widget when Dart 3 is out and Flutter made
//  [MultiChildRenderObjectWidget] a const widget.

abstract class CarrotMultiChildRenderObjectWidget extends RenderObjectWidget {
  final List<Widget> children;

  const CarrotMultiChildRenderObjectWidget({
    super.key,
    this.children = const [],
  });

  @override
  CarrotMultiChildRenderObjectElement createElement() => CarrotMultiChildRenderObjectElement(this);
}

class CarrotMultiChildRenderObjectElement extends RenderObjectElement {
  CarrotMultiChildRenderObjectElement(CarrotMultiChildRenderObjectWidget super.widget) : assert(!debugChildrenHaveDuplicateKeys(widget, widget.children));

  @override
  ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> get renderObject {
    return super.renderObject as ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>>;
  }

  @protected
  @visibleForTesting
  Iterable<Element> get children => _children.where((Element child) => !_forgottenChildren.contains(child));

  late List<Element> _children;

  final Set<Element> _forgottenChildren = HashSet<Element>();

  @override
  void insertRenderObjectChild(RenderObject child, IndexedSlot<Element?> slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child, after: slot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, IndexedSlot<Element?> oldSlot, IndexedSlot<Element?> newSlot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.move(child, after: newSlot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.remove(child);
    assert(renderObject == this.renderObject);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    for (final Element child in _children) {
      if (!_forgottenChildren.contains(child)) {
        visitor(child);
      }
    }
  }

  @override
  void forgetChild(Element child) {
    assert(_children.contains(child));
    assert(!_forgottenChildren.contains(child));
    _forgottenChildren.add(child);
    super.forgetChild(child);
  }

  bool _debugCheckHasAssociatedRenderObject(Element newChild) {
    assert(() {
      if (newChild.renderObject == null) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('The children of `CarrotMultiChildRenderObjectElement` must each has an associated render object.'),
              ErrorHint(
                'This typically means that the `${newChild.widget}` or its children\n'
                'are not a subtype of `RenderObjectWidget`.',
              ),
              newChild.describeElement('The following element does not have an associated render object'),
              DiagnosticsDebugCreator(DebugCreator(newChild)),
            ]),
          ),
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Element inflateWidget(Widget newWidget, Object? newSlot) {
    final Element newChild = super.inflateWidget(newWidget, newSlot);
    assert(_debugCheckHasAssociatedRenderObject(newChild));
    return newChild;
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    final CarrotMultiChildRenderObjectWidget multiChildRenderObjectWidget = widget as CarrotMultiChildRenderObjectWidget;
    final List<Element> children = List<Element>.filled(multiChildRenderObjectWidget.children.length, _NullElement.instance);
    Element? previousChild;
    for (int i = 0; i < children.length; i += 1) {
      final Element newChild = inflateWidget(multiChildRenderObjectWidget.children[i], IndexedSlot<Element?>(i, previousChild));
      children[i] = newChild;
      previousChild = newChild;
    }
    _children = children;
  }

  @override
  void update(CarrotMultiChildRenderObjectWidget newWidget) {
    super.update(newWidget);
    final CarrotMultiChildRenderObjectWidget multiChildRenderObjectWidget = widget as CarrotMultiChildRenderObjectWidget;
    assert(widget == newWidget);
    assert(!debugChildrenHaveDuplicateKeys(widget, multiChildRenderObjectWidget.children));
    _children = updateChildren(_children, multiChildRenderObjectWidget.children, forgottenChildren: _forgottenChildren);
    _forgottenChildren.clear();
  }
}

class _NullElement extends Element {
  _NullElement() : super(const _NullWidget());

  static _NullElement instance = _NullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  void performRebuild() => throw UnimplementedError();
}

class _NullWidget extends Widget {
  const _NullWidget();

  @override
  Element createElement() => throw UnimplementedError();
}

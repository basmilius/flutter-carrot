import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../extension/extension.dart';

typedef CarrotSizeMeasureChildChange = void Function(Size size);

class CarrotSizeMeasureChild extends SingleChildRenderObjectWidget {
  final CarrotSizeMeasureChildChange onChange;

  const CarrotSizeMeasureChild({
    super.key,
    super.child,
    required this.onChange,
  });

  @override
  createRenderObject(BuildContext context) {
    return _CarrotSizeMeasureChildRenderObject(onChange);
  }
}

class _CarrotSizeMeasureChildRenderObject extends RenderProxyBox {
  final CarrotSizeMeasureChildChange onChange;
  Size? _old;

  _CarrotSizeMeasureChildRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    if (child == null) {
      return;
    }

    Size newSize = child!.size;

    if (_old == newSize) {
      return;
    }

    _old = newSize;

    onMounted(() {
      onChange(newSize);
    });
  }
}

class CarrotSizeMeasureInheritedSize extends InheritedWidget {
  final Size size;

  const CarrotSizeMeasureInheritedSize({
    super.key,
    required super.child,
    required this.size,
  });

  @override
  bool updateShouldNotify(CarrotSizeMeasureInheritedSize oldWidget) {
    return oldWidget.size != size;
  }
}

class CarrotSizeMeasureProvider extends StatefulWidget {
  final WidgetBuilder builder;

  const CarrotSizeMeasureProvider({
    super.key,
    required this.builder,
  });

  @override
  createState() => _CarrotSizeMeasureProviderState();
}

class _CarrotSizeMeasureProviderState extends State<CarrotSizeMeasureProvider> {
  Size _size = Size.zero;

  void _onChange(Size size) {
    setState(() {
      _size = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarrotSizeMeasureChild(
      onChange: _onChange,
      child: CarrotSizeMeasureInheritedSize(
        size: _size,
        child: Builder(
          builder: widget.builder,
        ),
      ),
    );
  }
}

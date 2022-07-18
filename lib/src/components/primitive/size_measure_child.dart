import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../app/extensions/extensions.dart';

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

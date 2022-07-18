import 'package:flutter/widgets.dart';

extension CarrotRenderBoxExtension on RenderBox {
  WidgetsBinding get binding => WidgetsBinding.instance;

  void onMounted(Function fn) {
    binding.addPostFrameCallback((timeStamp) {
      fn();
    });
  }
}

extension CarrotWidgetExtension on State {
  WidgetsBinding get binding => WidgetsBinding.instance;

  void onMounted(Function fn) {
    binding.addPostFrameCallback((timeStamp) {
      fn();
    });
  }
}

import 'package:flutter/widgets.dart';

extension CarrotRenderBoxExtension on RenderBox {
  /// Gets the [WidgetBinding] instance.
  WidgetsBinding get binding => WidgetsBinding.instance;

  /// Executes the given function [fn] when the widget is mounted.
  void onMounted(Function fn) {
    binding.addPostFrameCallback((timeStamp) {
      fn();
    });
  }
}

extension CarrotStateExtension on State {
  /// Gets the [WidgetBinding] instance.
  WidgetsBinding get binding => WidgetsBinding.instance;

  /// Executes the given function [fn] when the widget is mounted.
  void onMounted(Function fn) {
    binding.addPostFrameCallback((timeStamp) {
      fn();
    });
  }
}

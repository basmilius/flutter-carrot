import 'package:flutter/widgets.dart';

import '../../extension/extension.dart';

typedef CarrotContinuousAnimationBuilderCallback = Widget Function(BuildContext, AnimationController);

class CarrotContinuousAnimationBuilder extends StatefulWidget {
  final CarrotContinuousAnimationBuilderCallback builder;

  const CarrotContinuousAnimationBuilder({
    super.key,
    required this.builder,
  });

  @override
  createState() => CarrotContinuousAnimationBuilderState();
}

class CarrotContinuousAnimationBuilderState extends State<CarrotContinuousAnimationBuilder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    onMounted(() {
      _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}

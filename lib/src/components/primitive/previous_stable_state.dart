import 'package:flutter/widgets.dart';

typedef CarrotPreviousStableStateBuilder<S> = Widget Function(BuildContext, S?);

class CarrotPreviousStableState<S> extends StatefulWidget {
  final CarrotPreviousStableStateBuilder<S> builder;
  final S? state;

  const CarrotPreviousStableState({
    super.key,
    required this.builder,
    required this.state,
  });

  @override
  createState() => _CarrotPreviousStableStateState<S>();
}

class _CarrotPreviousStableStateState<S> extends State<CarrotPreviousStableState<S>> {
  late S? _stableState;

  @override
  void didUpdateWidget(CarrotPreviousStableState<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _stableState = widget.state ?? _stableState;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _stableState = widget.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _stableState);
  }
}

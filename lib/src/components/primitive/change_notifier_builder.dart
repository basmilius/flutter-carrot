import 'package:flutter/widgets.dart';

class CarrotChangeNotifierBuilder<T extends Listenable> extends StatefulWidget {
  final Widget Function(BuildContext context, T notifier) builder;
  final T notifier;

  const CarrotChangeNotifierBuilder({
    super.key,
    required this.builder,
    required this.notifier,
  });

  @override
  createState() => _CarrotChangeNotifierBuilder<T>();
}

class _CarrotChangeNotifierBuilder<T extends Listenable> extends State<CarrotChangeNotifierBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_update);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.notifier);
}

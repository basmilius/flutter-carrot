part of 'base.dart';

class BounceInBuilder extends FadeInBuilder {
  late Animation<double> _scale;

  @override
  Widget build(BuildContext context, Widget child) {
    return Transform.scale(
      scale: _scale.value,
      child: super.build(context, child),
    );
  }

  @override
  void init(controller) {
    super.init(controller);
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(controller);
  }
}

class BounceInOffsetBuilder extends FadeInOffsetBuilder {
  BounceInOffsetBuilder(super.fromOffset);
}

part of 'base.dart';

class ElasticInBuilder extends FadeInBuilder {
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
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(controller);
  }
}

class ElasticInOffsetBuilder extends FadeInOffsetBuilder {
  late Animation<double> _scale;

  ElasticInOffsetBuilder(super.fromOffset);

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
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(controller);
  }
}

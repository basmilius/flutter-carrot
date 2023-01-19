part of 'base.dart';

class FadeInBuilder extends CarrotBasicAnimationBuilder {
  late Animation<double> _opacity;

  @override
  Widget build(BuildContext context, Widget child) {
    return FadeTransition(
      opacity: _opacity,
      child: child,
    );
  }

  @override
  void init(controller) {
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }
}

class FadeInOffsetBuilder extends FadeInBuilder {
  final Offset fromOffset;
  late Animation<Offset> _offset;

  FadeInOffsetBuilder(this.fromOffset);

  @override
  Widget build(context, child) {
    return Transform.translate(
      offset: _offset.value,
      child: super.build(context, child),
    );
  }

  @override
  void init(controller) {
    super.init(controller);
    _offset = Tween<Offset>(begin: fromOffset, end: Offset.zero).animate(controller);
  }
}

class FadeOutBuilder extends CarrotBasicAnimationBuilder {
  late Animation<double> _opacity;

  @override
  Widget build(BuildContext context, Widget child) {
    return FadeTransition(
      opacity: _opacity,
      child: child,
    );
  }

  @override
  void init(controller) {
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
  }
}

class FadeOutOffsetBuilder extends FadeOutBuilder {
  final Offset toOffset;
  late Animation<Offset> _offset;

  FadeOutOffsetBuilder(this.toOffset);

  @override
  Widget build(context, child) {
    return Transform.translate(
      offset: _offset.value,
      child: super.build(context, child),
    );
  }

  @override
  void init(controller) {
    super.init(controller);
    _offset = Tween<Offset>(begin: Offset.zero, end: toOffset).animate(controller);
  }
}

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import '../data/data.dart';
import '../ui/color.dart';

import 'basic.dart';
import 'button.dart';
import 'contained_button.dart';
import 'icon.dart';
import 'scroll_view.dart';

class CarrotTeachingModel extends CarrotReactiveModel {
  final List<CarrotTeachingTipModel> _tips = [];

  bool get available {
    return _tips.isNotEmpty;
  }

  CarrotTeachingTipModel get tip {
    return _tips[0];
  }

  List<CarrotTeachingTipModel> get tips {
    return _tips;
  }

  void add({
    required GlobalKey key,
    required Widget body,
  }) {
    _tips.add(CarrotTeachingTipModel(
      key,
      body,
    ));

    notifyListeners();
  }

  void remove(int index) {
    _tips.removeAt(index);

    notifyListeners();
  }
}

class CarrotTeachingTipModel {
  final GlobalKey target;
  final Widget body;

  CarrotTeachingTipModel(
    this.target,
    this.body,
  );
}

class CarrotTeachingProvider extends StatelessWidget {
  final Widget child;

  const CarrotTeachingProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
    return CarrotReactiveModelProvider(
      create: () => CarrotTeachingModel(),
      child: StatefulBuilder(
        builder: (context, setState) {
          final teachingModel = context.reactiveModel<CarrotTeachingModel>();
          Offset offset = Offset.zero;
          Size size = MediaQuery.of(context).size;

          if (teachingModel.available) {
            final tip = teachingModel.tip;
            final widgetContext = tip.target.currentContext!.findRenderObject() as RenderBox;

            offset = widgetContext.localToGlobal(Offset.zero);
            size = widgetContext.size;
          }

          return Stack(
            children: [
              RepaintBoundary(
                child: child,
              ),
              if (teachingModel.available)
                IgnorePointer(
                  ignoring: !teachingModel.available,
                  child: CarrotTeachingOverlay(
                    offset: offset,
                    size: size,
                  ),
                ),
              if (teachingModel.available)
                CarrotTeachingBubble(
                  offset: offset,
                  size: size,
                  child: teachingModel.tip.body,
                ),
            ],
          );
        },
      ),
    );
  }
}

class CarrotTeachingBubble extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final Size size;

  const CarrotTeachingBubble({
    super.key,
    required this.child,
    required this.offset,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final teachingModel = context.reactiveModel<CarrotTeachingModel>();

    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: CarrotBasicAnimation.fadeInOffset(
        curve: CarrotCurves.swiftOutCurve,
        delay: const Duration(milliseconds: 360),
        duration: const Duration(milliseconds: 540),
        fromOffset: const Offset(0, 90),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CarrotColors.blue[500].darken(.025),
          ),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.merge(TextStyle(
                  color: CarrotColors.blue[200],
                  fontSize: 18,
                )),
            child: Padding(
              padding: EdgeInsets.only(
                top: 36,
                bottom: 36 + context.safeAreaReal.bottom / 2,
              ),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 780,
                  ),
                  child: CarrotRow(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    gap: 30,
                    children: [
                      CarrotIcon(
                        color: CarrotColors.blue[0],
                        glyph: "stars",
                        size: 36,
                        style: CarrotIconStyle.light,
                      ),
                      Expanded(
                        child: CarrotColumn(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          gap: 15,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: CarrotScrollView(
                                scrollController: ScrollController(),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: AnimatedSize(
                                    curve: CarrotCurves.swiftOutCurve,
                                    duration: const Duration(milliseconds: 540),
                                    child: AnimatedSwitcher(
                                      switchInCurve: CarrotCurves.swiftOutCurve,
                                      switchOutCurve: CarrotCurves.swiftOutCurveReversed,
                                      duration: const Duration(milliseconds: 540),
                                      child: child,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CarrotRow(
                              mainAxisAlignment: MainAxisAlignment.end,
                              gap: 12,
                              children: [
                                CarrotContainedButton(
                                  color: CarrotColors.blue,
                                  size: CarrotButtonSize.small,
                                  icon: "circle-check",
                                  iconStyle: CarrotIconStyle.regular,
                                  children: const [Text("Ik snap 'm")],
                                  onTap: () => teachingModel.remove(0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarrotTeachingOverlay extends StatefulWidget {
  final Offset offset;
  final Size size;

  const CarrotTeachingOverlay({
    super.key,
    required this.offset,
    required this.size,
  });

  @override
  createState() => _CarrotTeachingOverlay();
}

class _CarrotTeachingOverlay extends State<CarrotTeachingOverlay> with TickerProviderStateMixin {
  late AnimationController _attentionController;
  late Animation<double> _attentionScaleAnimation;
  late AnimationController _translateController;
  Animation<Offset>? _translateOffsetAnimation;
  Animation<Size>? _translateSizeAnimation;

  @override
  void dispose() {
    _attentionController.dispose();
    _translateController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initTranslateAnimation(widget.offset, widget.size);
  }

  @override
  void initState() {
    super.initState();

    _initAttentionAnimation();
    _initTranslateAnimation(widget.offset, widget.size);
  }

  void _initAttentionAnimation() {
    _attentionController = AnimationController(
      duration: const Duration(milliseconds: 330),
      vsync: this,
    );

    _attentionScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CarrotDecelerationCurveAnimation(parent: _attentionController))
      ..addListener(() {
        setState(() {});
      });

    _attentionController.repeat(reverse: true);
  }

  void _initTranslateAnimation(Offset targetOffset, Size targetSize) {
    _translateController = AnimationController(
      duration: const Duration(milliseconds: 540),
      vsync: this,
    );

    _translateController.addListener(() {
      setState(() {});
    });

    if (_translateOffsetAnimation == null || _translateSizeAnimation == null) {
      _translateOffsetAnimation = Tween<Offset>(begin: widget.offset, end: targetOffset).animate(CarrotSwiftOutCurveAnimation(parent: _translateController));
      _translateSizeAnimation = Tween<Size>(begin: widget.size, end: targetSize).animate(CarrotSwiftOutCurveAnimation(parent: _translateController));
    } else {
      _translateOffsetAnimation = Tween<Offset>(begin: _translateOffsetAnimation!.value, end: targetOffset).animate(CarrotSwiftOutCurveAnimation(parent: _translateController));
      _translateSizeAnimation = Tween<Size>(begin: _translateSizeAnimation!.value, end: targetSize).animate(CarrotSwiftOutCurveAnimation(parent: _translateController));
    }

    _translateController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CarrotTeachingOverlayPainter(
        insets: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        offset: _translateOffsetAnimation?.value ?? Offset.zero,
        size: _translateSizeAnimation?.value ?? Size.zero,
        radius: 0,
        scale: _attentionScaleAnimation.value,
      ),
      isComplex: true,
      child: Container(),
    );
  }
}

class _CarrotTeachingOverlayPainter extends CustomPainter {
  final EdgeInsets insets;
  final Offset offset;
  final double radius;
  final double scale;
  final Size size;

  const _CarrotTeachingOverlayPainter({
    required this.insets,
    required this.offset,
    required this.radius,
    required this.scale,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size containerSize) {
    final paint = Paint()
      ..color = CarrotColors.slate[900].withOpacity(.75)
      ..isAntiAlias = true;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, containerSize.width, containerSize.height)),
        Path()
          ..addRRect(_maskingRectangle(insets, offset, size, radius, scale))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CarrotTeachingOverlayPainter oldDelegate) {
    return true;
  }
}

RRect _maskingRectangle(EdgeInsets insets, Offset offset, Size size, double radius, double scale) {
  double ox = scale * 9;
  double oy = scale * 9;

  if (size.width > size.height) {
    oy *= (size.height / size.width);
  } else if (size.height > size.width) {
    ox *= (size.width / size.height);
  }

  return RRect.fromRectAndRadius(
    Rect.fromLTWH(
      offset.dx - ox - insets.left,
      offset.dy - oy - insets.top,
      size.width + ox * 2 + insets.left + insets.right,
      size.height + oy * 2 + insets.top + insets.bottom,
    ),
    Radius.circular(radius + scale * 9),
  );
}

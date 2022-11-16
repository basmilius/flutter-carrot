import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import '../ui/ui.dart';
import 'primitive/primitive.dart';
import 'scroll_view.dart';
import 'sheet_pane.dart';

class CarrotPicker extends StatefulWidget {
  final Widget child;
  final Widget? cancel;
  final Widget? confirm;
  final Widget? title;
  final bool isDismissible;
  final GestureTapCallback? onCancelTap;
  final GestureTapCallback? onConfirmTap;

  const CarrotPicker({
    super.key,
    required this.child,
    this.cancel,
    this.confirm,
    this.title,
    this.isDismissible = false,
    this.onCancelTap,
    this.onConfirmTap,
  });

  @override
  createState() => CarrotPickerState();

  static void show(
    BuildContext context, {
    required Widget child,
    Widget? cancel,
    Widget? confirm,
    Widget? title,
    bool isDismissible = false,
    GestureTapCallback? onCancelTap,
    GestureTapCallback? onConfirmTap,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => RepaintBoundary(
        child: CarrotPicker(
          cancel: cancel,
          confirm: confirm,
          title: title,
          isDismissible: isDismissible,
          onCancelTap: onCancelTap,
          onConfirmTap: onConfirmTap,
          child: child,
        ),
      ),
      barrierColor: CarrotColors.transparent,
      transitionBuilder: (context, animation, secondaryAnimation, child) => child,
      transitionDuration: Duration.zero,
      useRootNavigator: true,
    );
  }
}

class CarrotPickerState extends State<CarrotPicker> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween(begin: const Offset(.0, 1.0), end: Offset.zero).animate(
      _animationController.curved(CarrotCurves.swiftOutCurve),
    );

    _opacityAnimation = Tween(begin: .0, end: 1.0).animate(
      _animationController.curved(CarrotCurves.swiftOutCurve),
    );

    _animationController.forward();
  }

  void _close() {
    Navigator.of(context).maybePop();
  }

  Future<bool> _onWillPop() async {
    await _animationController.reverse();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: CarrotScrim(
                  color: appTheme.defaults.scrim,
                  onTap: _close,
                ),
              ),
            ),
            Positioned(
              // top: context.safeAreaReal.top,
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: CarrotSheetPane(
                  isHandleVisible: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight - context.safeAreaReal.top * 2,
                    ),
                    child: CarrotScrollView(
                      scrollController: _scrollController,
                      child: SafeArea(
                        top: false,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../extension/extension.dart';
import '../ui/ui.dart';
import 'drawer_gesture_detector.dart';
import 'dynamic_viewport_safe_area.dart';
import 'primitive/primitive.dart';
import 'scroll_view.dart';

typedef _MeasureSizeCallback = void Function(Size);
typedef _DrawerToggle = void Function(BuildContext);

class CarrotScaffold extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottomBar;
  final LayoutWidgetBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;

  const CarrotScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.backgroundColor,
    this.bottomBar,
    this.drawer,
    this.drawerScrimColor,
    this.drawerWidth = 300.0,
  });

  @override
  createState() => _CarrotScaffoldState();

  static CarrotScaffoldController of(BuildContext context) {
    var state = context.dependOnInheritedWidgetOfExactType<_CarrotScaffoldController>();

    if (state == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotScaffold.of() called with a context that does not contain a CarrotScaffold.',
        ),
      ]);
    }

    return state;
  }
}

class _CarrotScaffoldState extends State<CarrotScaffold> {
  Size _appBarSize = Size.zero;
  Size _bottomBarSize = Size.zero;
  ScrollController? _scrollController;
  ScrollNotificationObserverState? _scrollNotificationObserver;
  double _scrollPosition = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollListenerAdd();
  }

  @override
  void didUpdateWidget(CarrotScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool didChange = false;

    if (widget.appBar == null && oldWidget.appBar != null) {
      _appBarSize = Size.zero;
      didChange = true;
    }

    if (widget.bottomBar == null && oldWidget.bottomBar != null) {
      _bottomBarSize = Size.zero;
      didChange = true;
    }

    if (didChange) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollListenerRemove();
    super.dispose();
  }

  void _handleScroll(ScrollNotification notification) {
    var primaryScrollView = notification.context?.findAncestorWidgetOfExactType<CarrotPrimaryScrollView>();

    if (primaryScrollView == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    try {
      setState(() {
        _scrollController = primaryScrollView.scrollController;
        _scrollPosition = notification.metrics.pixels;
      });
    } catch (_) {}
  }

  void _scrollListenerAdd() {
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    _scrollNotificationObserver?.addListener(_handleScroll);
  }

  void _scrollListenerRemove() {
    _scrollNotificationObserver?.removeListener(_handleScroll);
  }

  void _drawerClose(BuildContext context) {
    CarrotDrawerGestureDetector.of(context).close();
  }

  void _drawerOpen(BuildContext context) {
    CarrotDrawerGestureDetector.of(context).open();
  }

  Tween<Rect?> _heroAnimationTween(Rect? begin, Rect? end) {
    return _CarrotScaffoldHeroTween(
      begin: begin,
      end: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _CarrotScaffoldController(
      appBarSize: _appBarSize,
      bottomBarSize: _bottomBarSize,
      hasAppBar: widget.appBar != null,
      hasBottomBar: widget.bottomBar != null,
      hasDrawer: widget.drawer != null,
      scrollPosition: _scrollPosition,
      drawerCloseFunction: _drawerClose,
      drawerOpenFunction: _drawerOpen,
      child: HeroControllerScope(
        controller: HeroController(
          createRectTween: _heroAnimationTween,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? context.carrotTheme.defaults.background,
          ),
          child: Stack(
            children: [
              _CarrotScaffoldView(
                drawer: widget.drawer,
                drawerScrimColor: widget.drawerScrimColor,
                drawerWidth: widget.drawerWidth,
                child: _CarrotScaffoldBody(
                  appBar: widget.appBar,
                  bottomBar: widget.bottomBar,
                  child: widget.child,
                  onAppBarSizeChange: (size) {
                    setState(() => _appBarSize = size);
                  },
                  onBottomBarSizeChange: (size) {
                    setState(() => _bottomBarSize = size);
                  },
                ),
              ),
              _CarrotScaffoldReturnToTop(
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarrotScaffoldBody extends StatelessWidget {
  final Widget? appBar;
  final Widget? bottomBar;
  final Widget child;
  final _MeasureSizeCallback onAppBarSizeChange;
  final _MeasureSizeCallback onBottomBarSizeChange;

  const _CarrotScaffoldBody({
    required this.appBar,
    required this.bottomBar,
    required this.child,
    required this.onAppBarSizeChange,
    required this.onBottomBarSizeChange,
  });

  @override
  Widget build(BuildContext context) {
    final content = CarrotDynamicViewportSafeArea(
      child: child,
    );

    if (appBar == null && bottomBar == null) {
      return content;
    }

    return Stack(
      children: [
        content,
        if (appBar != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CarrotSizeMeasureChild(
              onChange: onAppBarSizeChange,
              child: appBar!,
            ),
          ),
        if (bottomBar != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CarrotSizeMeasureChild(
              onChange: onBottomBarSizeChange,
              child: bottomBar!,
            ),
          ),
      ],
    );
  }
}

class _CarrotScaffoldView extends StatelessWidget {
  final Widget child;
  final LayoutWidgetBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;

  const _CarrotScaffoldView({
    required this.child,
    required this.drawerWidth,
    this.drawer,
    this.drawerScrimColor,
  });

  Widget _phoneBuilder(BuildContext context) {
    return _CarrotScaffoldViewPhone(
      drawer: drawer,
      drawerScrimColor: drawerScrimColor,
      drawerWidth: drawerWidth,
      child: child,
    );
  }

  Widget _tabletBuilder(BuildContext context) {
    return _CarrotScaffoldViewTablet(
      drawer: drawer,
      drawerScrimColor: drawerScrimColor,
      drawerWidth: drawerWidth,
      child: child,
    );
  }

  Widget _tabletLargeBuilder(BuildContext context) {
    return _CarrotScaffoldViewTabletLarge(
      drawer: drawer,
      drawerWidth: drawerWidth,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.mediaQuery.builderForAppView(
      context,
      phoneBuilder: _phoneBuilder,
      tabletBuilder: _tabletBuilder,
      tabletLargeBuilder: _tabletLargeBuilder,
    );
  }
}

class _CarrotScaffoldViewPhone extends StatelessWidget {
  final Widget child;
  final LayoutWidgetBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;

  const _CarrotScaffoldViewPhone({
    required this.child,
    required this.drawerWidth,
    this.drawer,
    this.drawerScrimColor,
  });

  @override
  Widget build(BuildContext context) {
    if (drawer == null) {
      return child;
    }

    return CarrotDrawerGestureDetector(
      alignment: CarrotDrawerAlignment.start,
      behavior: CarrotDrawerBehavior.over,
      drawer: LayoutBuilder(
        builder: drawer!,
      ),
      drawerWidth: drawerWidth,
      scrimColor: drawerScrimColor,
      child: child,
    );
  }
}

class _CarrotScaffoldViewTablet extends StatelessWidget {
  final Widget child;
  final LayoutWidgetBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;

  const _CarrotScaffoldViewTablet({
    required this.child,
    required this.drawerWidth,
    this.drawer,
    this.drawerScrimColor,
  });

  @override
  Widget build(BuildContext context) {
    if (drawer == null) {
      return child;
    }

    return CarrotDrawerGestureDetector(
      alignment: CarrotDrawerAlignment.start,
      behavior: CarrotDrawerBehavior.offset,
      drawer: LayoutBuilder(
        builder: drawer!,
      ),
      drawerWidth: drawerWidth,
      scrimColor: drawerScrimColor,
      child: child,
    );
  }
}

class _CarrotScaffoldViewTabletLarge extends StatelessWidget {
  final Widget child;
  final LayoutWidgetBuilder? drawer;
  final double drawerWidth;

  const _CarrotScaffoldViewTabletLarge({
    required this.child,
    required this.drawerWidth,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    if (drawer == null) {
      return child;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: drawerWidth,
            minWidth: drawerWidth,
          ),
          child: LayoutBuilder(
            builder: drawer!,
          ),
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}

class _CarrotScaffoldReturnToTop extends StatelessWidget {
  final ScrollController? scrollController;

  const _CarrotScaffoldReturnToTop({
    this.scrollController,
  });

  void _onTap() {
    if (scrollController != null && scrollController!.positions.isNotEmpty) {
      scrollController?.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: CarrotCurves.springOverDamped,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: context.safeArea.top,
        color: CarrotColors.transparent,
      ),
    );
  }
}

class _CarrotScaffoldHeroTween extends RectTween {
  final Curve curve = CarrotCurves.swiftOutCurve;

  _CarrotScaffoldHeroTween({
    super.begin,
    super.end,
  });

  @override
  Rect lerp(double t) {
    return super.lerp(curve.transform(t))!;
  }
}

class _CarrotScaffoldController extends InheritedWidget implements CarrotScaffoldController {
  @override
  final Size appBarSize;
  @override
  final Size bottomBarSize;
  @override
  final bool hasAppBar;
  @override
  final bool hasBottomBar;
  @override
  final bool hasDrawer;
  @override
  final double scrollPosition;

  final _DrawerToggle drawerCloseFunction;
  final _DrawerToggle drawerOpenFunction;

  const _CarrotScaffoldController({
    required super.child,
    required this.appBarSize,
    required this.bottomBarSize,
    required this.hasAppBar,
    required this.hasBottomBar,
    required this.hasDrawer,
    required this.scrollPosition,
    required this.drawerCloseFunction,
    required this.drawerOpenFunction,
  });

  @override
  void drawerClose(BuildContext context) {
    drawerCloseFunction(context);
  }

  @override
  void drawerOpen(BuildContext context) {
    drawerOpenFunction(context);
  }

  @override
  bool updateShouldNotify(_CarrotScaffoldController oldWidget) {
    if (oldWidget.appBarSize != appBarSize) {
      return true;
    }

    if (oldWidget.bottomBarSize != bottomBarSize) {
      return true;
    }

    if (oldWidget.hasAppBar != hasAppBar) {
      return true;
    }

    if (oldWidget.hasBottomBar != hasBottomBar) {
      return true;
    }

    if (oldWidget.hasDrawer != hasDrawer) {
      return true;
    }

    if (oldWidget.scrollPosition != scrollPosition) {
      return true;
    }

    return false;
  }
}

abstract class CarrotScaffoldController {
  Size get appBarSize;

  Size get bottomBarSize;

  bool get hasAppBar;

  bool get hasBottomBar;

  bool get hasDrawer;

  double get scrollPosition;

  void drawerClose(BuildContext context);

  void drawerOpen(BuildContext context);
}

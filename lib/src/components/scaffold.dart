import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/app.dart';
import '../routing/routing.dart';
import '../typedefs/typedefs.dart';
import '../ui/color.dart';

import 'primitive/primitive.dart';
import 'drawer_gesture_detector.dart';
import 'scroll_view.dart';
import 'sheet.dart';

typedef CarrotScaffoldRouterWrap = Widget Function(BuildContext, Router);

Widget _defaultRouterWrap(context, router) => router;

class CarrotScaffold extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final PreferredSizeWidget? bottomBar;
  final CarrotLayoutBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;
  final CarrotRouter? router;

  const CarrotScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomBar,
    this.drawer,
    this.drawerScrimColor,
    this.drawerWidth = 300.0,
  }) : router = null;

  CarrotScaffold.router({
    super.key,
    required this.router,
    this.appBar,
    this.bottomBar,
    this.drawer,
    this.drawerScrimColor,
    this.drawerWidth = 300.0,
    CarrotScaffoldRouterWrap routerWrapper = _defaultRouterWrap,
  }) : child = LayoutBuilder(
    builder: (context, constraints) {
      return routerWrapper(context, Router(
        restorationScopeId: "scaffold",
        routeInformationProvider: router!.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ));
    },
  );

  @override
  createState() => _CarrotScaffold();

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

class _CarrotScaffold extends State<CarrotScaffold> {
  final List<CarrotSheetEntry> _sheets = [];

  Size _appBarSize = Size.zero;
  Size _bottomBarSize = Size.zero;
  CarrotRouter? _router;
  ScrollController? _scrollController;
  ScrollNotificationObserverState? _scrollNotificationObserver;
  double _scrollPosition = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routingListenerAdd();
    _scrollListenerAdd();
  }

  @override
  void didUpdateWidget(CarrotScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.appBar == null && oldWidget.appBar != null) {
      setState(() {
        _appBarSize = Size.zero;
      });
    }

    if (widget.bottomBar == null && oldWidget.bottomBar != null) {
      setState(() {
        _bottomBarSize = Size.zero;
      });
    }
  }

  @override
  void dispose() {
    _routingListenerRemove();
    _scrollListenerRemove();

    super.dispose();
  }

  void _handleRoutingChange() async {
    _scrollListenerRemove();

    await Future.delayed(const Duration(milliseconds: 720));

    if (!mounted) {
      return;
    }

    setState(() {
      _scrollPosition = 0.0;
    });

    _scrollListenerAdd();
  }

  void _handleScroll(ScrollNotification notification) {
    var primaryScrollView = notification.context?.findAncestorWidgetOfExactType<CarrotPrimaryScrollView>();

    if (primaryScrollView == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _scrollController = primaryScrollView.scrollController;
      _scrollPosition = notification.metrics.pixels;
    });
  }

  void _routingListenerAdd() {
    _router = widget.router;
    _router?.addListener(_handleRoutingChange);
  }

  void _routingListenerRemove() {
    _router?.removeListener(_handleRoutingChange);
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

  void _removeSheet(CarrotSheetEntry entry) {
    setState(() {
      _sheets.remove(entry);
    });
  }

  void _showSheet(CarrotSheetEntry entry) {
    setState(() {
      _sheets.add(entry);
    });
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
      removeSheetFunction: _removeSheet,
      showSheetFunction: _showSheet,
      child: HeroControllerScope(
        controller: HeroController(
          createRectTween: _heroAnimationTween,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.carrotTheme.background,
          ),
          child: Stack(
            children: [
              // main body
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

              // sheets
              for (int i = 0; i < _sheets.length; ++i)
                CarrotSheetGestureDetector(
                  align: _sheets[i].align,
                  axis: _sheets[i].axis,
                  hasFocus: i == _sheets.length - 1,
                  scrimColor: _sheets[i].scrimColor ?? context.carrotTheme.scrimColor,
                  onClose: () => _removeSheet(_sheets[i]),
                  onOpen: () {},
                  child: StatefulBuilder(
                    key: ValueKey(_sheets[i].hashCode),
                    builder: (context, setState) => _sheets[i].builder(context, _sheets[i]),
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
    final content = Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
  final CarrotLayoutBuilder? drawer;
  final Color? drawerScrimColor;
  final double drawerWidth;

  const _CarrotScaffoldView({
    required this.child,
    required this.drawerWidth,
    this.drawer,
    this.drawerScrimColor,
  });

  @override
  Widget build(BuildContext context) {
    final appView = context.carrotAppView;

    switch (appView.state) {
      case CarrotAppViewState.phone:
        return _CarrotScaffoldViewPhone(
          drawer: drawer,
          drawerScrimColor: drawerScrimColor,
          drawerWidth: drawerWidth,
          child: child,
        );

      case CarrotAppViewState.tablet:
        return _CarrotScaffoldViewTablet(
          drawer: drawer,
          drawerScrimColor: drawerScrimColor,
          drawerWidth: drawerWidth,
          child: child,
        );

      case CarrotAppViewState.tabletLarge:
        return _CarrotScaffoldViewTabletLarge(
          drawer: drawer,
          drawerWidth: drawerWidth,
          child: child,
        );
    }
  }
}

class _CarrotScaffoldViewPhone extends StatelessWidget {
  final Widget child;
  final CarrotLayoutBuilder? drawer;
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
  final CarrotLayoutBuilder? drawer;
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
  final CarrotLayoutBuilder? drawer;
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
  final _SheetToggle removeSheetFunction;
  final _SheetToggle showSheetFunction;

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
    required this.removeSheetFunction,
    required this.showSheetFunction,
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
  void removeSheet(CarrotSheetEntry entry) {
    removeSheetFunction(entry);
  }

  @override
  void showSheet(CarrotSheetEntry entry) {
    showSheetFunction(entry);
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

typedef _MeasureSizeCallback = void Function(Size);
typedef _DrawerToggle = void Function(BuildContext);
typedef _SheetToggle = void Function(CarrotSheetEntry);

abstract class CarrotScaffoldController {
  Size get appBarSize;

  Size get bottomBarSize;

  bool get hasAppBar;

  bool get hasBottomBar;

  bool get hasDrawer;

  double get scrollPosition;

  void drawerClose(BuildContext context);

  void drawerOpen(BuildContext context);

  void removeSheet(CarrotSheetEntry entry);

  void showSheet(CarrotSheetEntry entry);
}

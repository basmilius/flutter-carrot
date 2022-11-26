import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation.dart';
import '../app/extensions/extensions.dart';
import 'primitive/primitive.dart';

typedef CarrotTabChangeCallback = void Function(int index);

const _kDefaultTabCurve = CarrotCurves.swiftOutCurve;
const _kDefaultTabDuration = Duration(milliseconds: 540);

class CarrotTab extends StatelessWidget {
  final Widget child;
  final String? label;

  const CarrotTab({
    super.key,
    required this.child,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final carrotTheme = context.carrotTheme;
    final provider = _CarrotTabProvider.of(context);
    final active = provider.controller.animation.value.round() == provider.index;

    return Semantics(
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: CarrotBackgroundTap(
          background: carrotTheme.gray[100].withOpacity(0),
          backgroundTap: carrotTheme.gray[100],
          duration: _kDefaultTabDuration,
          onTap: () => provider.controller.index = provider.index,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            child: AnimatedDefaultTextStyle(
              curve: _kDefaultTabCurve,
              duration: _kDefaultTabDuration,
              style: carrotTheme.typography.body1.copyWith(
                color: active ? carrotTheme.primary : carrotTheme.gray[600],
                fontWeight: FontWeight.w500,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CarrotTabBar extends StatefulWidget {
  final CarrotTabController controller;
  final List<CarrotTab> tabs;

  const CarrotTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  createState() => _CarrotTabBarState();
}

class _CarrotTabBarState extends State<CarrotTabBar> with SingleTickerProviderStateMixin {
  final Map<int, Size> _tabSizes = {};

  double get height => _tabSizes.isEmpty ? 90 : _tabSizes.values.map((e) => e.height).reduce(math.max);

  @override
  void dispose() {
    widget.controller.animation.removeListener(_onAnimationUpdate);
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
    widget.controller.animation.addListener(_onAnimationUpdate);
  }

  double _calculateOffset(double index) {
    final offsets = _calculateOffsets();
    final lowerIndex = index.floor();
    final upperIndex = index.ceil();
    final deltaIndex = index - lowerIndex;
    final lowerOffset = offsets[lowerIndex];
    final upperOffset = offsets[upperIndex];

    return lowerOffset + (upperOffset - lowerOffset) * deltaIndex;
  }

  List<double> _calculateOffsets() {
    final offsets = <double>[];

    for (int i = 0; i < widget.tabs.length; i++) {
      offsets.add(_getOffset(i));
    }

    return offsets;
  }

  double _calculateWidth(double index) {
    final lowerIndex = index.floor();
    final upperIndex = index.ceil();
    final deltaIndex = index - lowerIndex;
    final lowerSize = _tabSizes[lowerIndex];
    final upperSize = _tabSizes[upperIndex];

    if (lowerSize != null && upperSize != null) {
      return lowerSize.width + (upperSize.width - lowerSize.width) * deltaIndex;
    }

    return 0;
  }

  double _getOffset(int index) {
    double offset = 0;

    for (int i = 0; i < index; i++) {
      offset += _tabSizes[i]?.width ?? 0;
    }

    return offset;
  }

  void _onAnimationUpdate() {
    setState(() {});
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  void _onSizeChange(int index, Size size) {
    setState(() {
      _tabSizes[index] = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wrappedTabs = List<Widget>.generate(widget.tabs.length, (index) {
      return _CarrotTabProvider(
        controller: widget.controller,
        index: index,
        child: CarrotSizeMeasureChild(
          onChange: (size) => _onSizeChange(index, size),
          child: widget.tabs[index],
        ),
      );
    });

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: height),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -15,
            right: -15,
            height: height,
            child: Flex(
              direction: Axis.horizontal,
              children: wrappedTabs,
            ),
          ),
          CarrotChangeNotifierBuilder(
            notifier: widget.controller.animation,
            builder: (context, animation) => Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1.5,
              child: _CarrotTabIndicator(
                offset: _calculateOffset(animation.value),
                width: _calculateWidth(animation.value) - 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarrotTabView extends StatefulWidget {
  final CarrotTabController controller;
  final List<Widget> children;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final ScrollPhysics physics;
  final double viewportFraction;

  const CarrotTabView({
    super.key,
    required this.controller,
    required this.children,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.physics = const BouncingScrollPhysics(),
    this.viewportFraction = 1.0,
  });

  @override
  createState() => _CarrotTabViewState();
}

class _CarrotTabViewState extends State<CarrotTabView> {
  late PageController _pageController;
  CarrotTabController? _tabController;
  late List<Widget> _children;
  late List<Widget> _childrenWithKey;
  int? _currentIndex;
  int _warpUnderwayCount = 0;

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateController();

    _currentIndex = widget.controller.index;
    _pageController = PageController(
      initialPage: _currentIndex!,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void didUpdateWidget(CarrotTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _updateController();
      _currentIndex = _tabController!.index;
      ++_warpUnderwayCount;
      _pageController.jumpToPage(_currentIndex!);
      --_warpUnderwayCount;
    }

    if (widget.children != oldWidget.children && _warpUnderwayCount == 0) {
      _updateChildren();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  void _disposeController() {
    if (_tabController != null) {
      _tabController!.animation.removeListener(_handleAnimationTick);
      _tabController = null;
    }
  }

  void _handleAnimationTick() {
    if (_warpUnderwayCount > 0 || !_tabController!.indexIsChanging) {
      return;
    }

    if (_tabController!.index != _currentIndex) {
      _currentIndex = _tabController!.index;
      _warpToCurrentIndex();
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0) {
      return false;
    }

    if (notification.depth != 0) {
      return false;
    }

    ++_warpUnderwayCount;

    if (notification is ScrollUpdateNotification && !_tabController!.indexIsChanging) {
      if ((_pageController.page! - _tabController!.index).abs() > 1.0) {
        _tabController!.index = _pageController.page!.round();
        _currentIndex = _tabController!.index;
      }
      _tabController!.offset = clampDouble(_pageController.page! - _tabController!.index, -1.0, 1.0);
    } else if (notification is ScrollEndNotification) {
      _tabController!.index = _pageController.page!.round();
      _currentIndex = _tabController!.index;

      if (!_tabController!.indexIsChanging) {
        _tabController!.offset = clampDouble(_pageController.page! - _tabController!.index, -1.0, 1.0);
      }
    }

    --_warpUnderwayCount;

    return false;
  }

  void _updateChildren() {
    _children = widget.children;
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(_children);
  }

  void _updateController() {
    _disposeController();
    _tabController = widget.controller;
    _tabController!.animation.addListener(_handleAnimationTick);
  }

  Future<void> _warpToCurrentIndex() async {
    if (!mounted) {
      return;
    }

    if (_pageController.page == _currentIndex!.toDouble()) {
      return;
    }

    final duration = _tabController!.animationDuration;
    final previousIndex = _tabController!.previousIndex;

    if ((_currentIndex! - previousIndex).abs() == 1) {
      if (duration == Duration.zero) {
        _pageController.jumpToPage(_currentIndex!);
        return;
      }

      ++_warpUnderwayCount;
      await _pageController.animateToPage(
        _currentIndex!,
        curve: _tabController!.animationCurve,
        duration: duration,
      );
      --_warpUnderwayCount;
      return;
    }

    assert((_currentIndex! - previousIndex).abs() > 1);

    final initialPage = _currentIndex! > previousIndex ? _currentIndex! - 1 : _currentIndex! + 1;
    final originalChildren = _childrenWithKey;

    setState(() {
      ++_warpUnderwayCount;
      _childrenWithKey = List<Widget>.of(_childrenWithKey, growable: false);
      final temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });

    _pageController.jumpToPage(initialPage);

    if (duration == Duration.zero) {
      _pageController.jumpToPage(_currentIndex!);
      return;
    }

    await _pageController.animateToPage(
      _currentIndex!,
      curve: _tabController!.animationCurve,
      duration: duration,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      --_warpUnderwayCount;

      if (widget.children != _children) {
        _updateChildren();
      } else {
        _childrenWithKey = originalChildren;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: widget.controller.animationCurve,
      duration: widget.controller.animationDuration,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: PageView(
          controller: _pageController,
          clipBehavior: widget.clipBehavior,
          dragStartBehavior: widget.dragStartBehavior,
          physics: const NeverScrollableScrollPhysics(),
          // physics: const PageScrollPhysics().applyTo(widget.physics),
          children: _childrenWithKey,
        ),
      ),
    );
  }
}

class CarrotTabViewWithGap extends StatelessWidget {
  final CarrotTabController controller;
  final List<Widget> children;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final double gap;
  final ScrollPhysics physics;
  final double viewportFraction;

  const CarrotTabViewWithGap({
    super.key,
    required this.controller,
    required this.children,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.gap = 0,
    this.physics = const BouncingScrollPhysics(),
    this.viewportFraction = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wrappedChildren = List<Widget>.generate(
            children.length,
            (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: gap),
                  child: children[index],
                ));

        return CarrotTabView(
          controller: controller,
          clipBehavior: clipBehavior,
          dragStartBehavior: dragStartBehavior,
          physics: physics,
          viewportFraction: viewportFraction + (gap * 2 / constraints.maxWidth),
          children: wrappedChildren,
        );
      },
    );
  }
}

class CarrotTabController extends ChangeNotifier {
  final int length;
  final AnimationController _animationController;
  final Curve _animationCurve;
  final Duration _animationDuration;

  int _index;
  int _indexIsChangingCount = 0;
  int _previousIndex;

  Animation<double> get animation => _animationController.view;

  Curve get animationCurve => _animationCurve;

  Duration get animationDuration => _animationDuration;

  int get index => _index;

  bool get indexIsChanging => _indexIsChangingCount != 0;

  int get previousIndex => _previousIndex;

  set index(int value) => _changeIndex(value);

  double get offset => _animationController.value - _index.toDouble();

  set offset(double value) {
    if (value == offset) {
      return;
    }

    _animationController.value = value + _index.toDouble();
  }

  CarrotTabController({
    required this.length,
    required TickerProvider vsync,
    Curve? animationCurve,
    Duration? animationDuration,
    int initialIndex = 0,
  })  : assert(length >= 0),
        assert(length == 0 || initialIndex < length),
        _animationController = AnimationController.unbounded(
          value: initialIndex.toDouble(),
          vsync: vsync,
        ),
        _animationCurve = animationCurve ?? _kDefaultTabCurve,
        _animationDuration = animationDuration ?? _kDefaultTabDuration,
        _index = initialIndex,
        _previousIndex = initialIndex;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeIndex(
    int index, {
    Curve? curve,
    Duration? duration,
  }) {
    curve ??= _animationCurve;
    duration ??= _animationDuration;

    _previousIndex = this.index;
    _index = index;

    if (duration > Duration.zero) {
      ++_indexIsChangingCount;
      notifyListeners();

      _animationController
          .animateTo(
        _index.toDouble(),
        curve: curve,
        duration: duration,
      )
          .whenCompleteOrCancel(() {
        --_indexIsChangingCount;
        notifyListeners();
      });
    } else {
      ++_indexIsChangingCount;
      _animationController.value = _index.toDouble();
      --_indexIsChangingCount;
      notifyListeners();
    }
  }

  void animateTo(int index, {Curve? curve, Duration? duration}) {
    _changeIndex(
      index,
      curve: curve,
      duration: duration,
    );
  }
}

class _CarrotTabProvider extends InheritedWidget {
  final CarrotTabController controller;
  final int index;

  const _CarrotTabProvider({
    required super.child,
    required this.controller,
    required this.index,
  });

  @override
  bool updateShouldNotify(_CarrotTabProvider oldWidget) => true;

  static _CarrotTabProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_CarrotTabProvider>();

    if (provider == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          '_CarrotTabProvider.of() called with a context that does not contain a _CarrotTabProvider.',
        ),
      ]);
    }

    return provider;
  }
}

class _CarrotTabIndicator extends StatelessWidget {
  final double offset;
  final double width;

  const _CarrotTabIndicator({
    required this.offset,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final carrotTheme = context.carrotTheme;

    return CustomPaint(
      painter: _CarrotTabIndicatorPainter(
        offset: offset,
        width: width,
        activeColor: carrotTheme.primary,
        trackColor: carrotTheme.gray[50],
      ),
    );
  }
}

class _CarrotTabIndicatorPainter extends CustomPainter {
  final double offset;
  final double width;
  final Color activeColor;
  final Color trackColor;
  final Paint _activePaint;
  final Paint _trackPaint;

  _CarrotTabIndicatorPainter({
    required this.offset,
    required this.width,
    required this.activeColor,
    required this.trackColor,
  })  : _activePaint = Paint()
          ..color = activeColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
        _trackPaint = Paint()
          ..color = trackColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, _trackPaint);

    final activePath = Path()
      ..moveTo(offset, 0)
      ..lineTo(offset + width, 0);

    canvas.drawPath(activePath, _activePaint);
  }

  @override
  bool shouldRepaint(_CarrotTabIndicatorPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.width != width;
  }
}

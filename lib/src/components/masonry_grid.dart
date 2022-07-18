import 'package:flutter/widgets.dart';

class CarrotMasonryGrid extends StatefulWidget {
  final int columns;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool staggered;

  const CarrotMasonryGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.staggered = false,
  })  : assert(columns >= 1),
        assert(crossAxisSpacing >= 0),
        assert(mainAxisSpacing >= 0);

  @override
  createState() => _CarrotMasonryGrid();
}

class _CarrotMasonryGrid extends State<CarrotMasonryGrid> {
  int _renderId = 0;
  final Map<int, GlobalKey> _childKeys = {};

  late List<List<Widget>> _columnItems;
  late List<GlobalKey> _columnKeys;

  int get smallestColumnIndex {
    int smallestColumnIndex = 0;

    try {
      final renderColumn = List<RenderBox?>.generate(_columnKeys.length, (index) => _columnKeys[index].currentContext?.findRenderObject() as RenderBox?);
      final columnHeight = List<double>.generate(renderColumn.length, (index) => renderColumn[index]!.size.height);

      // note(Bas): probably should use value here.
      columnHeight.asMap().forEach((key, value) {
        if (columnHeight[key] < columnHeight[smallestColumnIndex]) {
          smallestColumnIndex = key;
        }
      });
    } catch (err) {
      debugPrint("CarrotMasonryGrid -> $err");
    }

    return smallestColumnIndex;
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.children != widget.children || oldWidget.columns != widget.columns || oldWidget.crossAxisAlignment != widget.crossAxisAlignment || oldWidget.crossAxisSpacing != widget.crossAxisSpacing || oldWidget.mainAxisSpacing != widget.mainAxisSpacing || oldWidget.staggered != widget.staggered) {
      _renderId = 0;
      _columnItems = List.generate(widget.columns, (_) => []);
      _columnKeys = List.generate(widget.columns, (_) => GlobalKey());
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _columnItems = List.generate(widget.columns, (_) => []);
    _columnKeys = List.generate(widget.columns, (_) => GlobalKey());

    super.initState();
  }

  void renderChildren() {
    if (!widget.staggered && _renderId < widget.children.length) {
      renderOrdered();
    } else if (widget.staggered && _renderId < widget.children.length) {
      Future.microtask(() => renderStaggered());
    }
  }

  void renderOrdered() {
    for (int i = _renderId; i < widget.children.length; ++i) {
      _columnItems[i % widget.columns].add(renderChild(i, widget.children[i]));
    }

    setState(() {
      _renderId = widget.children.length;
    });
  }

  void renderStaggered() {
    int columnIndex = smallestColumnIndex;
    _columnItems[columnIndex].add(renderChild(_renderId, widget.children[_renderId]));

    setState(() {
      ++_renderId;
    });
  }

  Widget renderChild(int index, Widget child) {
    if (!_childKeys.containsKey(index)) {
      _childKeys[index] = GlobalKey();
    }

    return Padding(
      key: _childKeys[index],
      padding: EdgeInsets.only(bottom: widget.mainAxisSpacing),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    renderChildren();

    final columns = widget.crossAxisSpacing == 0
        ? List.generate(
            widget.columns,
            (index) => Expanded(
                  child: Column(
                    key: _columnKeys[index],
                    crossAxisAlignment: widget.crossAxisAlignment,
                    children: _columnItems[index],
                  ),
                ))
        : List.generate(
            widget.columns + (widget.columns - 1),
            (index) => index.isEven
                ? Expanded(
                    child: Column(
                      key: _columnKeys[(index / 2).floor()],
                      crossAxisAlignment: widget.crossAxisAlignment,
                      children: _columnItems[(index / 2).floor()],
                    ),
                  )
                : SizedBox(
                    width: widget.crossAxisSpacing,
                  ));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns,
    );
  }
}

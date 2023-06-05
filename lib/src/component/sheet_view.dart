import 'package:flutter/widgets.dart';

import 'primitive/primitive.dart';
import 'scroll_view.dart';
import 'sheet_pane.dart';

typedef CarrotSheetViewBuilder = Widget Function(BuildContext, ScrollController);

class CarrotSheetView extends StatefulWidget {
  final Color? backgroundColor;
  final CarrotSheetViewBuilder builder;
  final WidgetBuilder? headerBuilder;

  const CarrotSheetView({
    super.key,
    required this.builder,
    this.backgroundColor,
    this.headerBuilder,
  });

  factory CarrotSheetView.singleChildScrollView({
    required WidgetBuilder builder,
    Color? backgroundColor,
    WidgetBuilder? headerBuilder,
  }) =>
      CarrotSheetView(
        backgroundColor: backgroundColor,
        headerBuilder: headerBuilder,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Builder(
            builder: builder,
          ),
        ),
      );

  @override
  createState() => _CarrotSheetViewState();
}

class _CarrotSheetViewState extends State<CarrotSheetView> {
  final _headerKey = GlobalKey(debugLabel: 'sheet_view:header');

  Size _headerSize = Size.zero;

  @override
  void didUpdateWidget(CarrotSheetView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.headerBuilder == null) {
      setState(() {
        _headerSize = Size.zero;
      });
    }
  }

  void _onHeaderSizeChange(Size size) {
    setState(() {
      _headerSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: Stack(
          children: [
            if (widget.headerBuilder != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CarrotSizeMeasureChild(
                  onChange: _onHeaderSizeChange,
                  child: Builder(
                    key: _headerKey,
                    builder: widget.headerBuilder!,
                  ),
                ),
              ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) => _CarrotSheetViewSheetScrollable(
                  builder: widget.builder,
                  constraints: constraints,
                  headerSize: _headerSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarrotSheetViewSheetScrollable extends StatefulWidget {
  final CarrotSheetViewBuilder builder;
  final BoxConstraints constraints;
  final Size headerSize;

  const _CarrotSheetViewSheetScrollable({
    required this.builder,
    required this.constraints,
    required this.headerSize,
  });

  @override
  createState() => _CarrotSheetViewSheetScrollableState();
}

class _CarrotSheetViewSheetScrollableState extends State<_CarrotSheetViewSheetScrollable> {
  final backupScrollController = ScrollController();

  double get minimumSizeFactor => 1 - widget.headerSize.height / widget.constraints.maxHeight;

  Widget _buildSheet(BuildContext context, [ScrollController? scrollController]) {
    scrollController ??= backupScrollController;

    return CarrotSheetPane(
      isHandleVisible: widget.headerSize.height > 0,
      child: CarrotPrimaryScrollView(
        scrollController: scrollController,
        child: Builder(
          builder: (context) => widget.builder(context, scrollController!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (minimumSizeFactor == 1) {
      return _buildSheet(context);
    }

    return DraggableScrollableSheet(
      initialChildSize: minimumSizeFactor,
      minChildSize: minimumSizeFactor,
      maxChildSize: 1,
      snap: false,
      builder: _buildSheet,
    );
  }
}

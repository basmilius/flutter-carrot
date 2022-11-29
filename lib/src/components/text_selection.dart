import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import 'text_selection_toolbar.dart';

const double _arrowScreenPadding = 26.0;
const double _selectionHandleOverlap = 1.5;
const double _selectionHandleRadius = 6.0;

class CarrotTextSelectionControls extends TextSelectionControls {
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    startGlyphHeight ??= textLineHeight;
    endGlyphHeight ??= textLineHeight;

    final Widget customPaint = CustomPaint(
      painter: _TextSelectionHandlePainter(context.carrotTheme.primary[500]),
    );

    switch (type) {
      case TextSelectionHandleType.left:
        return SizedBox.fromSize(
          size: getHandleSize(startGlyphHeight),
          child: customPaint,
        );

      case TextSelectionHandleType.right:
        final size = getHandleSize(endGlyphHeight);

        return Transform(
          transform: Matrix4.identity()
            ..translate(size.width / 2, size.height / 2)
            ..rotateZ(math.pi)
            ..translate(-size.width / 2, -size.height / 2),
          child: SizedBox.fromSize(
            size: size,
            child: customPaint,
          ),
        );

      case TextSelectionHandleType.collapsed:
        return const SizedBox();
    }
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return CarrotTextSelectionControlsToolbar(
      clipboardStatus: clipboardStatus,
      endpoints: endpoints,
      globalEditableRegion: globalEditableRegion,
      handleCut: canCut(delegate) ? () => handleCut(delegate, clipboardStatus) : null,
      handleCopy: canCopy(delegate) ? () => handleCopy(delegate, clipboardStatus) : null,
      handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
      handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
      selectionMidpoint: position,
      textLineHeight: textLineHeight,
    );
  }

  @override
  Offset getHandleAnchor(
    TextSelectionHandleType type,
    double textLineHeight, [
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    startGlyphHeight ??= textLineHeight;
    endGlyphHeight ??= textLineHeight;

    final Size size;

    switch (type) {
      case TextSelectionHandleType.left:
        size = getHandleSize(startGlyphHeight);
        return Offset(size.width / 2, size.height);

      case TextSelectionHandleType.right:
        size = getHandleSize(endGlyphHeight);
        return Offset(size.width / 2, size.height - 2 * _selectionHandleRadius + _selectionHandleOverlap);

      case TextSelectionHandleType.collapsed:
        size = getHandleSize(textLineHeight);
        return Offset(size.width / 2, textLineHeight + (size.height - textLineHeight) / 2);
    }
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size(
      _selectionHandleRadius * 2,
      textLineHeight + _selectionHandleRadius * 2 - _selectionHandleOverlap,
    );
  }
}

class CarrotTextSelectionControlsToolbar extends StatefulWidget {
  final ClipboardStatusNotifier? clipboardStatus;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback? handleCopy;
  final VoidCallback? handleCut;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final Offset selectionMidpoint;
  final double textLineHeight;

  const CarrotTextSelectionControlsToolbar({
    super.key,
    required this.clipboardStatus,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCopy,
    required this.handleCut,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
  });

  @override
  createState() => _CarrotTextSelectionControlsToolbar();
}

class _CarrotTextSelectionControlsToolbar extends State<CarrotTextSelectionControlsToolbar> {
  late ClipboardStatusNotifier _clipboardStatus;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.clipboardStatus != widget.clipboardStatus) {
      _clipboardStatus.removeListener(_onClipboardStatusChanged);
      _clipboardStatus.dispose();

      _clipboardStatus = widget.clipboardStatus ?? ClipboardStatusNotifier();
      _clipboardStatus.addListener(_onClipboardStatusChanged);

      if (widget.handlePaste != null) {
        _clipboardStatus.update();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (!_clipboardStatus.disposed) {
      _clipboardStatus.removeListener(_onClipboardStatusChanged);

      if (widget.clipboardStatus == null) {
        _clipboardStatus.dispose();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _clipboardStatus = widget.clipboardStatus ?? ClipboardStatusNotifier();
    _clipboardStatus.addListener(_onClipboardStatusChanged);
    _clipboardStatus.update();
  }

  void _onClipboardStatusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.handlePaste != null && _clipboardStatus.value == ClipboardStatus.unknown) {
      return const SizedBox(width: .0, height: .0);
    }

    final mediaQuery = MediaQuery.of(context);

    final double anchorX = (widget.selectionMidpoint.dx + widget.globalEditableRegion.left).clamp(
      _arrowScreenPadding + mediaQuery.padding.left,
      mediaQuery.size.width - mediaQuery.padding.right - _arrowScreenPadding,
    );

    final Offset anchorAbove = Offset(anchorX, widget.endpoints.first.point.dy - widget.textLineHeight + widget.globalEditableRegion.top);
    final Offset anchorBelow = Offset(anchorX, widget.endpoints.last.point.dy + widget.globalEditableRegion.top);

    final items = <Widget>[];
    final Widget onePhysicalPixelVerticalDivider = SizedBox(width: .5 / mediaQuery.devicePixelRatio);

    void addToolbarButton(String text, VoidCallback onPressed) {
      if (items.isNotEmpty) {
        items.add(onePhysicalPixelVerticalDivider);
      }

      items.add(CarrotTextSelectionToolbarButton.text(
        context: context,
        text: text,
        onPressed: onPressed,
      ));
    }

    if (widget.handleCut != null) {
      /// todo(Bas): localize
      addToolbarButton("Cut", widget.handleCut!);
    }

    if (widget.handleCopy != null) {
      /// todo(Bas): localize
      addToolbarButton("Copy", widget.handleCopy!);
    }

    if (widget.handlePaste != null && _clipboardStatus.value == ClipboardStatus.pasteable) {
      /// todo(Bas): localize
      addToolbarButton("Paste", widget.handlePaste!);
    }

    if (widget.handleSelectAll != null) {
      /// todo(Bas): localize
      addToolbarButton("Select All", widget.handleSelectAll!);
    }

    if (items.isEmpty) {
      return const SizedBox(width: .0, height: .0);
    }

    return CarrotTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      children: items,
    );
  }
}

class _TextSelectionHandlePainter extends CustomPainter {
  final Color color;

  const _TextSelectionHandlePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const double halfStrokeWidth = 1.0;
    final Paint paint = Paint()..color = color;

    final Rect circle = Rect.fromCircle(
      center: const Offset(_selectionHandleRadius, _selectionHandleRadius),
      radius: _selectionHandleRadius,
    );

    final Rect line = Rect.fromPoints(
      const Offset(
        _selectionHandleRadius - halfStrokeWidth,
        2 * _selectionHandleRadius - _selectionHandleOverlap,
      ),
      Offset(_selectionHandleRadius + halfStrokeWidth, size.height),
    );

    final Path path = Path()
      ..addOval(circle)
      ..addRect(line);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) => color != oldPainter.color;
}

final carrotTextSelectionControls = CarrotTextSelectionControls();

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import 'basic.dart';
import 'button.dart';
import 'contained_button.dart';
import 'overlay.dart';
import 'primitive/primitive.dart';
import 'scroll/scroll.dart';
import 'scroll_view.dart';
import 'text_button.dart';

typedef CarrotDialogWidgetBuilder = Widget? Function(BuildContext);

const double _kDefaultDialogWidth = 480;
const EdgeInsets _kDefaultDialogPadding = EdgeInsets.all(27);

class CarrotDialog<T> extends StatefulWidget {
  final CarrotOverlayBaseClose<T> close;
  final Widget? content;
  final EdgeInsets padding;
  final ScrollController? scrollController;
  final double width;
  final CarrotDialogWidgetBuilder? contentBuilder;
  final CarrotDialogWidgetBuilder? footerBuilder;
  final CarrotDialogWidgetBuilder? headerBuilder;

  const CarrotDialog({
    super.key,
    required this.close,
    this.content,
    this.padding = _kDefaultDialogPadding,
    this.scrollController,
    this.width = _kDefaultDialogWidth,
    this.contentBuilder,
    this.footerBuilder,
    this.headerBuilder,
  });

  @override
  createState() => _CarrotDialog();

  Widget? buildContent(BuildContext context) {
    return contentBuilder?.call(context) ?? content;
  }

  Widget? buildFooter(BuildContext context) {
    return footerBuilder?.call(context);
  }

  Widget? buildHeader(BuildContext context) {
    return headerBuilder?.call(context);
  }
}

class _CarrotDialog extends State<CarrotDialog> {
  Size _footerSize = Size.zero;
  Size _headerSize = Size.zero;

  late ScrollController _scrollController;

  @override
  void didUpdateWidget(CarrotDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController = widget.scrollController ?? ScrollController();
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.carrotTheme;

    final footer = widget.buildFooter(context);
    final header = widget.buildHeader(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxHeight: 600,
        maxWidth: widget.width,
        minWidth: widget.width,
      ),
      decoration: BoxDecoration(
        borderRadius: theme.borderRadius * 1.5,
        color: theme.gray[0],
      ),
      child: DefaultTextStyle(
        style: theme.typography.body1,
        textAlign: TextAlign.center,
        child: Stack(
          children: [
            CarrotScrollView(
              padding: widget.padding.copyWith(
                top: math.max(widget.padding.top, _headerSize.height),
                bottom: math.max(widget.padding.top, _footerSize.height),
              ),
              physics: const CarrotBouncingScrollPhysics.notAlways(),
              scrollController: _scrollController,
              scrollPadding: EdgeInsets.only(
                top: _headerSize.height - widget.padding.top,
                bottom: _footerSize.height - widget.padding.bottom,
              ),
              child: Builder(
                builder: (context) => widget.buildContent(context) ?? Container(),
              ),
            ),
            if (header != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CarrotSizeMeasureChild(
                  child: header,
                  onChange: (size) => setState(() => _headerSize = size),
                ),
              ),
            if (footer != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CarrotSizeMeasureChild(
                  child: footer,
                  onChange: (size) => setState(() => _footerSize = size),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CarrotDialogButton<T> extends StatelessWidget {
  final bool isPrimary;
  final String label;
  final T? result;

  const CarrotDialogButton.primary({
    super.key,
    required this.label,
    this.result,
  }) : isPrimary = true;

  const CarrotDialogButton.secondary({
    super.key,
    required this.label,
    this.result,
  }) : isPrimary = false;

  @override
  Widget build(BuildContext context) {
    final dialog = context.findAncestorStateOfType<_CarrotDialog>();
    final theme = context.carrotTheme;

    assert(dialog != null);

    void onTap() {
      dialog!.widget.close(result);
    }

    List<Widget> children = [
      Text(label),
    ];

    final buttonSize = context.carrotAppView.isPhone ? CarrotButtonSize.small : CarrotButtonSize.medium;

    if (isPrimary) {
      return CarrotContainedButton(
        color: theme.primary,
        size: buttonSize,
        onTap: onTap,
        children: children,
      );
    }

    return CarrotTextButton(
      size: buttonSize,
      onTap: onTap,
      children: children,
    );
  }
}

class CarrotDialogButtons extends StatelessWidget {
  final List<CarrotDialogButton> buttons;

  const CarrotDialogButtons({
    super.key,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.carrotTheme;
    final Widget content;

    if (context.carrotAppView.isPhone) {
      content = CarrotColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        gap: 6,
        children: buttons,
      );
    } else {
      content = CarrotRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        gap: 15,
        children: buttons.reversed.toList(),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.gray[0],
              ),
            ),
          ),
        ),
        Padding(
          padding: _kDefaultDialogPadding,
          child: content,
        ),
      ],
    );
  }
}

class CarrotDialogTitle extends StatelessWidget {
  final Widget child;

  const CarrotDialogTitle({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.carrotTheme;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.gray[0],
              ),
            ),
          ),
        ),
        Padding(
          padding: _kDefaultDialogPadding.copyWith(
            bottom: 15,
          ),
          child: DefaultTextStyle(
            style: theme.typography.headline4,
            textAlign: TextAlign.center,
            child: child,
          ),
        ),
      ],
    );
  }
}

class CarrotAlertDialog extends CarrotDialog<void> {
  final String okLabel;
  final Widget title;

  const CarrotAlertDialog({
    super.key,
    required super.close,
    required super.content,
    required this.title,
    this.okLabel = 'Ok',
    super.scrollController,
    super.width = _kDefaultDialogWidth,
  });

  @override
  Widget? buildFooter(BuildContext context) {
    return CarrotDialogButtons(
      buttons: [
        CarrotDialogButton.primary(label: okLabel),
      ],
    );
  }

  @override
  Widget? buildHeader(BuildContext context) {
    return CarrotDialogTitle(
      child: title,
    );
  }
}

class CarrotConfirmDialog extends CarrotDialog<bool> {
  final Widget title;

  const CarrotConfirmDialog({
    super.key,
    required super.close,
    required super.content,
    required this.title,
    super.scrollController,
    super.width = _kDefaultDialogWidth,
  });

  @override
  Widget? buildFooter(BuildContext context) {
    return const CarrotDialogButtons(
      buttons: [
        CarrotDialogButton.primary(label: "Abonneren", result: true),
        CarrotDialogButton.secondary(label: "Annuleren", result: false),
      ],
    );
  }

  @override
  Widget? buildHeader(BuildContext context) {
    return CarrotDialogTitle(
      child: title,
    );
  }
}

abstract class CarrotStatefulDialog<T> extends StatefulWidget {
  final CarrotOverlayBaseClose<T> close;
  final Widget? content;
  final EdgeInsets padding;
  final ScrollController? scrollController;
  final double width;

  const CarrotStatefulDialog({
    super.key,
    required this.close,
    this.content,
    this.padding = _kDefaultDialogPadding,
    this.scrollController,
    this.width = _kDefaultDialogWidth,
  });
}

abstract class CarrotStatefulDialogState<T, W extends CarrotStatefulDialog<T>> extends State<W> {
  Widget? buildContent(BuildContext context) {
    return null;
  }

  Widget? buildFooter(BuildContext context) {
    return null;
  }

  Widget? buildHeader(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CarrotDialog<T>(
      close: widget.close,
      content: widget.content,
      padding: widget.padding,
      scrollController: widget.scrollController,
      width: widget.width,
      contentBuilder: buildContent,
      footerBuilder: buildFooter,
      headerBuilder: buildHeader,
    );
  }
}

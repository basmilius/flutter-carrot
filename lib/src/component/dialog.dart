import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../extension/extension.dart';
import 'button.dart';
import 'column.dart';
import 'overlay.dart';
import 'primitive/primitive.dart';
import 'row.dart';
import 'scroll_view.dart';

typedef CarrotDialogWidgetBuilder = Widget? Function(BuildContext, ScrollController, Size, Size);

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
  createState() => _CarrotDialogState();

  Widget? buildContent(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    if (contentBuilder != null) {
      return contentBuilder!.call(context, scrollController, headerSize, footerSize);
    }

    return CarrotScrollView(
      padding: padding.copyWith(
        top: math.max(padding.top, headerSize.height),
        bottom: math.max(padding.top, footerSize.height),
      ),
      scrollController: scrollController,
      scrollPadding: EdgeInsets.only(
        top: headerSize.height - padding.top,
        bottom: footerSize.height - padding.bottom,
      ),
      child: content ?? Container(),
    );
  }

  Widget? buildFooter(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return footerBuilder?.call(context, scrollController, headerSize, footerSize);
  }

  Widget? buildHeader(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return headerBuilder?.call(context, scrollController, headerSize, footerSize);
  }
}

class _CarrotDialogState extends State<CarrotDialog> {
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

    final footer = widget.buildFooter(context, _scrollController, _headerSize, _footerSize);
    final header = widget.buildHeader(context, _scrollController, _headerSize, _footerSize);

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
        maxHeight: 600,
        maxWidth: widget.width,
        minWidth: widget.width,
      ),
      decoration: BoxDecoration(
        borderRadius: theme.borderRadius * 1.5,
        color: theme.defaults.content,
      ),
      child: DefaultTextStyle(
        style: theme.typography.body1,
        textAlign: TextAlign.center,
        child: Stack(
          children: [
            Builder(
              builder: (context) => widget.buildContent(context, _scrollController, _headerSize, _footerSize) ?? Container(),
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
    final dialog = context.findAncestorStateOfType<_CarrotDialogState>();

    assert(dialog != null);

    void onTap() {
      dialog!.widget.close(result);
    }

    List<Widget> children = [
      Text(label),
    ];

    final buttonSize = context.mediaQuery.isPhone ? CarrotButtonSize.small : CarrotButtonSize.medium;

    if (isPrimary) {
      return CarrotContainedButton(
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

    if (context.mediaQuery.isPhone) {
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
                color: theme.defaults.content,
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.defaults.content,
      ),
      child: Padding(
        padding: _kDefaultDialogPadding.copyWith(
          bottom: 15,
        ),
        child: DefaultTextStyle(
          style: theme.typography.headline4,
          textAlign: TextAlign.center,
          child: child,
        ),
      ),
    );
  }
}

class CarrotAlertDialog extends CarrotDialog<void> {
  final String? okLabel;
  final Widget title;

  const CarrotAlertDialog({
    super.key,
    required super.close,
    required super.content,
    required this.title,
    this.okLabel,
    super.scrollController,
    super.width = _kDefaultDialogWidth,
  });

  @override
  Widget? buildFooter(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return CarrotDialogButtons(
      buttons: [
        CarrotDialogButton.primary(
          label: okLabel ?? context.carrotStrings.ok,
        ),
      ],
    );
  }

  @override
  Widget? buildHeader(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return CarrotDialogTitle(
      child: title,
    );
  }
}

class CarrotConfirmDialog extends CarrotDialog<bool> {
  final String? cancelLabel;
  final String? okLabel;
  final Widget title;

  const CarrotConfirmDialog({
    super.key,
    required super.close,
    required super.content,
    required this.title,
    this.cancelLabel,
    this.okLabel,
    super.scrollController,
    super.width = _kDefaultDialogWidth,
  });

  @override
  Widget? buildFooter(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return CarrotDialogButtons(
      buttons: [
        CarrotDialogButton.primary(
          label: okLabel ?? context.carrotStrings.ok,
          result: true,
        ),
        CarrotDialogButton.secondary(
          label: cancelLabel ?? context.carrotStrings.cancel,
          result: false,
        ),
      ],
    );
  }

  @override
  Widget? buildHeader(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
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
  Widget? buildContent(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return null;
  }

  Widget? buildFooter(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
    return null;
  }

  Widget? buildHeader(BuildContext context, ScrollController scrollController, Size headerSize, Size footerSize) {
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

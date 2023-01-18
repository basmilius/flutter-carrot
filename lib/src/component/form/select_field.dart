import 'package:flutter/widgets.dart';

import '../../data/data.dart';
import '../../extension/extension.dart';
import '../../ui/ui.dart';
import '../icon.dart';
import '../nothing.dart';
import '../popup.dart';
import '../primitive/primitive.dart';
import 'form_field.dart';

abstract class CarrotSelectFieldEntry<T> {
  const CarrotSelectFieldEntry();

  Widget build(BuildContext context);
}

class CarrotSelectFieldOption<T> extends CarrotSelectFieldEntry<T> {
  final WidgetBuilder? builder;
  final bool enabled;
  final T value;

  const CarrotSelectFieldOption({
    required this.value,
    this.builder,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final formFieldTheme = CarrotFormFieldTheme.of(context);
    final selectField = context.dependOnInheritedWidgetOfExactType<_CarrotSelectFieldInherited>();

    assert(selectField != null);

    return CarrotBackgroundTap(
      background: formFieldTheme.background?.withOpacity(.0),
      backgroundTap: formFieldTheme.background,
      onTap: () => selectField?.state._setValue(value),
      child: Container(
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints(
          minHeight: 45,
        ),
        padding: formFieldTheme.padding.copyWith(
          top: 0,
          bottom: 0,
        ),
        child: Builder(
          builder: builder ?? (context) => _defaultOptionBuilder(context, this),
        ),
      ),
    );
  }

  static Widget _defaultOptionBuilder(BuildContext context, CarrotSelectFieldOption<dynamic> option) {
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return Text(
      '${option.value}',
      style: formFieldTheme.textStyle,
    );
  }
}

class CarrotSelectFieldOptionGroup<T> extends CarrotSelectFieldEntry<T> {
  final Widget label;
  final List<CarrotSelectFieldOption<T>> options;

  const CarrotSelectFieldOptionGroup({
    required this.label,
    required this.options,
  });

  Widget _buildOption(BuildContext context, int index) {
    return options[index].build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 9,
            left: 18,
            right: 18,
            bottom: 0,
          ),
          child: DefaultTextStyle(
            style: context.carrotTypography.body2.copyWith(
              fontSize: 15,
            ),
            child: label,
          ),
        ),
        ListView.builder(
          itemBuilder: _buildOption,
          itemCount: options.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}

class CarrotSelectField<T> extends StatefulWidget {
  final bool autofocus;
  final CarrotValueController<T?> controller;
  final bool enabled;
  final List<CarrotSelectFieldEntry<T>> options;
  final String? placeholder;

  const CarrotSelectField({
    super.key,
    required this.controller,
    required this.options,
    this.autofocus = false,
    this.enabled = true,
    this.placeholder,
  });

  @override
  createState() => _CarrotSelectFieldState<T>();
}

class _CarrotSelectFieldState<T> extends State<CarrotSelectField<T>> {
  late final CarrotPopupController _popupController;
  late CarrotValueController<T?> _valueController;
  Size _size = Size.zero;

  bool get hasValue => selected != null;

  CarrotSelectFieldOption<T>? get selected {
    for (final option in widget.options) {
      if (option is CarrotSelectFieldOptionGroup<T>) {
        for (final subOption in option.options) {
          if (subOption.value == widget.controller.value) {
            return subOption;
          }
        }
      }

      if (option is CarrotSelectFieldOption<T> && option.value == widget.controller.value) {
        return option;
      }
    }

    return null;
  }

  @override
  void didUpdateWidget(CarrotSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _valueController.removeListener(_onValueUpdated);
      _initController();
    }
  }

  @override
  void dispose() {
    _valueController.removeListener(_onValueUpdated);
    _popupController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initController();
    _initPopupController();
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (widget.placeholder == null) {
      return nothing;
    }

    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return Padding(
      padding: formFieldTheme.padding,
      child: Text(
        widget.placeholder!,
        style: formFieldTheme.textPlaceholderStyle,
      ),
    );
  }

  Widget _buildPopup(BuildContext context) {
    final appTheme = context.carrotTheme;
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: _size.width,
        minWidth: _size.width,
      ),
      decoration: BoxDecoration(
        border: formFieldTheme.border,
        borderRadius: appTheme.borderRadius,
        boxShadow: CarrotShadows.large,
        color: appTheme.defaults.content,
      ),
      child: ClipRRect(
        borderRadius: appTheme.borderRadius,
        child: ListView.builder(
          itemBuilder: _buildPopupItem,
          itemCount: widget.options.length,
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildPopupItem(BuildContext context, int index) {
    return _CarrotSelectFieldInherited(
      state: this,
      child: Builder(
        builder: widget.options[index].build,
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    assert(hasValue);

    return IgnorePointer(
      ignoring: true,
      child: ExcludeFocus(
        excluding: true,
        child: selected!.build(context),
      ),
    );
  }

  void _initController() {
    _valueController = widget.controller;
    _valueController.addListener(_onValueUpdated);
  }

  void _initPopupController() {
    _popupController = CarrotPopupController();
  }

  void _onSizeChanged(Size size) {
    setState(() {
      _size = size;
    });
  }

  void _onValueUpdated() {
    setState(() {});
  }

  void _setValue(T? value) {
    _popupController.close();
    widget.controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return CarrotPopup(
      controller: _popupController,
      content: _buildPopup,
      offset: const Offset(0, 30),
      placement: CarrotPopupPlacement.center,
      position: CarrotPopupPosition.below,
      child: CarrotBounceTap(
        onTap: () => _popupController.open(),
        child: CarrotSizeMeasureChild(
          onChange: _onSizeChanged,
          child: Focus(
            autofocus: widget.autofocus,
            child: CarrotFormField(
              enabled: widget.enabled,
              child: Row(
                children: [
                  _CarrotSelectFieldInherited(
                    state: this,
                    child: Expanded(
                      child: Builder(
                        builder: hasValue ? _buildPreview : _buildPlaceholder,
                      ),
                    ),
                  ),
                  Padding(
                    padding: formFieldTheme.padding,
                    child: CarrotIcon(
                      color: context.carrotTheme.primary,
                      glyph: 'angle-down',
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarrotSelectFieldInherited extends InheritedWidget {
  final _CarrotSelectFieldState<dynamic> state;

  const _CarrotSelectFieldInherited({
    required super.child,
    required this.state,
  });

  @override
  bool updateShouldNotify(_CarrotSelectFieldInherited oldWidget) {
    return oldWidget.state != state;
  }
}

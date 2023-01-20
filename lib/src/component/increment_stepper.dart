import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/data.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';
import '../ui/ui.dart';
import 'form/form.dart';
import 'icon.dart';
import 'primitive/primitive.dart';
import 'row.dart';

part 'increment_stepper_theme.dart';

enum CarrotIncrementStepperStyle {
  attached,
  attachedWithoutValue,
  detached,
  detachedWithoutValue,
}

class CarrotIncrementStepper extends StatefulWidget {
  final CarrotValueController<num>? controller;
  final num max;
  final num min;
  final num step;
  final CarrotIncrementStepperStyle style;
  final num? value;
  final CarrotValueChangedCallback<num>? onChanged;

  const CarrotIncrementStepper({
    super.key,
    this.controller,
    this.max = 10,
    this.min = 0,
    this.step = 1,
    this.style = CarrotIncrementStepperStyle.attached,
    this.value,
    this.onChanged,
  })  : assert((controller != null && value == null) || (controller == null && value != null)),
        assert(max > min),
        assert(value == null || (value >= min && value <= max)),
        assert(step > 0);

  @override
  createState() => _CarrotIncrementStepperState();
}

class _CarrotIncrementStepperState extends State<CarrotIncrementStepper> {
  late final TextEditingController _controller;
  late final NumberFormat _formatter;
  late final CarrotValueController<num> _valueController;
  late final FocusNode _focusNode;

  num get value => _valueController.value;

  String get valueAsString => _formatter.format(_valueController.value);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    int decimalCount = 0;

    if (widget.step.toString().contains('.')) {
      decimalCount = widget.step.toString().split('.')[1].length;
    }

    _formatter = NumberFormat(null, Localizations.localeOf(context).languageCode);
    _formatter.minimumFractionDigits = 0;
    _formatter.maximumFractionDigits = decimalCount;

    _controller = TextEditingController(
      text: valueAsString,
    );
  }

  @override
  void didUpdateWidget(CarrotIncrementStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onExternalControllerUpdated);
      widget.controller?.addListener(_onExternalControllerUpdated);
    }

    if (widget.value != null && widget.value != oldWidget.value) {
      _updateValue(widget.value!);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onExternalControllerUpdated);
    _valueController.removeListener(_onValueUpdated);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);

    _valueController = CarrotValueController(value: widget.value ?? widget.min);
    _valueController.addListener(_onValueUpdated);

    widget.controller?.addListener(_onExternalControllerUpdated);
  }

  void _decrement() {
    _updateValue(value - widget.step);
  }

  void _increment() {
    _updateValue(value + widget.step);
  }

  void _updateValue(num value) {
    _valueController.value = value.clamp(widget.min, widget.max);
  }

  void _onExternalControllerUpdated() {
    _updateValue(widget.controller!.value);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _controller.value = _controller.value.copyWith(
        composing: TextRange.empty,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        ),
        text: _controller.text,
      );
    } else {
      _updateValue(num.tryParse(_controller.text) ?? 0);
    }
  }

  void _onValueUpdated() {
    widget.onChanged?.call(value);

    if (widget.controller != null) {
      widget.controller!.value = _valueController.value;
    }

    setState(() {
      _controller.text = valueAsString;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incrementStepperTheme = CarrotIncrementStepperTheme.of(context);

    Widget controls = CarrotRow(
      gap: widget.style == CarrotIncrementStepperStyle.detachedWithoutValue ? incrementStepperTheme.gap : 0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _CarrotIncrementStepperButton(
          disabled: value <= widget.min,
          icon: 'minus',
          style: widget.style,
          onTap: _decrement,
        ),
        if (widget.style == CarrotIncrementStepperStyle.attached || widget.style == CarrotIncrementStepperStyle.detached)
          _CarrotIncrementStepperValue(
            controller: _controller,
            focusNode: _focusNode,
            style: widget.style,
          ),
        _CarrotIncrementStepperButton(
          disabled: value >= widget.max,
          icon: 'plus',
          style: widget.style,
          onTap: _increment,
        ),
      ],
    );

    if (widget.style == CarrotIncrementStepperStyle.attached || widget.style == CarrotIncrementStepperStyle.attachedWithoutValue) {
      controls = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: incrementStepperTheme.borderRadius,
          color: incrementStepperTheme.background,
        ),
        child: controls,
      );
    }

    return controls;
  }
}

class _CarrotIncrementStepperButton extends StatelessWidget {
  final bool disabled;
  final String icon;
  final CarrotIncrementStepperStyle style;
  final GestureTapCallback onTap;

  const _CarrotIncrementStepperButton({
    required this.disabled,
    required this.icon,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final incrementStepperTheme = CarrotIncrementStepperTheme.of(context);

    Widget control = CarrotRepeatingBounceTap(
      disabled: disabled,
      onTap: onTap,
      child: Padding(
        padding: incrementStepperTheme.padding,
        child: CarrotIcon(
          color: incrementStepperTheme.foreground,
          glyph: icon,
          size: incrementStepperTheme.iconSize,
        ),
      ),
    );

    if (style == CarrotIncrementStepperStyle.detached || style == CarrotIncrementStepperStyle.detachedWithoutValue) {
      control = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: incrementStepperTheme.background,
        ),
        child: control,
      );
    }

    return CarrotDisabled.opacity(
      disabled: disabled,
      opacity: .5,
      child: control,
    );
  }
}

class _CarrotIncrementStepperValue extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final CarrotIncrementStepperStyle style;

  const _CarrotIncrementStepperValue({
    required this.controller,
    required this.focusNode,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final incrementStepperTheme = CarrotIncrementStepperTheme.of(context);

    return SizedBox(
      width: 39,
      child: CarrotFormFieldTheme(
        data: appTheme.formFieldTheme.copyWith(
          background: const CarrotOptional.of(CarrotColors.transparent),
          padding: const CarrotOptional.of(EdgeInsets.zero),
          textStyle: CarrotOptional.of(appTheme.typography.headline5.copyWith(
            color: style == CarrotIncrementStepperStyle.attached ? incrementStepperTheme.valueForegroundAttached : incrementStepperTheme.valueForegroundDetached,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          )),
        ),
        child: CarrotTextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          maxLength: 3,
          maxLines: 1,
          minHeight: 33,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}

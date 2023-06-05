import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';
import '../icon.dart';
import '../primitive/primitive.dart';
import '../row.dart';
import 'date_picker.dart';
import 'form.dart';

class CarrotDateField extends StatefulWidget {
  final bool autofocus;
  final CarrotValueController<DateTime?> controller;
  final bool enabled;
  final DateTime? maxDate;
  final DateTime? minDate;
  final String? placeholder;

  const CarrotDateField({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.enabled = true,
    this.maxDate,
    this.minDate,
    this.placeholder,
  });

  @override
  createState() => _CarrotDateFieldState();
}

class _CarrotDateFieldState extends State<CarrotDateField> {
  late CarrotValueController<DateTime?> _valueController;

  @override
  void didUpdateWidget(CarrotDateField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _valueController.removeListener(_onValueUpdated);
      _initController();
    }
  }

  @override
  void dispose() {
    _valueController.removeListener(_onValueUpdated);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _valueController = widget.controller;
    _valueController.addListener(_onValueUpdated);
  }

  void _onDatePickerOpenTap() async {
    final newDate = await showCarrotDatePicker(
      context: context,
      maxDate: widget.maxDate,
      minDate: widget.minDate,
      selectedValue: widget.controller.value,
    );

    _valueController.value = newDate;
  }

  void _onValueUpdated() {
    setState(() {});
  }

  Widget _buildValue(BuildContext context) {
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    if (_valueController.value == null) {
      return Text(
        widget.placeholder ?? '',
        style: formFieldTheme.textPlaceholderStyle,
      );
    }

    final locale = Localizations.localeOf(context);

    return Text(DateFormat.yMMMMd(locale.languageCode).format(_valueController.value!));
  }

  @override
  Widget build(BuildContext context) {
    final formFieldTheme = CarrotFormFieldTheme.of(context);

    return CarrotBounceTapBuilder.child(
      onTap: _onDatePickerOpenTap,
      child: CarrotFormField(
        child: CarrotRow(
          children: [
            Expanded(
              child: Padding(
                padding: formFieldTheme.padding.copyWith(
                  top: 0,
                  bottom: 0,
                ),
                child: Builder(
                  builder: _buildValue,
                ),
              ),
            ),
            Padding(
              padding: formFieldTheme.padding.copyWith(
                top: 0,
                bottom: 0,
              ),
              child: CarrotIcon(
                color: formFieldTheme.textPlaceholderStyle.color,
                glyph: 'calendar',
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

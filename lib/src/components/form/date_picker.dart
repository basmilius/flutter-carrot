import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../animation/animation.dart';
import '../../app/extensions/extensions.dart';
import '../../data/data.dart';
import '../../utils/utils.dart';
import '../button.dart';
import '../column.dart';
import '../dialog.dart';
import '../filler.dart';
import '../icon.dart';
import '../primitive/primitive.dart';
import '../row.dart';
import '../spacer.dart';

const _kDefaultCurve = CarrotCurves.swiftOutCurve;
const _kDefaultDuration = Duration(milliseconds: 210);

Future<DateTime?> showCarrotDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? selectedValue,
}) async {
  final controller = CarrotValueController(
    value: selectedValue,
  );

  return await context.carrotRouter.overlayEntry(
    dismissible: true,
    builder: (bag) => CarrotDialog(
      close: bag.close,
      padding: const EdgeInsets.all(12),
      content: CarrotDatePicker(
        controller: controller,
        initialDate: initialDate,
      ),
      headerBuilder: (context, _, __, ___) => CarrotDialogTitle(
        child: Text(
          context.carrotStrings.datePickerDialogTitle,
          textAlign: TextAlign.left,
        ),
      ),
      footerBuilder: (context, _, __, ___) => Padding(
        padding: const EdgeInsets.all(24),
        child: CarrotColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          gap: 9,
          children: [
            CarrotChangeNotifierBuilder(
              notifier: controller,
              builder: (context, controller) => CarrotDisabled(
                disabled: controller.value == null,
                child: AnimatedOpacity(
                  curve: _kDefaultCurve,
                  duration: _kDefaultDuration,
                  opacity: controller.value == null ? .5 : 1,
                  child: CarrotContainedButton.text(
                    text: Text(context.carrotStrings.select),
                    onTap: () => bag.close(controller.value),
                  ),
                ),
              ),
            ),
            CarrotTextButton.text(
              text: Text(context.carrotStrings.cancel),
              onTap: () => bag.close(),
            ),
          ],
        ),
      ),
    ),
  );
}

class CarrotDatePicker extends StatefulWidget {
  final CarrotValueController<DateTime?> controller;
  final DateTime? initialDate;

  const CarrotDatePicker({
    super.key,
    required this.controller,
    this.initialDate,
  });

  @override
  createState() => _CarrotDatePickerState();
}

class _CarrotDatePickerState extends State<CarrotDatePicker> {
  late CarrotValueController<DateTime?> _valueController;
  late List<DateTime> _viewDates;
  late DateTime _viewMonth;

  @override
  void didUpdateWidget(CarrotDatePicker oldWidget) {
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
    _resolveInitialMonth();
  }

  void _initController() {
    _valueController = widget.controller;
    _valueController.addListener(_onValueUpdated);
  }

  void _resolveInitialMonth() {
    _setMonth((widget.initialDate ?? _valueController.value ?? DateTime.now()).middleOfDay());
  }

  void _setMonth(DateTime month) {
    final viewDates = getMonthDates(
      month,
      datePickerMode: true,
    );

    setState(() {
      _viewDates = viewDates.toList();
      _viewMonth = month;
    });
  }

  void _onToolbarNextTap() {
    _setMonth(_viewMonth.copyWith(
      month: _viewMonth.month + 1,
    ));
  }

  void _onToolbarPreviousTap() {
    _setMonth(_viewMonth.copyWith(
      month: _viewMonth.month - 1,
    ));
  }

  void _onToolbarMonthTap() {}

  void _onToolbarYearTap() {}

  void _onValueUpdated() {
    setState(() {});
  }

  Widget _buildCalendar(BuildContext context) {
    return RepaintBoundary(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 7,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemBuilder: _buildViewDate,
        itemCount: _viewDates.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final monthFormatter = DateFormat.MMMM(locale.languageCode);

    return CarrotRow(
      gap: 3,
      children: [
        const CarrotSpacer.horizontal(size: 3),
        CarrotTextButton.icon(
          icon: const CarrotIcon(
            glyph: 'angle-left',
            size: 22,
          ),
          onTap: _onToolbarPreviousTap,
        ),
        const CarrotFiller(),
        CarrotLinkButton.text(
          text: Text(toBeginningOfSentenceCase(monthFormatter.format(_viewMonth))!),
          onTap: _onToolbarMonthTap,
        ),
        CarrotLinkButton.text(
          text: Text('${_viewMonth.year}'),
          onTap: _onToolbarYearTap,
        ),
        const CarrotFiller(),
        CarrotTextButton.icon(
          icon: const CarrotIcon(
            glyph: 'angle-right',
            size: 22,
          ),
          onTap: _onToolbarNextTap,
        ),
        const CarrotSpacer.horizontal(size: 3),
      ],
    );
  }

  Widget _buildViewDate(BuildContext context, int index) {
    final date = _viewDates[index];
    final isWithinCurrentMonth = date.month == _viewMonth.month;

    return _CarrotDatePickerDate(
      key: ValueKey(date),
      date: date,
      disabled: !isWithinCurrentMonth,
      selected: _valueController.value == date,
      onTap: () => _valueController.value = date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarrotColumn(
      gap: 9,
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: _buildToolbar,
        ),
        Builder(
          builder: _buildCalendar,
        ),
      ],
    );
  }
}

class _CarrotDatePickerDate extends StatelessWidget {
  final DateTime date;
  final bool disabled;
  final bool selected;
  final GestureTapCallback onTap;

  const _CarrotDatePickerDate({
    super.key,
    required this.date,
    required this.disabled,
    required this.selected,
    required this.onTap,
  });

  Widget _buildContent(BuildContext context, bool isTapped) {
    final appTheme = context.carrotTheme;
    final isToday = date.middleOfDay() == DateTime.now().middleOfDay();

    final content = Padding(
      padding: const EdgeInsets.all(3),
      child: AnimatedContainer(
        curve: _kDefaultCurve,
        duration: _kDefaultDuration,
        decoration: BoxDecoration(
          borderRadius: appTheme.borderRadius,
          color: selected ? appTheme.primary : appTheme.gray[appTheme.resolve(100, 50)].withOpacity(isTapped ? 1 : 0),
        ),
        child: DefaultTextStyle(
          style: appTheme.typography.body1.copyWith(
            color: selected ? appTheme.primary[0] : null,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text('${date.day}'),
          ),
        ),
      ),
    );

    if (!isToday) {
      return content;
    }

    return Stack(
      children: [
        content,
        Positioned(
          left: 0,
          right: 0,
          bottom: 6,
          child: _CarrotDatePickerDateToday(
            color: selected ? appTheme.primary[0] : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarrotDisabled(
      disabled: disabled,
      child: AnimatedOpacity(
        curve: _kDefaultCurve,
        duration: _kDefaultDuration,
        opacity: !disabled ? 1 : .3,
        child: CarrotBounceTapBuilder(
          onTap: disabled ? null : onTap,
          builder: _buildContent,
        ),
      ),
    );
  }
}

class _CarrotDatePickerDateToday extends StatelessWidget {
  final Color? color;

  const _CarrotDatePickerDateToday({
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color ?? appTheme.primary,
          ),
          child: const SizedBox.square(
            dimension: 6,
          ),
        ),
      ),
    );
  }
}

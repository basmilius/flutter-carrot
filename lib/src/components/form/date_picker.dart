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
import '../scroll/scroll.dart';
import '../sliver/sliver.dart';

const _kDefaultCurve = CarrotCurves.swiftOutCurve;
const _kDefaultDuration = Duration(milliseconds: 210);

enum _View {
  dates,
  months,
  years,
}

Future<DateTime?> showCarrotDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? maxDate,
  DateTime? minDate,
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
      contentBuilder: (context, scrollController, headerSize, footerSize) => CarrotDatePicker(
        controller: controller,
        initialDate: initialDate,
        maxDate: maxDate,
        minDate: minDate,
        padding: EdgeInsets.only(
          top: headerSize.height,
          left: 18,
          right: 18,
          bottom: footerSize.height,
        ),
      ),
      headerBuilder: (context, _, __, ___) => CarrotDialogTitle(
        child: Text(
          context.carrotStrings.datePickerDialogTitle,
          textAlign: TextAlign.left,
        ),
      ),
      footerBuilder: (context, _, __, ___) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.carrotTheme.gray[0],
        ),
        child: Padding(
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
    ),
  );
}

class CarrotDatePicker extends StatefulWidget {
  final CarrotValueController<DateTime?> controller;
  final DateTime? initialDate;
  final DateTime? maxDate;
  final DateTime? minDate;
  final EdgeInsets padding;

  const CarrotDatePicker({
    super.key,
    required this.controller,
    this.initialDate,
    this.maxDate,
    this.minDate,
    this.padding = EdgeInsets.zero,
  });

  @override
  createState() => _CarrotDatePickerState();
}

class _CarrotDatePickerState extends State<CarrotDatePicker> {
  late DateTime _maxDate;
  late DateTime _minDate;
  late CarrotValueController<DateTime?> _valueController;
  late DateTime _viewMonth;

  final _scrollController = ScrollController();
  final _today = DateTime.now().middleOfDay();
  final List<DateTime> _days = [];
  final List<DateTime> _months = [];
  final List<DateTime> _years = [];

  _View _currentView = _View.dates;

  WidgetBuilder get _viewBuilder {
    switch (_currentView) {
      case _View.dates:
        return _buildCalendar;
      case _View.months:
        return _buildMonths;
      case _View.years:
        return _buildYears;
    }
  }

  @override
  void didUpdateWidget(CarrotDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _valueController.removeListener(_onValueUpdated);
      _initController();
    }

    if (oldWidget.maxDate != widget.maxDate || oldWidget.minDate != widget.minDate) {
      _initMaxMinRange();
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
    _initMaxMinRange();
    _resolveInitialMonth();
  }

  void _initController() {
    _valueController = widget.controller;
    _valueController.addListener(_onValueUpdated);
  }

  void _initMaxMinRange() {
    setState(() {
      _maxDate = widget.maxDate ?? DateTime(9999, 12, 31);
      _minDate = widget.minDate ?? DateTime(1, 1, 1);
    });
  }

  void _initMonths() {
    _months.clear();

    for (int i = 1; i <= 12; ++i) {
      _months.add(_today.copyWith(
        month: i,
      ));
    }
  }

  void _initYears() {
    _years.clear();

    for (int year = _minDate.year; year <= _maxDate.year; ++year) {
      _years.add(_today.copyWith(
        year: year,
      ));
    }
  }

  bool _isDateDisabled(DateTime date) {
    if (_maxDate.isBefore(date) && !_maxDate.isSameDay(date)) {
      return true;
    }

    if (_minDate.isAfter(date)) {
      return true;
    }

    return false;
  }

  bool _isMonthDisabled(DateTime date) {
    final start = date.startOfMonth();
    final end = date.endOfMonth();

    return !_maxDate.isBetween(start, end) && !_minDate.isBetween(start, end) && !date.isBetween(_minDate, _maxDate);
  }

  bool _isYearDisabled(DateTime date) {
    final start = date.startOfYear();
    final end = date.endOfYear();

    return !_maxDate.isBetween(start, end) && !_minDate.isBetween(start, end) && !date.isBetween(_minDate, _maxDate);
  }

  void _resolveInitialMonth() {
    _setMonth((widget.initialDate ?? _valueController.value ?? DateTime.now()).middleOfDay());
    _initMonths();
    _initYears();
  }

  void _setMonth(DateTime month) {
    final viewDates = getMonthDates(
      month,
      datePickerMode: true,
    );

    _days.clear();
    _days.addAll(viewDates);

    setState(() {
      _currentView = _View.dates;
      _viewMonth = month;
    });
  }

  void _setView(_View view) {
    setState(() {
      _currentView = view == _currentView ? _View.dates : view;
      _scrollController.jumpTo(0);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      // _scrollController.
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

  void _onToolbarMonthTap() {
    _setView(_View.months);
  }

  void _onToolbarYearTap() {
    _setView(_View.years);
  }

  void _onValueUpdated() {
    setState(() {});
  }

  SliverGrid _buildCalendar(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 7,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      delegate: SliverChildBuilderDelegate(
        _buildCalendarDate,
        childCount: _days.length,
      ),
    );
  }

  Widget _buildCalendarDate(BuildContext context, int index) {
    final date = _days[index];
    final isDisabled = _isDateDisabled(date);
    final isWithinCurrentMonth = date.month == _viewMonth.month;

    return _CarrotDatePickerDate(
      date: date,
      disabled: !isWithinCurrentMonth || isDisabled,
      selected: _valueController.value == date,
      onTap: () => _valueController.value = date,
    );
  }

  Widget _buildMonth(BuildContext context, int index) {
    final locale = Localizations.localeOf(context);
    final monthFormatter = DateFormat.MMM(locale.languageCode);
    final month = _months[index];
    final isDisabled = _isMonthDisabled(month);

    return CarrotDisabled(
      disabled: isDisabled,
      child: AnimatedOpacity(
        curve: _kDefaultCurve,
        duration: _kDefaultDuration,
        opacity: !isDisabled ? 1 : .3,
        child: CarrotTextButton.text(
          size: CarrotButtonSize.small,
          text: Text(toBeginningOfSentenceCase(monthFormatter.format(month))!),
          onTap: () => _setMonth(_viewMonth.copyWith(
            month: month.month,
          )),
        ),
      ),
    );
  }

  SliverGrid _buildMonths(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2.5,
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      delegate: SliverChildBuilderDelegate(
        _buildMonth,
        childCount: _months.length,
      ),
    );
  }

  Widget _buildYear(BuildContext context, int index) {
    final locale = Localizations.localeOf(context);
    final yearFormatter = DateFormat.y(locale.languageCode);
    final year = _years[index];
    final isDisabled = _isYearDisabled(year);

    return CarrotDisabled(
      disabled: isDisabled,
      child: AnimatedOpacity(
        curve: _kDefaultCurve,
        duration: _kDefaultDuration,
        opacity: !isDisabled ? 1 : .3,
        child: CarrotTextButton.text(
          size: CarrotButtonSize.small,
          text: Text(yearFormatter.format(year)),
          onTap: () => _setMonth(_viewMonth.copyWith(
            year: year.year,
          )),
        ),
      ),
    );
  }

  SliverGrid _buildYears(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2.5,
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      delegate: SliverChildBuilderDelegate(
        _buildYear,
        childCount: _years.length,
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final monthFormatter = DateFormat.MMMM(locale.languageCode);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.carrotTheme.gray[0],
      ),
      child: CarrotRow(
        gap: 3,
        children: [
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AnimatedSize(
        curve: _kDefaultCurve,
        duration: _kDefaultDuration,
        child: CustomScrollView(
          clipBehavior: Clip.antiAlias,
          controller: _scrollController,
          physics: const CarrotBouncingScrollPhysics.notAlways(),
          shrinkWrap: true,
          slivers: [
            CarrotSliverPinnedHeader(
              child: Builder(
                builder: _buildToolbar,
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 9,
              ),
            ),
            Builder(
              builder: _viewBuilder,
            ),
          ],
        ),
      ),
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

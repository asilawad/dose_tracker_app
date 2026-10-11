import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/calendar/data/models/adherence_day.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The month card of the adherence calendar: the month name with previous
/// and next arrows, the month's adherence badge, the weekday headers, the
/// day grid with a colored dot per day, and the color legend.
///
/// [days] has one entry per day of the month and [leadingBlankDays] empty
/// cells come before the first. [rate] is the month's adherence from 0 to
/// 1, or null when no dose was due yet (the badge is hidden). Days after
/// [today] are dimmed but can still be selected.
class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({
    required this.month,
    required this.days,
    required this.leadingBlankDays,
    required this.selectedDate,
    required this.today,
    required this.rate,
    required this.onSelect,
    required this.onPreviousMonth,
    required this.onNextMonth,
    super.key,
  });

  /// A Monday used only to get weekday names in the grid header.
  static final DateTime _referenceMonday = DateTime(2024, 1, 1);

  final DateTime month;
  final List<AdherenceDay> days;
  final int leadingBlankDays;
  final DateTime selectedDate;
  final DateTime today;
  final double? rate;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;

    final int cellCount = leadingBlankDays + days.length;
    final int rowCount = (cellCount / DateTime.daysPerWeek).ceil();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  DateFormatter.monthYear(month),
                  style: textTheme.headlineSmall,
                ),
              ),
              IconButton(
                tooltip: AppStrings.a11yPreviousMonth.tr,
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: AppStrings.a11yNextMonth.tr,
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          if (rate != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: StatusBadge(
                label: AppStrings.calendarAdherenceBadge.trParams(
                  <String, String>{'percent': DoseFormatter.percent(rate!)},
                ),
                tone: BadgeTone.success,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          const SizedBox(height: AppSizes.spaceMd),
          Row(
            children: <Widget>[
              for (int index = 0; index < DateTime.daysPerWeek; index++)
                Expanded(
                  child: Text(
                    DateFormatter.weekdayShort(
                      DateTime(
                        _referenceMonday.year,
                        _referenceMonday.month,
                        ScheduleController.weekStartWeekday + index,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXs),
          for (int row = 0; row < rowCount; row++)
            Row(
              children: <Widget>[
                for (int column = 0; column < DateTime.daysPerWeek; column++)
                  Expanded(
                    child: _cellFor(row * DateTime.daysPerWeek + column),
                  ),
              ],
            ),
          const SizedBox(height: AppSizes.spaceMd),
          Divider(
            height: AppSizes.borderHairline,
            color: colors.borderHairline,
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSizes.space2xl,
            runSpacing: AppSizes.spaceSm,
            children: <Widget>[
              _LegendItem(
                color: colors.success,
                label: AppStrings.calendarLegendAllTaken.tr,
              ),
              _LegendItem(
                color: colors.warning,
                label: AppStrings.calendarLegendPartial.tr,
              ),
              _LegendItem(
                color: colors.danger,
                label: AppStrings.calendarLegendMissed.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The cell at [index] of the grid: empty before and after the month.
  Widget _cellFor(int index) {
    final int dayIndex = index - leadingBlankDays;
    if (dayIndex < 0 || dayIndex >= days.length) {
      return const SizedBox(height: AppSizes.minTapTarget);
    }
    final AdherenceDay day = days[dayIndex];
    return _DayCell(
      day: day,
      isSelected: day.date == selectedDate,
      isToday: day.date == today,
      isFuture: day.date.isAfter(today),
      onTap: () => onSelect(day.date),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isFuture,
    required this.onTap,
  });

  final AdherenceDay day;
  final bool isSelected;
  final bool isToday;
  final bool isFuture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusLg);

    final Color? dotColor = switch (day.status) {
      DayAdherenceStatus.allTaken => colors.success,
      DayAdherenceStatus.partial => colors.warning,
      DayAdherenceStatus.missed => colors.danger,
      DayAdherenceStatus.upcoming => colors.borderHairline,
      DayAdherenceStatus.none => null,
    };
    final String? statusLabel = switch (day.status) {
      DayAdherenceStatus.allTaken => AppStrings.calendarLegendAllTaken.tr,
      DayAdherenceStatus.partial => AppStrings.calendarLegendPartial.tr,
      DayAdherenceStatus.missed => AppStrings.calendarLegendMissed.tr,
      DayAdherenceStatus.upcoming || DayAdherenceStatus.none => null,
    };
    final Color numberColor = isSelected || isToday
        ? colors.active
        : (isFuture ? colors.textSecondary : colors.textPrimary);

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormatter.fullDate(day.date),
      value: statusLabel,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? colors.activeTint : null,
            borderRadius: radius,
            border: isSelected
                ? Border.all(
                    color: colors.active,
                    width: AppSizes.borderEmphasis,
                  )
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTapTarget,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormatter.dayNumber(day.date),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: numberColor),
                    ),
                    const SizedBox(height: AppSizes.spaceXs),
                    SizedBox(
                      width: AppSizes.spaceSm,
                      height: AppSizes.spaceSm,
                      child: dotColor == null
                          ? null
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: AppSizes.spaceSm,
          height: AppSizes.spaceSm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

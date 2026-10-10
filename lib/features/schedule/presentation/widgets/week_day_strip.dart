import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// A card with the seven days of one week; the chosen day is filled with
/// the logo gradient and today's number uses the active color.
///
/// [days] are local midnights, [selected] and [today] too. Each day is a
/// button of at least 48 px that announces its full date and whether it is
/// selected.
class WeekDayStrip extends StatelessWidget {
  const WeekDayStrip({
    required this.days,
    required this.selected,
    required this.today,
    required this.onSelect,
    super.key,
  });

  final List<DateTime> days;
  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceXs,
        vertical: AppSizes.spaceSm,
      ),
      child: Row(
        children: <Widget>[
          for (final DateTime day in days)
            Expanded(
              child: _DayCell(
                day: day,
                isSelected: day == selected,
                isToday: day == today,
                onTap: () => onSelect(day),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusLg);
    final Color numberColor = isSelected
        ? colors.onActive
        : (isToday ? colors.active : colors.textPrimary);

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormatter.fullDate(day),
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isSelected ? colors.actionGradient : null,
            borderRadius: radius,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spaceSm,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        DateFormatter.weekdayShort(day),
                        maxLines: 1,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colors.onActive
                              : colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceXs),
                      Text(
                        DateFormatter.dayNumber(day),
                        style: textTheme.titleMedium?.copyWith(
                          color: numberColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

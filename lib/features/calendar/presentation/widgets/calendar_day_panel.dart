import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/calendar/data/models/adherence_day.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:dose_tracker/views/widgets/stock_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The selected-day panel under the calendar: the date, how many doses were
/// logged out of the day's total with a progress bar, and one row per dose.
///
/// A dose that is missed, skipped or still pending on a day that is not in
/// the future shows a "Log now" link that calls [onLogNow]. Taken doses show
/// a labeled badge, so state never relies on color alone.
class CalendarDayPanel extends StatelessWidget {
  const CalendarDayPanel({
    required this.day,
    required this.doses,
    required this.canLog,
    required this.onLogNow,
    super.key,
  });

  final AdherenceDay day;
  final List<ScheduledDose> doses;
  final bool canLog;
  final ValueChanged<ScheduledDose> onLogNow;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;
    final int logged = day.taken + day.skipped;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.calendarSelectedDay.tr,
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      DateFormatter.fullDate(day.date),
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              if (day.total > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${DoseFormatter.quantity(logged.toDouble())}/'
                      '${DoseFormatter.quantity(day.total.toDouble())}',
                      style: textTheme.titleLarge,
                    ),
                    Text(
                      AppStrings.calendarDosesLogged.tr,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          if (day.total == 0)
            Text(AppStrings.calendarDayEmpty.tr, style: textTheme.bodyMedium)
          else ...<Widget>[
            StockProgressBar(fraction: logged / day.total),
            const SizedBox(height: AppSizes.spaceMd),
            for (final ScheduledDose dose in doses)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceSm),
                child: _DoseRow(
                  dose: dose,
                  canLog: canLog,
                  colors: colors,
                  onLogNow: () => onLogNow(dose),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DoseRow extends StatelessWidget {
  const _DoseRow({
    required this.dose,
    required this.canLog,
    required this.colors,
    required this.onLogNow,
  });

  final ScheduledDose dose;
  final bool canLog;
  final AppColorTokens colors;
  final VoidCallback onLogNow;

  static String _stateKey(DoseState state) {
    return switch (state) {
      DoseState.pending => AppStrings.scheduleStatePending,
      DoseState.taken => AppStrings.scheduleStateTaken,
      DoseState.takenLate => AppStrings.scheduleStateTakenLate,
      DoseState.skipped => AppStrings.scheduleStateSkipped,
      DoseState.missed => AppStrings.scheduleStateMissed,
    };
  }

  static (BadgeTone, IconData)? _badge(DoseState state) {
    return switch (state) {
      DoseState.taken => (BadgeTone.success, Icons.check_rounded),
      DoseState.takenLate => (BadgeTone.warning, Icons.schedule_rounded),
      DoseState.skipped => (BadgeTone.active, Icons.remove_rounded),
      DoseState.missed => (BadgeTone.danger, Icons.close_rounded),
      DoseState.pending => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final (BadgeTone, IconData)? badge = _badge(dose.state);
    final bool isMissed = dose.state == DoseState.missed;
    final bool canLogThis =
        canLog &&
        (dose.state == DoseState.missed ||
            dose.state == DoseState.skipped ||
            dose.state == DoseState.pending);
    final String title =
        '${dose.medicationName} ${DoseFormatter.quantity(dose.doseAmount)} '
        '${dose.doseUnit.labelKey.tr}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isMissed ? colors.dangerTint : colors.appBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    DoseFormatter.minuteOfDay(dose.minuteOfDay),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            if (canLogThis)
              AppTextLink(
                label: AppStrings.calendarLogNow.tr,
                onPressed: onLogNow,
              )
            else if (badge != null)
              StatusBadge(
                label: _stateKey(dose.state).tr,
                tone: badge.$1,
                icon: badge.$2,
              ),
          ],
        ),
      ),
    );
  }
}

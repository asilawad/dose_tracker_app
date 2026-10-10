import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_time_header.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/skip_dose_sheet_content.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/week_day_strip.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Schedule tab: the body only, without a scaffold, because the main
/// shell owns the scaffold and the bottom bar.
///
/// A header with week arrows, the week strip, and below it the chosen day's
/// doses grouped under their time. It shows a spinner while loading, an
/// error with retry, an empty state when the day has no doses, and
/// otherwise the dose list. Doses of future days are shown but cannot be
/// recorded. The controller comes from `ScheduleBinding`.
class ScheduleTabView extends GetView<ScheduleController> {
  const ScheduleTabView({super.key});

  void _openSkipSheet(ScheduledDose dose) {
    AppBottomSheet.show<void>(
      title: AppStrings.scheduleSkipTitle.tr,
      child: SkipDoseSheetContent(
        onConfirm: (String? reason) =>
            controller.skipDose(dose, reason: reason),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DateTime selected = controller.selectedDate.value;
      final bool isToday = controller.isToday;
      final bool isFutureDay = controller.isFutureDay;

      final Widget body;
      if (controller.isLoading.value) {
        body = const LoadingState();
      } else if (controller.hasError.value) {
        body = ErrorState(onRetry: controller.retry);
      } else if (controller.doses.isEmpty) {
        body = EmptyState(
          icon: Icons.event_available_rounded,
          title: AppStrings.scheduleEmptyTitle.tr,
          message: AppStrings.scheduleEmptyMessage.tr,
        );
      } else {
        body = _DosesList(
          doses: controller.doses.toList(),
          isFutureDay: isFutureDay,
          onToggle: controller.toggleDose,
          onSkip: _openSkipSheet,
        );
      }

      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingHorizontal,
              vertical: AppSizes.spaceLg,
            ),
            child: Column(
              children: <Widget>[
                _ScheduleHeader(
                  selected: selected,
                  isToday: isToday,
                  onPrevious: () => controller.shiftWeeks(-1),
                  onNext: () => controller.shiftWeeks(1),
                  onToday: controller.goToToday,
                ),
                const SizedBox(height: AppSizes.spaceLg),
                WeekDayStrip(
                  days: controller.weekDays,
                  selected: selected,
                  today: DosePlanner.dayStart(DateTime.now()),
                  onSelect: controller.selectDate,
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      );
    });
  }
}

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.selected,
    required this.isToday,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime selected;
  final bool isToday;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        IconButton(
          tooltip: AppStrings.a11yPreviousWeek.tr,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                isToday
                    ? AppStrings.scheduleToday.tr
                    : DateFormatter.monthYear(selected),
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              Text(
                DateFormatter.fullDate(selected),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              if (!isToday)
                AppTextLink(
                  label: AppStrings.scheduleToday.tr,
                  onPressed: onToday,
                ),
            ],
          ),
        ),
        IconButton(
          tooltip: AppStrings.a11yNextWeek.tr,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _DosesList extends StatelessWidget {
  const _DosesList({
    required this.doses,
    required this.isFutureDay,
    required this.onToggle,
    required this.onSkip,
  });

  final List<ScheduledDose> doses;
  final bool isFutureDay;
  final ValueChanged<ScheduledDose> onToggle;
  final ValueChanged<ScheduledDose> onSkip;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    int? lastMinute;

    for (final ScheduledDose dose in doses) {
      if (dose.minuteOfDay != lastMinute) {
        children.add(DoseTimeHeader(minuteOfDay: dose.minuteOfDay));
        children.add(const SizedBox(height: AppSizes.spaceSm));
        lastMinute = dose.minuteOfDay;
      }
      final bool wasTaken =
          dose.state == DoseState.taken || dose.state == DoseState.takenLate;
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.gutter),
          child: DoseTile(
            key: ValueKey<String>(dose.key),
            dose: dose,
            onToggle: isFutureDay ? null : () => onToggle(dose),
            onSkip: isFutureDay || wasTaken ? null : () => onSkip(dose),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSizes.screenPaddingHorizontal,
        0,
        AppSizes.screenPaddingHorizontal,
        AppSizes.spaceLg + AppSizes.bottomOverlayClearance,
      ),
      children: <Widget>[
        if (isFutureDay) ...<Widget>[
          Text(
            AppStrings.scheduleFutureNote.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSizes.spaceMd),
        ],
        ...children,
      ],
    );
  }
}

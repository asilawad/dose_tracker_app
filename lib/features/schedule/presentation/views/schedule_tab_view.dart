import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_dose_list.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/skip_dose_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleTabView extends GetView<ScheduleController> {
  const ScheduleTabView({super.key});

  void _openSkipSheet(ScheduledDose dose) {
    AppBottomSheet.show<void>(
      title: AppStrings.scheduleSkipTitle.tr,
      child: SkipDoseSheetContent(
        onConfirm: (String? reason) =>
            controller.actions.skip(dose, reason: reason),
      ),
    );
  }

  Widget _body() {
    if (controller.isLoading.value) {
      return const SliverFillRemaining(child: LoadingState());
    }
    if (controller.hasError.value) {
      return SliverFillRemaining(child: ErrorState(onRetry: controller.retry));
    }
    final List<ScheduledDose> visible = controller.visible;
    if (visible.isEmpty) {
      final bool allDone = controller.totalCount > 0;
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.bottomOverlayClearance,
          ),
          child: EmptyState(
            icon: Icons.event_available_rounded,
            title:
                (allDone
                        ? AppStrings.scheduleAllDone
                        : AppStrings.scheduleEmptyTitle)
                    .tr,
            message: allDone ? '' : AppStrings.scheduleEmptyMessage.tr,
          ),
        ),
      );
    }
    return ScheduleDoseList(
      doses: visible,
      onCheck: controller.actions.check,
      onUndo: controller.actions.undo,
      onSkip: _openSkipSheet,
      isJustChecked: controller.actions.isJustChecked,
      onConfirmAll: controller.actions.checkAll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: <Widget>[
          AppCollapsingHeader(
            title: AppStrings.scheduleToday.tr,
            eyebrowLabel: DateFormatter.weekdayDayMonth(DateTime.now()),
            eyebrowIcon: Icons.calendar_today_rounded,
            trailing: controller.totalCount > 0
                ? _ProgressBadge(
                    taken: controller.takenCount,
                    total: controller.totalCount,
                  )
                : null,
          ),
          _body(),
        ],
      ),
    );
  }
}

/// The "3/12" ring at the end of the header (design `.ring`).
class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.taken, required this.total});

  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.scheduleTakenProgress.trParams(<String, String>{
        'taken': '$taken',
        'total': '$total',
      }),
      child: ExcludeSemantics(
        child: ProgressRing(
          value: taken / total,
          color: context.appColors.active,
          size: 52,
          strokeWidth: 5,
          child: Text(
            '$taken/$total',
            textDirection: TextDirection.ltr,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

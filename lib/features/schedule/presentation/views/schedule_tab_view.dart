import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_dose_list.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/skip_dose_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Widget _body() {
    if (controller.isLoading.value) {
      return const LoadingState();
    }
    if (controller.hasError.value) {
      return ErrorState(onRetry: controller.retry);
    }
    final List<ScheduledDose> visible = controller.visible;
    if (visible.isEmpty) {
      final bool allDone = controller.totalCount > 0;
      return EmptyState(
        icon: Icons.event_available_rounded,
        title: (allDone
                ? AppStrings.scheduleAllDone
                : AppStrings.scheduleEmptyTitle)
            .tr,
        message: allDone ? '' : AppStrings.scheduleEmptyMessage.tr,
      );
    }
    return ScheduleDoseList(
      doses: visible,
      onCheck: controller.check,
      onUndo: controller.undo,
      onSkip: _openSkipSheet,
      isJustChecked: controller.isJustChecked,
      canConfirmAll: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          _Header(taken: controller.takenCount, total: controller.totalCount),
          Expanded(child: _body()),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.taken, required this.total});

  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.scheduleToday.tr, style: text.headlineMedium),
          Text(DateFormatter.fullDate(DateTime.now()), style: text.bodyMedium),
          if (total > 0)
            Text(
              AppStrings.scheduleTakenProgress.trParams(<String, String>{
                'taken': '$taken',
                'total': '$total',
              }),
              style: text.bodyMedium,
            ),
        ],
      ),
    );
  }
}

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/calendar/controllers/calendar_controller.dart';
import 'package:dose_tracker/features/calendar/presentation/widgets/calendar_day_panel.dart';
import 'package:dose_tracker/features/calendar/presentation/widgets/calendar_month_card.dart';
import 'package:dose_tracker/features/calendar/presentation/widgets/calendar_profile_chips.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Adherence Calendar screen: back arrow, title, the family member
/// chips, the month card and the selected-day panel.
///
/// It shows a spinner while loading, an error with retry, and an empty
/// state when there are no profiles. It is opened on top of the main shell,
/// so the back arrow (mirrored in RTL) returns there. The controller comes
/// from `CalendarBinding`.
class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return ScreenScaffold(
      appBar: AppBar(
        backgroundColor: colors.appBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: AppStrings.actionBack.tr,
          onPressed: () => Get.back<void>(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          AppStrings.calendarTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingState();
        }
        if (controller.hasError.value) {
          return ErrorState(onRetry: controller.retry);
        }
        if (controller.profiles.isEmpty) {
          return EmptyState(
            icon: Icons.calendar_month_outlined,
            title: AppStrings.calendarEmptyTitle.tr,
            message: AppStrings.calendarEmptyMessage.tr,
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceLg),
          children: <Widget>[
            CalendarProfileChips(
              profiles: controller.profiles.toList(),
              selectedId: controller.selectedProfileId.value,
              onSelect: controller.selectProfile,
            ),
            const SizedBox(height: AppSizes.gutter),
            CalendarMonthCard(
              month: controller.visibleMonth.value,
              days: controller.monthDays,
              leadingBlankDays: controller.leadingBlankDays,
              selectedDate: controller.selectedDate.value,
              today: DosePlanner.dayStart(DateTime.now()),
              rate: controller.monthRate,
              onSelect: controller.selectDate,
              onPreviousMonth: () => controller.shiftMonths(-1),
              onNextMonth: () => controller.shiftMonths(1),
            ),
            const SizedBox(height: AppSizes.gutter),
            CalendarDayPanel(
              day: controller.selectedDay,
              doses: controller.selectedDayDoses,
              canLog: controller.canLogSelectedDay,
              onLogNow: controller.logNow,
            ),
            const SizedBox(height: AppSizes.space2xl),
          ],
        );
      }),
    );
  }
}

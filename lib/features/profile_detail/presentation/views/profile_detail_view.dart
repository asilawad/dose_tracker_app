import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_detail_controller.dart';
import 'package:dose_tracker/features/profile_detail/presentation/widgets/profile_header.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart'
    as schedule_data;
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_time_group.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailView extends GetView<ProfileDetailController> {
  const ProfileDetailView({super.key});

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
          AppStrings.profileDetailTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.summary.value == null) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: controller.openAddMedication,
          tooltip: AppStrings.a11yAddMedication.tr,
          backgroundColor: colors.active,
          foregroundColor: colors.onActive,
          child: const Icon(Icons.add_rounded),
        );
      }),
      body: Obx(() {
        final ProfileSummary? summary = controller.summary.value;
        if (controller.hasError.value) {
          return ErrorState(onRetry: controller.retry);
        }
        if (controller.isLoading.value || summary == null) {
          return const LoadingState();
        }
        final List<ScheduledDose> doses = controller.doses.toList();
        final List<schedule_data.ScheduleTimeGroup> groups =
            schedule_data.ScheduleGrouper.group(doses);
        return ListView(
          padding: const EdgeInsetsDirectional.only(
            top: AppSizes.spaceLg,
            bottom: AppSizes.space3xl + AppSizes.bottomOverlayClearance,
          ),
          children: <Widget>[
            ProfileHeader(summary: summary, onEdit: controller.openEdit),
            const SizedBox(height: AppSizes.space2xl),
            _SectionTitle(AppStrings.profileTodaySection.tr),
            if (groups.isEmpty)
              const _EmptyLine(AppStrings.homeNoDosesToday),
            for (final schedule_data.ScheduleTimeGroup group in groups)
              ...<Widget>[
                ScheduleTimeGroup(
                  key: ValueKey<int>(group.minuteOfDay),
                  group: group,
                  onCheck: controller.toggleDose,
                  onUndo: controller.toggleDose,
                  onSkip: null,
                  isJustChecked: (_) => false,
                  canConfirmAll: false,
                  showProfile: false,
                ),
                const SizedBox(height: AppSizes.spaceLg),
              ],
            const SizedBox(height: AppSizes.spaceMd),
            OutlinedActionButton(
              label: AppStrings.profileAllMedications.tr,
              icon: Icons.medication_outlined,
              onPressed: controller.openAllMedications,
            ),
          ],
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceMd),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.gutter),
      child: Text(text.tr, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

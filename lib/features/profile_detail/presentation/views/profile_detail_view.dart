import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_detail_controller.dart';
import 'package:dose_tracker/features/profile_detail/presentation/widgets/profile_header.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart'
    as schedule_data;
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_time_group.dart';
import 'package:dose_tracker/views/widgets/app_icon_button.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/app_list_row.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/gradient_fab.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:dose_tracker/views/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailView extends GetView<ProfileDetailController> {
  const ProfileDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.summary.value == null) {
          return const SizedBox.shrink();
        }
        return GradientFab(
          label: AppStrings.a11yAddMedication.tr,
          onPressed: controller.openAddMedication,
        );
      }),
      body: Obx(() {
        final ProfileSummary? summary = controller.summary.value;
        final Widget body;
        if (controller.hasError.value) {
          body = SliverFillRemaining(
            child: ErrorState(onRetry: controller.retry),
          );
        } else if (controller.isLoading.value || summary == null) {
          body = const SliverFillRemaining(child: LoadingState());
        } else {
          body = _content(summary);
        }
        return CustomScrollView(
          slivers: <Widget>[
            AppInnerHeader(
              title: AppStrings.profileDetailTitle.tr,
              trailing: summary == null
                  ? null
                  : AppIconButton(
                      icon: Icons.edit_rounded,
                      tooltip: AppStrings.profileEditAction.tr,
                      onPressed: controller.openEdit,
                    ),
            ),
            body,
          ],
        );
      }),
    );
  }

  Widget _content(ProfileSummary summary) {
    final List<ScheduledDose> allDoses = controller.doses.toList();
    final List<ScheduledDose> doses = controller.actions.visible(allDoses);
    final List<schedule_data.ScheduleTimeGroup> groups =
        schedule_data.ScheduleGrouper.group(doses);
    final int nextIndex = groups.indexWhere(
      (schedule_data.ScheduleTimeGroup group) => group.profiles.any(
        (schedule_data.ScheduleProfileGroup profile) => profile.doses.any(
          (ScheduledDose dose) =>
              dose.state == DoseState.pending && !dose.isDue,
        ),
      ),
    );

    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSizes.screenPaddingHorizontal,
        0,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space3xl + AppSizes.bottomOverlayClearance,
      ),
      sliver: SliverList.list(
        children: <Widget>[
          ProfileHeader(summary: summary),
          const SizedBox(height: AppSizes.spaceXl),
          Builder(
            builder: (BuildContext context) {
              final PersonaShade shade = summary.profile.personaColor.resolve(
                context.appColors,
              );
              return AppListGroup(
                children: <Widget>[
                  AppListRow(
                    icon: Icons.medication_rounded,
                    title: AppStrings.profileAllMedications.tr,
                    subtitle: summary.medicationCount == 0
                        ? AppStrings.homeNoMedications.tr
                        : AppStrings.homeMedicationCount.trParams(
                            <String, String>{
                              'count': '${summary.medicationCount}',
                            },
                          ),
                    iconColor: shade.main,
                    iconBackground: shade.tint,
                    onTap: controller.openAllMedications,
                  ),
                ],
              );
            },
          ),
          SectionHeader(
            title: AppStrings.profileTodaySection.tr,
            caption: allDoses.isEmpty
                ? null
                : allDoses.length == 1
                ? AppStrings.scheduleSlotOneDose.tr
                : AppStrings.scheduleSlotDoses.trParams(<String, String>{
                    'count': '${allDoses.length}',
                  }),
          ),
          if (groups.isEmpty)
            _EmptyLine(
              allDoses.isEmpty
                  ? AppStrings.homeNoDosesToday
                  : AppStrings.scheduleAllDone,
            ),
          for (int i = 0; i < groups.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: 18),
            ScheduleTimeGroup(
              key: ValueKey<int>(groups[i].minuteOfDay),
              group: groups[i],
              isNext: i == nextIndex,
              onCheck: controller.actions.check,
              onUndo: controller.actions.undo,
              onSkip: controller.actions.skip,
              isJustChecked: controller.actions.isJustChecked,
              onConfirmAll: controller.actions.checkAll,
              showProfile: false,
            ),
          ],
        ],
      ),
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

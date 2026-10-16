import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/home/presentation/widgets/profile_card.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_detail_controller.dart';
import 'package:dose_tracker/features/profile_detail/presentation/widgets/profile_medication_tile.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The page of one family member: the member card on top (tap to edit the
/// profile), today's doses, and the medications. The controller comes from
/// `ProfileDetailBinding`.
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
      body: Obx(() {
        final ProfileSummary? summary = controller.summary.value;
        if (controller.hasError.value) {
          return ErrorState(onRetry: controller.retry);
        }
        if (controller.isLoading.value || summary == null) {
          return const LoadingState();
        }
        final List<ScheduledDose> doses = controller.doses.toList();
        final List<Medication> medications = controller.medications.toList();
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceLg),
          children: <Widget>[
            ProfileCard(summary: summary, onTap: controller.openEdit),
            const SizedBox(height: AppSizes.space2xl),
            _SectionTitle(AppStrings.profileTodaySection.tr),
            if (doses.isEmpty) _EmptyLine(AppStrings.homeNoDosesToday.tr),
            for (final ScheduledDose dose in doses) ...<Widget>[
              DoseTile(
                key: ValueKey<String>(dose.key),
                dose: dose,
                onToggle: () => controller.toggleDose(dose),
                onSkip: null,
              ),
              const SizedBox(height: AppSizes.gutter),
            ],
            const SizedBox(height: AppSizes.spaceMd),
            _SectionTitle(AppStrings.profileMedicationsSection.tr),
            OutlinedActionButton(
              label: AppStrings.profileAddMedication.tr,
              icon: Icons.add_rounded,
              onPressed: controller.openAddMedication,
            ),
            const SizedBox(height: AppSizes.gutter),
            if (medications.isEmpty)
              _EmptyLine(AppStrings.homeNoMedications.tr),
            for (final Medication medication in medications) ...<Widget>[
              ProfileMedicationTile(
                key: ValueKey<int>(medication.id),
                medication: medication,
              ),
              const SizedBox(height: AppSizes.gutter),
            ],
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
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

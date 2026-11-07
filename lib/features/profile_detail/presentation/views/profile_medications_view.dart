import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_medications_controller.dart';
import 'package:dose_tracker/features/profile_detail/presentation/widgets/profile_medication_tile.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/gradient_fab.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMedicationsView extends GetView<ProfileMedicationsController> {
  const ProfileMedicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.profile.value == null) {
          return const SizedBox.shrink();
        }
        return GradientFab(
          label: AppStrings.a11yAddMedication.tr,
          onPressed: controller.openAddMedication,
        );
      }),
      body: Obx(() {
        final Widget body;
        if (controller.hasError.value) {
          body = SliverFillRemaining(
            child: ErrorState(onRetry: controller.retry),
          );
        } else if (controller.isLoading.value) {
          body = const SliverFillRemaining(child: LoadingState());
        } else {
          body = _content(context);
        }
        return CustomScrollView(
          slivers: <Widget>[
            AppInnerHeader(title: AppStrings.profileMedicationsSection.tr),
            body,
          ],
        );
      }),
    );
  }

  Widget _content(BuildContext context) {
    final List<Medication> medications = controller.medications.toList();
    final Profile? profile = controller.profile.value;
    if (medications.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            AppStrings.homeNoMedications.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSizes.screenPaddingHorizontal,
        AppSizes.spaceSm,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space3xl + AppSizes.bottomOverlayClearance,
      ),
      sliver: SliverList.list(
        children: <Widget>[
          for (final Medication medication in medications) ...<Widget>[
            ProfileMedicationTile(
              key: ValueKey<int>(medication.id),
              medication: medication,
              persona: profile?.personaColor ?? PersonaColor.purple,
              onTap: () => Get.toNamed<void>(
                AppRoutes.editMedication,
                arguments: medication.id,
              ),
            ),
            const SizedBox(height: AppSizes.gutter),
          ],
        ],
      ),
    );
  }
}

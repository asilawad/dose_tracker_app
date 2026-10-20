import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_medications_controller.dart';
import 'package:dose_tracker/features/profile_detail/presentation/widgets/profile_medication_tile.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMedicationsView extends GetView<ProfileMedicationsController> {
  const ProfileMedicationsView({super.key});

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
          AppStrings.profileMedicationsSection.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.profile.value == null) {
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
        if (controller.hasError.value) {
          return ErrorState(onRetry: controller.retry);
        }
        if (controller.isLoading.value) {
          return const LoadingState();
        }
        final List<Medication> medications = controller.medications.toList();
        if (medications.isEmpty) {
          return Center(
            child: Text(
              AppStrings.homeNoMedications.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return ListView(
          padding: const EdgeInsetsDirectional.only(
            top: AppSizes.spaceLg,
            bottom: AppSizes.space3xl + AppSizes.bottomOverlayClearance,
          ),
          children: <Widget>[
            for (final Medication medication in medications) ...<Widget>[
              ProfileMedicationTile(
                key: ValueKey<int>(medication.id),
                medication: medication,
                onTap: () => Get.toNamed<void>(
                  AppRoutes.editMedication,
                  arguments: medication.id,
                ),
              ),
              const SizedBox(height: AppSizes.gutter),
            ],
          ],
        );
      }),
    );
  }
}

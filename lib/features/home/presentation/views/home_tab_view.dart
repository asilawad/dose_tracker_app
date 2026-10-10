import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/home/controllers/home_controller.dart';
import 'package:dose_tracker/features/home/presentation/widgets/profile_card.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Home tab: the body only, without a scaffold, because the main shell
/// owns the scaffold and the bottom bar.
///
/// It shows a spinner while loading, an error with retry if the list cannot
/// be read, the empty state ("add your first family member") for a new
/// account, and otherwise the profile cards with an Add button. The
/// controller comes from `HomeBinding`.
class HomeTabView extends GetView<HomeController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingState();
      }
      if (controller.hasError.value) {
        return ErrorState(onRetry: controller.retry);
      }
      if (controller.profiles.isEmpty) {
        return EmptyState(
          icon: Icons.group_add_rounded,
          title: AppStrings.homeEmptyTitle.tr,
          message: AppStrings.homeEmptyMessage.tr,
          actionLabel: AppStrings.homeAddProfile.tr,
          onAction: controller.openAddProfile,
        );
      }
      return _ProfilesList(
        profiles: controller.profiles.toList(),
        onAddProfile: controller.openAddProfile,
      );
    });
  }
}

class _ProfilesList extends StatelessWidget {
  const _ProfilesList({required this.profiles, required this.onAddProfile});

  final List<Profile> profiles;
  final VoidCallback onAddProfile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSizes.screenPaddingHorizontal,
        AppSizes.space2xl,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space2xl + AppSizes.bottomOverlayClearance,
      ),
      children: <Widget>[
        Text(
          AppStrings.navHome.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.space2xl),
        for (final Profile profile in profiles) ...<Widget>[
          ProfileCard(profile: profile),
          const SizedBox(height: AppSizes.gutter),
        ],
        const SizedBox(height: AppSizes.spaceSm),
        OutlinedActionButton(
          label: AppStrings.homeAddProfile.tr,
          icon: Icons.add_rounded,
          onPressed: onAddProfile,
        ),
      ],
    );
  }
}

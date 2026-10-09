import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Home tab: the body only, without a scaffold, because the main shell
/// owns the scaffold and the bottom bar.
///
/// For now it always shows the empty state ("add your first family
/// member"), which is what a new account sees. The profile list and the
/// button that opens Add Profile are added in the steps that create those
/// screens.
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.group_add_rounded,
      title: AppStrings.homeEmptyTitle.tr,
      message: AppStrings.homeEmptyMessage.tr,
    );
  }
}

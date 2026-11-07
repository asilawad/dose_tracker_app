import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/home/controllers/home_controller.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/home/presentation/widgets/home_low_stock_card.dart';
import 'package:dose_tracker/features/home/presentation/widgets/home_today_card.dart';
import 'package:dose_tracker/features/home/presentation/widgets/home_up_next_card.dart';
import 'package:dose_tracker/features/home/presentation/widgets/profile_card.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header.dart';
import 'package:dose_tracker/views/widgets/app_icon_button.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Home tab: the body only, without a scaffold, because the main shell
/// owns the scaffold and the bottom bar.
///
/// It shows a spinner while loading, an error with retry if the list cannot
/// be read, the empty state ("add your first family member") for a new
/// account, and otherwise today's progress with the next dose, the next
/// doses, the profile cards and, while stock runs low, a refill card. The
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
      if (controller.summaries.isEmpty) {
        return EmptyState(
          icon: Icons.group_add_rounded,
          title: AppStrings.homeEmptyTitle.tr,
          message: AppStrings.homeEmptyMessage.tr,
          actionLabel: AppStrings.homeAddProfile.tr,
          onAction: controller.openAddProfile,
        );
      }
      return _ProfilesList(
        summaries: controller.summaries.toList(),
        upNext: controller.upNext.toList(),
        lowStockCount: controller.lowStockCount.value,
        onAddProfile: controller.openAddProfile,
        onOpenProfile: controller.openProfile,
        onOpenSchedule: controller.openSchedule,
        onOpenInventory: controller.openInventory,
      );
    });
  }
}

class _ProfilesList extends StatelessWidget {
  const _ProfilesList({
    required this.summaries,
    required this.upNext,
    required this.lowStockCount,
    required this.onAddProfile,
    required this.onOpenProfile,
    required this.onOpenSchedule,
    required this.onOpenInventory,
  });

  final List<ProfileSummary> summaries;
  final List<ScheduledDose> upNext;
  final int lowStockCount;
  final VoidCallback onAddProfile;
  final ValueChanged<int> onOpenProfile;
  final VoidCallback onOpenSchedule;
  final VoidCallback onOpenInventory;

  @override
  Widget build(BuildContext context) {
    int taken = 0;
    int total = 0;
    for (final ProfileSummary summary in summaries) {
      taken += summary.takenToday;
      total += summary.totalToday;
    }

    return CustomScrollView(
      slivers: <Widget>[
        AppCollapsingHeader(
          title: AppStrings.navHome.tr,
          eyebrowLabel: DateFormatter.weekdayDayMonth(DateTime.now()),
          eyebrowIcon: Icons.calendar_today_rounded,
          trailing: AppIconButton(
            icon: Icons.person_add_rounded,
            tooltip: AppStrings.homeAddProfile.tr,
            onPressed: onAddProfile,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSizes.screenPaddingHorizontal,
            AppSizes.spaceSm,
            AppSizes.screenPaddingHorizontal,
            AppSizes.space2xl + AppSizes.bottomOverlayClearance,
          ),
          sliver: SliverList.list(
            children: <Widget>[
              HomeTodayCard(
                taken: taken,
                total: total,
                next: upNext.isEmpty ? null : upNext.first,
                onNextTap: onOpenSchedule,
              ),
              if (upNext.isNotEmpty) ...<Widget>[
                SectionHeader(
                  title: AppStrings.homeUpNext.tr,
                  actionLabel: AppStrings.homeSeeSchedule.tr,
                  onAction: onOpenSchedule,
                ),
                HomeUpNextCard(doses: upNext, onTap: onOpenSchedule),
              ],
              SectionHeader(
                title: AppStrings.homeFamily.tr,
                caption: AppStrings.homeMemberCount.trParams(<String, String>{
                  'count': '${summaries.length}',
                }),
              ),
              for (final ProfileSummary summary in summaries) ...<Widget>[
                ProfileCard(
                  summary: summary,
                  onTap: () => onOpenProfile(summary.profile.id),
                ),
                const SizedBox(height: AppSizes.gutter),
              ],
              if (lowStockCount > 0)
                HomeLowStockCard(count: lowStockCount, onTap: onOpenInventory),
            ],
          ),
        ),
      ],
    );
  }
}

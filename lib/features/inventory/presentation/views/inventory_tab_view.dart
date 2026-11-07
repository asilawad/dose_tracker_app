import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/inventory/controllers/inventory_controller.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/refill_reminder_banner.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/restock_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header.dart';
import 'package:dose_tracker/views/widgets/app_segment_option.dart';
import 'package:dose_tracker/views/widgets/app_segmented_control.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Inventory tab ("Medicine Cabinet"): the body only, without a
/// scaffold, because the main shell owns the scaffold and the bottom bar.
///
/// It shows a spinner while loading, an error with retry, an empty state
/// when there are no medications, and otherwise one card per medication and,
/// when something runs low, the refill banner. Tapping
/// a medication opens the refill sheet. The controller comes from
/// `InventoryBinding`.
class InventoryTabView extends GetView<InventoryController> {
  const InventoryTabView({super.key});

  void _openRestock(InventoryItem item) {
    final String left = AppStrings.inventoryLeft.trParams(<String, String>{
      'count': DoseFormatter.quantity((item.stockRemaining ?? 0).toDouble()),
    });
    AppBottomSheet.show<void>(
      title: AppStrings.inventoryRestockFor.trParams(<String, String>{
        'name': item.medicationName,
      }),
      subtitle: '${item.profileName} · $left',
      child: RestockSheetContent(
        onSave: (int newStock) => controller.restock(item, newStock),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Widget body;
      if (controller.isLoading.value) {
        body = const SliverFillRemaining(child: LoadingState());
      } else if (controller.hasError.value) {
        body = SliverFillRemaining(
          child: ErrorState(onRetry: controller.retry),
        );
      } else if (controller.items.isEmpty) {
        body = SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppSizes.bottomOverlayClearance,
            ),
            child: EmptyState(
              icon: Icons.inventory_2_outlined,
              title: AppStrings.inventoryEmptyTitle.tr,
              message: AppStrings.inventoryEmptyMessage.tr,
            ),
          ),
        );
      } else {
        body = _list();
      }

      return CustomScrollView(
        slivers: <Widget>[
          AppCollapsingHeader(
            title: AppStrings.inventoryTitle.tr,
            eyebrowIcon: Icons.inventory_2_rounded,
            eyebrowLabel: controller.items.isEmpty
                ? null
                : AppStrings.inventoryCount.trParams(<String, String>{
                    'count': '${controller.items.length}',
                  }),
          ),
          body,
        ],
      );
    });
  }

  Widget _list() {
    final int lowCount = controller.lowStockCount;

    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSizes.screenPaddingHorizontal,
        AppSizes.spaceSm,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space2xl + AppSizes.bottomOverlayClearance,
      ),
      sliver: SliverList.list(
        children: <Widget>[
          if (lowCount > 0) ...<Widget>[
            RefillReminderBanner(
              count: lowCount,
              isFiltered: controller.showLowOnly.value,
              onTap: controller.toggleLowOnly,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            AppSegmentedControl<bool>(
              options: <AppSegmentOption<bool>>[
                AppSegmentOption<bool>(
                  value: false,
                  label: AppStrings.inventoryFilterAll.trParams(
                    <String, String>{'count': '${controller.items.length}'},
                  ),
                ),
                AppSegmentOption<bool>(
                  value: true,
                  label: AppStrings.inventoryFilterLow.trParams(
                    <String, String>{'count': '$lowCount'},
                  ),
                ),
              ],
              selected: controller.showLowOnly.value,
              onChanged: (bool lowOnly) {
                if (lowOnly != controller.showLowOnly.value) {
                  controller.toggleLowOnly();
                }
              },
            ),
            const SizedBox(height: AppSizes.spaceMd),
          ],
          for (final InventoryItem item in controller.visibleItems)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.gutter),
              child: InventoryItemCard(
                key: ValueKey<int>(item.medicationId),
                item: item,
                onActiveChanged: (bool isActive) =>
                    controller.setActive(item, isActive: isActive),
                onRestock: item.trackInventory
                    ? () => _openRestock(item)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

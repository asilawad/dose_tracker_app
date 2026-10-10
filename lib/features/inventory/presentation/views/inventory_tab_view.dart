import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/inventory/controllers/inventory_controller.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/inventory_summary_card.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/refill_reminder_banner.dart';
import 'package:dose_tracker/features/inventory/presentation/widgets/restock_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Inventory tab ("Medicine Cabinet"): the body only, without a
/// scaffold, because the main shell owns the scaffold and the bottom bar.
///
/// It shows a spinner while loading, an error with retry, an empty state
/// when there are no medications, and otherwise the stock summary, one card
/// per medication and, when something runs low, the refill banner. Tapping
/// a medication opens the refill sheet. The controller comes from
/// `InventoryBinding`.
class InventoryTabView extends GetView<InventoryController> {
  const InventoryTabView({super.key});

  void _openRestock(InventoryItem item) {
    AppBottomSheet.show<void>(
      title: AppStrings.inventoryRestockTitle.tr,
      child: RestockSheetContent(
        onSave: (int newStock) => controller.restock(item, newStock),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingState();
      }
      if (controller.hasError.value) {
        return ErrorState(onRetry: controller.retry);
      }
      if (controller.items.isEmpty) {
        return EmptyState(
          icon: Icons.inventory_2_outlined,
          title: AppStrings.inventoryEmptyTitle.tr,
          message: AppStrings.inventoryEmptyMessage.tr,
        );
      }

      final double? totalFraction = controller.totalFraction;
      final int lowCount = controller.lowStockCount;

      return ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSizes.screenPaddingHorizontal,
          AppSizes.space2xl,
          AppSizes.screenPaddingHorizontal,
          AppSizes.space2xl + AppSizes.bottomOverlayClearance,
        ),
        children: <Widget>[
          Text(
            AppStrings.inventoryTitle.tr,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.space2xl),
          if (totalFraction != null) ...<Widget>[
            InventorySummaryCard(
              totalRemaining: controller.totalRemaining,
              fraction: totalFraction,
            ),
            const SizedBox(height: AppSizes.space2xl),
          ],
          Text(
            AppStrings.inventorySectionTitle.tr,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.spaceMd),
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
          if (lowCount > 0) ...<Widget>[
            const SizedBox(height: AppSizes.spaceSm),
            RefillReminderBanner(
              count: lowCount,
              isFiltered: controller.showLowOnly.value,
              onTap: controller.toggleLowOnly,
            ),
          ],
        ],
      );
    });
  }
}

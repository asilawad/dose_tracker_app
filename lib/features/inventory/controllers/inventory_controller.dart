import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/inventory/data/repositories/inventory_repository.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:get/get.dart';

/// State and actions of the Inventory tab: the live list of medications with
/// their stock, the overall stock summary, the low-stock filter, and the
/// pause and refill actions.
///
/// A medication needs a refill when it is active, tracks stock and is at or
/// below the low-stock level. The filter turns itself off when no medication
/// needs a refill anymore. The list updates by itself after every action,
/// because it listens to the repository stream.
class InventoryController extends GetxController {
  InventoryController(this._inventory, this._medications);

  final InventoryRepository _inventory;
  final MedicationsRepository _medications;

  final RxList<InventoryItem> items = <InventoryItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool showLowOnly = false.obs;

  StreamSubscription<List<InventoryItem>>? _subscription;

  /// What the list shows: every item, or only those that need a refill.
  List<InventoryItem> get visibleItems {
    return showLowOnly.value
        ? items.where(_needsRefill).toList()
        : items.toList();
  }

  int get lowStockCount => items.where(_needsRefill).length;

  bool get hasTrackedStock {
    return items.any((InventoryItem item) => item.remainingFraction != null);
  }

  /// Stock left across every medication that tracks stock.
  int get totalRemaining {
    int sum = 0;
    for (final InventoryItem item in items) {
      if (item.remainingFraction != null) {
        sum += item.stockRemaining ?? 0;
      }
    }
    return sum;
  }

  /// The part of the combined stock still left, from 0 to 1, or null when
  /// no medication tracks stock.
  double? get totalFraction {
    int remaining = 0;
    int total = 0;
    for (final InventoryItem item in items) {
      if (item.remainingFraction != null) {
        remaining += item.stockRemaining ?? 0;
        total += item.stockTotal ?? 0;
      }
    }
    if (total <= 0) {
      return null;
    }
    return (remaining / total).clamp(0.0, 1.0).toDouble();
  }

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void retry() => _listen();

  void toggleLowOnly() {
    showLowOnly.value = !showLowOnly.value;
  }

  /// Pauses or resumes a medication.
  Future<void> setActive(InventoryItem item, {required bool isActive}) async {
    final SetActiveResult result = await _medications.setActive(
      medicationId: item.medicationId,
      isActive: isActive,
    );
    switch (result) {
      case SetActiveSuccess():
        return;
      case SetActiveNotFound():
        AppSnackbar.error(AppStrings.stateErrorGeneric.tr);
    }
  }

  /// Records a refill of [item] to [newStock]. Returns true when it was
  /// saved; on failure it shows an error and returns false.
  Future<bool> restock(InventoryItem item, int newStock) async {
    final RestockResult result = await _medications.restock(
      medicationId: item.medicationId,
      newStock: newStock,
    );
    switch (result) {
      case RestockSuccess():
        return true;
      case RestockNotFound():
      case RestockNotTracked():
      case RestockInvalidAmount():
        AppSnackbar.error(AppStrings.stateErrorGeneric.tr);
        return false;
    }
  }

  bool _needsRefill(InventoryItem item) => item.isActive && item.isLowStock;

  void _listen() {
    hasError.value = false;
    isLoading.value = true;
    _subscription?.cancel();
    _subscription = _inventory.watchItems().listen(
      (List<InventoryItem> list) {
        items.assignAll(list);
        if (showLowOnly.value && lowStockCount == 0) {
          showLowOnly.value = false;
        }
        hasError.value = false;
        isLoading.value = false;
      },
      onError: (Object _) {
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:flutter/foundation.dart';

/// One medication as the inventory screen shows it: its name and dose, who
/// it is for, whether it is active, and its stock.
///
/// It is built from a medication and its profile, never stored. The stock
/// fields are null when [trackInventory] is false.
@immutable
class InventoryItem {
  const InventoryItem({
    required this.medicationId,
    required this.profileName,
    required this.personaColor,
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.isActive,
    required this.trackInventory,
    required this.stockTotal,
    required this.stockRemaining,
  });

  final int medicationId;
  final String profileName;
  final PersonaColor personaColor;
  final String medicationName;
  final double doseAmount;
  final DoseUnit doseUnit;
  final bool isActive;
  final bool trackInventory;
  final int? stockTotal;
  final int? stockRemaining;

  /// The part of the stock left, from 0 to 1, or null when not tracked.
  double? get remainingFraction {
    if (!trackInventory) {
      return null;
    }
    return StockPolicy.remainingFraction(
      total: stockTotal,
      remaining: stockRemaining,
    );
  }

  /// True when the stock is tracked and at or below the low-stock level.
  bool get isLowStock {
    return trackInventory &&
        StockPolicy.isLow(total: stockTotal, remaining: stockRemaining);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryItem &&
        other.medicationId == medicationId &&
        other.profileName == profileName &&
        other.personaColor == personaColor &&
        other.medicationName == medicationName &&
        other.doseAmount == doseAmount &&
        other.doseUnit == doseUnit &&
        other.isActive == isActive &&
        other.trackInventory == trackInventory &&
        other.stockTotal == stockTotal &&
        other.stockRemaining == stockRemaining;
  }

  @override
  int get hashCode => Object.hash(
    medicationId,
    profileName,
    personaColor,
    medicationName,
    doseAmount,
    doseUnit,
    isActive,
    trackInventory,
    stockTotal,
    stockRemaining,
  );
}

import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:flutter/foundation.dart';

/// One medication as the inventory screen shows it: its name and dose, who
/// it is for, whether it is active, and its stock.
///
/// It is built from a medication and its profile, never stored. The stock
/// fields are null when [trackInventory] is false. [stockThreshold] is the
/// refill alert level.
@immutable
class InventoryItem {
  const InventoryItem({
    required this.medicationId,
    required this.profileName,
    required this.personaColor,
    this.profileAvatar,
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.isActive,
    required this.trackInventory,
    required this.stockThreshold,
    required this.stockRemaining,
  });

  final int medicationId;
  final String profileName;
  final PersonaColor personaColor;
  final ProfileAvatar? profileAvatar;
  final String medicationName;
  final double doseAmount;
  final DoseUnit doseUnit;
  final bool isActive;
  final bool trackInventory;
  final int? stockThreshold;
  final int? stockRemaining;

  /// True when the stock is tracked and the count left is known.
  bool get tracksStock => trackInventory && stockRemaining != null;

  /// True when the stock is tracked and at or below the refill alert level.
  bool get isLowStock {
    return trackInventory &&
        StockPolicy.isLow(
          remaining: stockRemaining,
          threshold: stockThreshold,
        );
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryItem &&
        other.medicationId == medicationId &&
        other.profileName == profileName &&
        other.personaColor == personaColor &&
        other.profileAvatar == profileAvatar &&
        other.medicationName == medicationName &&
        other.doseAmount == doseAmount &&
        other.doseUnit == doseUnit &&
        other.isActive == isActive &&
        other.trackInventory == trackInventory &&
        other.stockThreshold == stockThreshold &&
        other.stockRemaining == stockRemaining;
  }

  @override
  int get hashCode => Object.hash(
    medicationId,
    profileName,
    personaColor,
    profileAvatar,
    medicationName,
    doseAmount,
    doseUnit,
    isActive,
    trackInventory,
    stockThreshold,
    stockRemaining,
  );
}

import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:flutter/foundation.dart';

/// The public view of a medication with its dose times: only what screens
/// may show.
///
/// Screens never see the database row. The repository builds this from it.
/// Only the [id] travels between routes, never this object. Stock fields are
/// null when [trackInventory] is false. [doseTimes] is ordered earliest first.
@immutable
class Medication {
  const Medication({
    required this.id,
    required this.profileId,
    required this.name,
    required this.doseAmount,
    required this.doseUnit,
    required this.mealInstruction,
    required this.trackInventory,
    required this.stockTotal,
    required this.stockRemaining,
    required this.isActive,
    required this.createdAt,
    required this.doseTimes,
  });

  final int id;
  final int profileId;
  final String name;
  final double doseAmount;
  final DoseUnit doseUnit;
  final MealInstruction? mealInstruction;
  final bool trackInventory;
  final int? stockTotal;
  final int? stockRemaining;
  final bool isActive;

  /// When the medication was added. Its doses appear in the schedule only
  /// from this day on, so older days never show doses that did not exist.
  final DateTime createdAt;
  final List<DoseTime> doseTimes;
  @override
  bool operator ==(Object other) {
    return other is Medication &&
        other.id == id &&
        other.profileId == profileId &&
        other.name == name &&
        other.doseAmount == doseAmount &&
        other.doseUnit == doseUnit &&
        other.mealInstruction == mealInstruction &&
        other.trackInventory == trackInventory &&
        other.stockTotal == stockTotal &&
        other.stockRemaining == stockRemaining &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        listEquals(other.doseTimes, doseTimes);
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    doseAmount,
    doseUnit,
    mealInstruction,
    trackInventory,
    stockTotal,
    stockRemaining,
    isActive,
    createdAt,
    Object.hashAll(doseTimes),
  );
}

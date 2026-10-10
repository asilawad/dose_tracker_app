import 'dart:async';

import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';

/// Builds the inventory list from the logged-in account's medications and
/// profiles. It only reads: refilling and pausing go through
/// [MedicationsRepository].
///
/// Call it only after login. Every medication of an existing profile is
/// listed, whether or not it tracks stock and whether or not it is paused.
class InventoryRepository {
  const InventoryRepository({
    required MedicationsRepository medications,
    required ProfilesRepository profiles,
  }) : _medications = medications,
       _profiles = profiles;

  final MedicationsRepository _medications;
  final ProfilesRepository _profiles;

  /// Live list of inventory items, oldest medication first. Emits again when
  /// a medication or a profile changes.
  Stream<List<InventoryItem>> watchItems() {
    late final StreamController<List<InventoryItem>> controller;
    StreamSubscription<List<Medication>>? medicationsSubscription;
    StreamSubscription<List<Profile>>? profilesSubscription;
    List<Medication>? latestMedications;
    List<Profile>? latestProfiles;

    void emit() {
      final List<Medication>? medications = latestMedications;
      final List<Profile>? profiles = latestProfiles;
      if (medications == null || profiles == null) {
        return;
      }
      controller.add(_combine(medications, profiles));
    }

    controller = StreamController<List<InventoryItem>>(
      onListen: () {
        medicationsSubscription = _medications.watchMedications().listen((
          List<Medication> value,
        ) {
          latestMedications = value;
          emit();
        }, onError: controller.addError);
        profilesSubscription = _profiles.watchProfiles().listen((
          List<Profile> value,
        ) {
          latestProfiles = value;
          emit();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await medicationsSubscription?.cancel();
        await profilesSubscription?.cancel();
      },
    );
    return controller.stream;
  }

  List<InventoryItem> _combine(
    List<Medication> medications,
    List<Profile> profiles,
  ) {
    final Map<int, Profile> profilesById = <int, Profile>{
      for (final Profile profile in profiles) profile.id: profile,
    };
    final List<InventoryItem> items = <InventoryItem>[];
    for (final Medication medication in medications) {
      final Profile? profile = profilesById[medication.profileId];
      if (profile == null) {
        continue;
      }
      items.add(
        InventoryItem(
          medicationId: medication.id,
          profileName: profile.name,
          personaColor: profile.personaColor,
          medicationName: medication.name,
          doseAmount: medication.doseAmount,
          doseUnit: medication.doseUnit,
          isActive: medication.isActive,
          trackInventory: medication.trackInventory,
          stockTotal: medication.stockTotal,
          stockRemaining: medication.stockRemaining,
        ),
      );
    }
    return items;
  }
}

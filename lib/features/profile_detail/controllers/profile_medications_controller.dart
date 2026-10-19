import 'dart:async';

import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

class ProfileMedicationsController extends GetxController {
  ProfileMedicationsController(
    this._profiles,
    this._medicationsRepository,
    this._profileId,
  );

  final ProfilesRepository _profiles;
  final MedicationsRepository _medicationsRepository;
  final int? _profileId;

  final RxList<Medication> medications = <Medication>[].obs;
  final Rxn<Profile> profile = Rxn<Profile>();
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<List<Medication>>? _medicationsSubscription;
  List<Medication>? _latestMedications;
  bool _closing = false;

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void retry() {
    hasError.value = false;
    isLoading.value = true;
    _listen();
  }

  void openAddMedication() {
    final int? id = _profileId;
    if (id != null) {
      Get.toNamed<void>(AppRoutes.addMedication, arguments: id);
    }
  }

  void _listen() {
    _cancel();
    _latestMedications = null;
    profile.value = null;
    if (_profileId == null) {
      _fail();
      return;
    }
    _profilesSubscription = _profiles.watchProfiles().listen(
      _onProfiles,
      onError: (Object _) => _fail(),
    );
    _medicationsSubscription = _medicationsRepository
        .watchMedications()
        .listen(_onMedications, onError: (Object _) => _fail());
  }

  void _onProfiles(List<Profile> profiles) {
    final int? id = _profileId;
    Profile? found;
    for (final Profile item in profiles) {
      if (item.id == id) {
        found = item;
        break;
      }
    }
    if (found == null) {
      if (!_closing) {
        _closing = true;
        Get.back<void>();
      }
      return;
    }
    profile.value = found;
    _emit();
  }

  void _onMedications(List<Medication> value) {
    _latestMedications = value;
    _emit();
  }

  void _emit() {
    final int? id = _profileId;
    final Profile? currentProfile = profile.value;
    final List<Medication>? allMedications = _latestMedications;
    if (id == null || currentProfile == null || allMedications == null) {
      return;
    }
    medications.assignAll(
      allMedications.where((Medication item) => item.profileId == id),
    );
    hasError.value = false;
    isLoading.value = false;
  }

  void _fail() {
    hasError.value = true;
    isLoading.value = false;
  }

  void _cancel() {
    _profilesSubscription?.cancel();
    _medicationsSubscription?.cancel();
    _profilesSubscription = null;
    _medicationsSubscription = null;
  }

  @override
  void onClose() {
    _cancel();
    super.onClose();
  }
}

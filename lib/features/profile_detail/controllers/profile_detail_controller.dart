import 'dart:async';

import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/home/data/repositories/profile_summary_builder.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/controllers/dose_actions.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:get/get.dart';

/// State of one profile's page: its summary, today's doses and medications.
///
/// It listens to profiles, medications and today's doses, and shows the page
/// only after all three have emitted once. If the profile no longer exists
/// (for example it was deleted from Edit Profile), it returns to the main
/// shell. Pressing a taken dose undoes it; any other dose is taken.
class ProfileDetailController extends GetxController {
  ProfileDetailController(
    this._profiles,
    this._medications,
    this._doseLogs,
    this._profileId,
  ) : actions = DoseActions(_doseLogs);

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;
  final DoseLogsRepository _doseLogs;
  final DoseActions actions;
  final int? _profileId;

  final Rxn<ProfileSummary> summary = Rxn<ProfileSummary>();
  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  List<Profile>? _latestProfiles;
  List<Medication>? _latestMedications;
  List<ScheduledDose>? _latestDoses;
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

  void openEdit() {
    final int? id = _profileId;
    if (id != null) {
      Get.toNamed<void>(AppRoutes.editProfile, arguments: id);
    }
  }

  void openAddMedication() {
    final int? id = _profileId;
    if (id != null) {
      Get.toNamed<void>(AppRoutes.addMedication, arguments: id);
    }
  }

  void openAllMedications() {
    final int? id = _profileId;
    if (id != null) {
      Get.toNamed<void>(AppRoutes.profileMedications, arguments: id);
    }
  }

  void _listen() {
    _cancel();
    _latestProfiles = null;
    _latestMedications = null;
    _latestDoses = null;
    if (_profileId == null) {
      _fail();
      return;
    }
    _subscriptions
      ..add(
        _profiles.watchProfiles().listen((List<Profile> list) {
          _latestProfiles = list;
          _emit();
        }, onError: (Object _) => _fail()),
      )
      ..add(
        _medications.watchMedications().listen((List<Medication> list) {
          _latestMedications = list;
          _emit();
        }, onError: (Object _) => _fail()),
      )
      ..add(
        _doseLogs.watchDay(DosePlanner.dayStart(DateTime.now())).listen((
          List<ScheduledDose> list,
        ) {
          _latestDoses = list;
          _emit();
        }, onError: (Object _) => _fail()),
      );
  }

  void _emit() {
    final List<Profile>? allProfiles = _latestProfiles;
    final List<Medication>? allMedications = _latestMedications;
    final List<ScheduledDose>? allDoses = _latestDoses;
    if (allProfiles == null || allMedications == null || allDoses == null) {
      return;
    }
    final List<Profile> found = allProfiles
        .where((Profile profile) => profile.id == _profileId)
        .toList();
    if (found.isEmpty) {
      _closeToShell();
      return;
    }
    doses.assignAll(
      allDoses.where((ScheduledDose dose) => dose.profileId == _profileId),
    );
    summary.value = ProfileSummaryBuilder.build(
      profiles: found,
      medications: allMedications,
      doses: allDoses,
    ).single;
    hasError.value = false;
    isLoading.value = false;
  }

  void _closeToShell() {
    if (_closing) {
      return;
    }
    _closing = true;
    Get.until(
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  void _fail() {
    hasError.value = true;
    isLoading.value = false;
  }

  void _cancel() {
    for (final StreamSubscription<Object?> subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void onClose() {
    _cancel();
    super.onClose();
  }
}

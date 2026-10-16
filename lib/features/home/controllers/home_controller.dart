import 'dart:async';

import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/home/data/repositories/profile_summary_builder.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:get/get.dart';

/// State of the Home tab: one live summary per profile (medication count and
/// today's progress), the loading flag and the error flag.
///
/// It listens to three streams (profiles, medications, today's doses) and
/// rebuilds the list when any of them emits, but only after all three have
/// emitted once, so the cards never flash a wrong zero. [retry] listens
/// again after an error.
class HomeController extends GetxController {
  HomeController(this._profiles, this._medications, this._doseLogs);

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;
  final DoseLogsRepository _doseLogs;

  final RxList<ProfileSummary> summaries = <ProfileSummary>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  List<Profile>? _latestProfiles;
  List<Medication>? _latestMedications;
  List<ScheduledDose>? _latestDoses;

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

  void openAddProfile() {
    Get.toNamed<void>(AppRoutes.addProfile);
  }

  void openProfile(int profileId) {
    Get.toNamed<void>(AppRoutes.profile, arguments: profileId);
  }

  void _listen() {
    _cancel();
    _latestProfiles = null;
    _latestMedications = null;
    _latestDoses = null;
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
    final List<Profile>? profiles = _latestProfiles;
    final List<Medication>? medications = _latestMedications;
    final List<ScheduledDose>? doses = _latestDoses;
    if (profiles == null || medications == null || doses == null) {
      return;
    }
    summaries.assignAll(
      ProfileSummaryBuilder.build(
        profiles: profiles,
        medications: medications,
        doses: doses,
      ),
    );
    hasError.value = false;
    isLoading.value = false;
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

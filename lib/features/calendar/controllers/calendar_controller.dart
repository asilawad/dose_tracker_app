import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/calendar/data/models/adherence_day.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_log_results.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:get/get.dart';

/// State and actions of the Adherence Calendar: the chosen profile, the
/// month shown, the chosen day, the per-day status of the month and the
/// month's adherence rate.
///
/// The month's doses come live from the repository, so the calendar updates
/// by itself when a dose is recorded (including from [logNow]); moving to
/// another month listens to that month instead. The doses of every profile
/// are loaded, and the getters pick the chosen profile's. Doses of a day
/// after today cannot be recorded.
class CalendarController extends GetxController {
  CalendarController(this._profiles, this._doseLogs);

  final ProfilesRepository _profiles;
  final DoseLogsRepository _doseLogs;

  final RxList<Profile> profiles = <Profile>[].obs;
  final Rxn<int> selectedProfileId = Rxn<int>();
  final Rx<DateTime> visibleMonth = _monthOf(DateTime.now()).obs;
  final Rx<DateTime> selectedDate = DosePlanner.dayStart(DateTime.now()).obs;
  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<List<ScheduledDose>>? _dosesSubscription;

  /// One entry per day of the visible month, for the chosen profile.
  List<AdherenceDay> get monthDays {
    final DateTime month = visibleMonth.value;
    final int? profileId = selectedProfileId.value;
    final Map<int, List<ScheduledDose>> byDay = <int, List<ScheduledDose>>{};
    for (final ScheduledDose dose in doses) {
      if (dose.profileId == profileId) {
        byDay.putIfAbsent(dose.date.day, () => <ScheduledDose>[]).add(dose);
      }
    }
    return <AdherenceDay>[
      for (int day = 1; day <= _daysInMonth(month); day++)
        AdherenceDay.fromDoses(
          date: DateTime(month.year, month.month, day),
          doses: byDay[day] ?? const <ScheduledDose>[],
        ),
    ];
  }

  /// The share of due doses taken this month, from 0 to 1, or null when
  /// none was due yet.
  double? get monthRate => AdherenceDay.rate(monthDays);

  /// Empty cells before the first day of the month in the week grid.
  int get leadingBlankDays {
    final DateTime month = visibleMonth.value;
    return (DateTime(month.year, month.month).weekday -
            ScheduleController.weekStartWeekday) %
        DateTime.daysPerWeek;
  }

  /// The chosen profile's doses on the chosen day, earliest first.
  List<ScheduledDose> get selectedDayDoses {
    final int? profileId = selectedProfileId.value;
    final DateTime day = selectedDate.value;
    return doses
        .where(
          (ScheduledDose dose) =>
              dose.profileId == profileId && dose.date == day,
        )
        .toList();
  }

  AdherenceDay get selectedDay {
    return AdherenceDay.fromDoses(
      date: selectedDate.value,
      doses: selectedDayDoses,
    );
  }

  /// False for days after today, whose doses cannot be recorded.
  bool get canLogSelectedDay {
    return !selectedDate.value.isAfter(DosePlanner.dayStart(DateTime.now()));
  }

  @override
  void onInit() {
    super.onInit();
    _profilesSubscription = _profiles.watchProfiles().listen(_onProfiles);
    _listenMonth();
  }

  void retry() => _listenMonth();

  void selectProfile(int id) {
    selectedProfileId.value = id;
  }

  void selectDate(DateTime date) {
    selectedDate.value = DosePlanner.dayStart(date);
  }

  /// Moves the visible month by [months] (negative goes back). The chosen
  /// day becomes today when the new month is the current one, otherwise the
  /// first day of that month.
  void shiftMonths(int months) {
    final DateTime month = visibleMonth.value;
    final DateTime target = DateTime(month.year, month.month + months);
    final DateTime today = DosePlanner.dayStart(DateTime.now());
    visibleMonth.value = target;
    selectedDate.value =
        today.year == target.year && today.month == target.month
        ? today
        : target;
    _listenMonth();
  }

  /// Records a pending, missed or skipped dose of the chosen day as taken.
  Future<void> logNow(ScheduledDose dose) async {
    if (!canLogSelectedDay) {
      return;
    }
    final LogDoseResult result = await _doseLogs.takeDose(
      medicationId: dose.medicationId,
      date: dose.date,
      minuteOfDay: dose.minuteOfDay,
    );
    switch (result) {
      case LogDoseSuccess():
        return;
      case LogDoseNotFound():
      case LogDoseFutureDay():
        AppSnackbar.error(AppStrings.stateErrorGeneric.tr);
    }
  }

  void _onProfiles(List<Profile> list) {
    profiles.assignAll(list);
    final bool stillExists = list.any(
      (Profile profile) => profile.id == selectedProfileId.value,
    );
    if (!stillExists) {
      selectedProfileId.value = list.isEmpty ? null : list.first.id;
    }
  }

  void _listenMonth() {
    hasError.value = false;
    isLoading.value = true;
    _dosesSubscription?.cancel();
    final DateTime month = visibleMonth.value;
    _dosesSubscription = _doseLogs
        .watchDays(start: month, days: _daysInMonth(month))
        .listen(
          (List<ScheduledDose> list) {
            doses.assignAll(list);
            hasError.value = false;
            isLoading.value = false;
          },
          onError: (Object _) {
            hasError.value = true;
            isLoading.value = false;
          },
        );
  }

  static DateTime _monthOf(DateTime value) => DateTime(value.year, value.month);

  static int _daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  @override
  void onClose() {
    _profilesSubscription?.cancel();
    _dosesSubscription?.cancel();
    super.onClose();
  }
}

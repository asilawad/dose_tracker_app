import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/notifications/data/models/planned_reminder.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_results.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

/// Whether the app may show notifications on this device.
enum ReminderPermission { granted, denied, unsupported }

/// The only place that talks to the notification plugin.
///
/// It works on Android only; on any other platform every method does
/// nothing and says so in its result, so the rest of the app never checks
/// the platform. Reminders are scheduled as separate notifications at fixed
/// moments (UTC instants, so the time zone database is not needed), and a
/// new schedule replaces the old one. Low-stock notifications use ids from
/// [_lowStockIdBase] up, so replacing the schedule never touches them.
///
/// Create it once at startup with
/// `await Get.putAsync(ReminderService.create, permanent: true)`.
class ReminderService extends GetxService {
  ReminderService._(this._plugin, {required this.isSupported});

  static const String _channelId = 'dose_reminders';
  static const String _androidIcon = '@drawable/ic_stat_dose';
  static const int _lowStockIdBase = 2000000000;
  static const int _lowStockIdSlots = 100000;

  final FlutterLocalNotificationsPlugin _plugin;

  /// True only on Android.
  final bool isSupported;

  static Future<ReminderService> create() async {
    final bool supported =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();
    if (supported) {
      await plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(_androidIcon),
        ),
      );
    }
    return ReminderService._(plugin, isSupported: supported);
  }

  AndroidFlutterLocalNotificationsPlugin? get _android {
    return _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  /// The current permission, without asking the user.
  Future<ReminderPermission> permission() async {
    if (!isSupported) {
      return ReminderPermission.unsupported;
    }
    final bool? enabled = await _android?.areNotificationsEnabled();
    return enabled == true
        ? ReminderPermission.granted
        : ReminderPermission.denied;
  }

  /// Asks the user to allow notifications, and exact alarms when the system
  /// needs a separate approval for them.
  Future<ReminderPermission> requestPermission() async {
    if (!isSupported) {
      return ReminderPermission.unsupported;
    }
    final AndroidFlutterLocalNotificationsPlugin? android = _android;
    final bool? allowed = await android?.requestNotificationsPermission();
    if (allowed != true) {
      return ReminderPermission.denied;
    }
    final bool? canScheduleExact = await android
        ?.canScheduleExactNotifications();
    if (canScheduleExact != true) {
      await android?.requestExactAlarmsPermission();
    }
    return ReminderPermission.granted;
  }

  /// Replaces every scheduled reminder with [reminders].
  Future<ScheduleRemindersResult> scheduleAll(
    List<PlannedReminder> reminders,
  ) async {
    if (!isSupported) {
      return const RemindersUnsupported();
    }
    try {
      await _cancelScheduled();
      if (reminders.isEmpty) {
        return const RemindersScheduled(0);
      }
      if (await permission() != ReminderPermission.granted) {
        return const RemindersNotAllowed();
      }

      final bool exact =
          await _android?.canScheduleExactNotifications() ?? false;
      final AndroidScheduleMode mode = exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
      final NotificationDetails details = _details();

      for (final PlannedReminder reminder in reminders) {
        final String medication = _medicationLabel(reminder.dose);
        await _plugin.zonedSchedule(
          id: reminder.id,
          title: AppStrings.notifDoseTitle.tr,
          body:
              (reminder.isRepeat
                      ? AppStrings.notifRepeatBody
                      : AppStrings.notifDoseBody)
                  .trParams(<String, String>{
                    'medication': medication,
                    'profile': reminder.dose.profileName,
                  }),
          scheduledDate: tz.TZDateTime.from(reminder.scheduledAt, tz.UTC),
          notificationDetails: details,
          androidScheduleMode: mode,
        );
      }
      return RemindersScheduled(reminders.length);
    } on Object {
      return const RemindersFailed();
    }
  }

  /// Shows a "running low" notification now. Returns true when it was shown.
  Future<bool> showLowStock({
    required int medicationId,
    required String medicationLabel,
    required String profileName,
    required int remaining,
  }) async {
    if (!isSupported || await permission() != ReminderPermission.granted) {
      return false;
    }
    try {
      await _plugin.show(
        id: _lowStockIdBase + medicationId % _lowStockIdSlots,
        title: AppStrings.notifLowStockTitle.tr,
        body: AppStrings.notifLowStockBody.trParams(<String, String>{
          'medication': medicationLabel,
          'profile': profileName,
          'count': DoseFormatter.quantity(remaining.toDouble()),
        }),
        notificationDetails: _details(),
      );
      return true;
    } on Object {
      return false;
    }
  }

  /// Cancels the scheduled reminders but leaves low-stock notifications.
  Future<void> _cancelScheduled() async {
    final List<PendingNotificationRequest> pending = await _plugin
        .pendingNotificationRequests();
    for (final PendingNotificationRequest request in pending) {
      if (request.id < _lowStockIdBase) {
        await _plugin.cancel(id: request.id);
      }
    }
  }

  NotificationDetails _details() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        AppStrings.notifChannelName.tr,
        channelDescription: AppStrings.notifChannelDescription.tr,
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  String _medicationLabel(ScheduledDose dose) {
    return '${dose.medicationName} ${DoseFormatter.quantity(dose.doseAmount)} '
        '${dose.doseUnit.labelKey.tr}';
  }
}

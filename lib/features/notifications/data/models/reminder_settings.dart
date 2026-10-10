import 'package:flutter/foundation.dart';

/// How often a dose reminder repeats while the dose is still not recorded.
/// [minutes] is the gap between repeats; [off] sends only the first
/// reminder at the dose time.
enum ReminderEscalation {
  off(0),
  everyThirtyMinutes(30),
  everyHour(60),
  everyTwoHours(120);

  const ReminderEscalation(this.minutes);

  final int minutes;

  /// The option that has [minutes], or the default (every hour) when the
  /// value is missing or unknown.
  static ReminderEscalation fromMinutes(int? minutes) {
    for (final ReminderEscalation option in values) {
      if (option.minutes == minutes) {
        return option;
      }
    }
    return everyHour;
  }
}

/// The user's reminder choices for this device: reminders on or off, and
/// how they repeat.
@immutable
class ReminderSettings {
  const ReminderSettings({required this.enabled, required this.escalation});

  /// Reminders on, repeating every hour.
  static const ReminderSettings defaults = ReminderSettings(
    enabled: true,
    escalation: ReminderEscalation.everyHour,
  );

  final bool enabled;
  final ReminderEscalation escalation;

  ReminderSettings copyWith({bool? enabled, ReminderEscalation? escalation}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      escalation: escalation ?? this.escalation,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReminderSettings &&
        other.enabled == enabled &&
        other.escalation == escalation;
  }

  @override
  int get hashCode => Object.hash(enabled, escalation);
}

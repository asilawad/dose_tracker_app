/// Typed outcomes of scheduling the reminders. The service returns these
/// instead of throwing, so the caller handles every case with an exhaustive
/// `switch` and the compiler flags any case that is added later and not
/// handled.
sealed class ScheduleRemindersResult {
  const ScheduleRemindersResult();
}

/// The old scheduled reminders were replaced by [count] new ones.
final class RemindersScheduled extends ScheduleRemindersResult {
  const RemindersScheduled(this.count);

  final int count;
}

/// This device cannot show scheduled reminders (only Android can).
final class RemindersUnsupported extends ScheduleRemindersResult {
  const RemindersUnsupported();
}

/// The user has not allowed notifications, so nothing was scheduled.
final class RemindersNotAllowed extends ScheduleRemindersResult {
  const RemindersNotAllowed();
}

/// The system refused or failed to schedule the reminders.
final class RemindersFailed extends ScheduleRemindersResult {
  const RemindersFailed();
}

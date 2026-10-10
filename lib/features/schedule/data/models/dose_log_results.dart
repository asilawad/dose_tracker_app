/// Typed outcomes of recording a dose. The repository returns these instead
/// of throwing, so a screen handles every case with an exhaustive `switch`
/// and the compiler flags any case that is added later and not handled.
sealed class LogDoseResult {
  const LogDoseResult();
}

final class LogDoseSuccess extends LogDoseResult {
  const LogDoseSuccess();
}

/// The medication is not in the logged-in account, or it has no dose at the
/// given time.
final class LogDoseNotFound extends LogDoseResult {
  const LogDoseNotFound();
}

/// The dose belongs to a day after today, so it cannot be recorded yet.
final class LogDoseFutureDay extends LogDoseResult {
  const LogDoseFutureDay();
}

/// Typed outcomes of undoing a recorded dose (putting it back to pending).
sealed class UndoDoseResult {
  const UndoDoseResult();
}

final class UndoDoseSuccess extends UndoDoseResult {
  const UndoDoseSuccess();
}

/// The log is not in the logged-in account, or was already removed.
final class UndoDoseNotFound extends UndoDoseResult {
  const UndoDoseNotFound();
}

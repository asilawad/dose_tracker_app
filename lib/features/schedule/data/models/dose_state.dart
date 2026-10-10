import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';

/// What a scheduled dose looks like to the user right now.
///
/// It has the four stored outcomes plus [pending], which is never stored: it
/// means no log exists for the dose yet. A dose that is still pending when
/// the next dose time or the end of the day arrives is shown as [missed].
enum DoseState { pending, taken, takenLate, skipped, missed }

extension DoseStatusAsState on DoseStatus {
  /// The display state of a stored outcome.
  DoseState get state {
    return switch (this) {
      DoseStatus.taken => DoseState.taken,
      DoseStatus.takenLate => DoseState.takenLate,
      DoseStatus.skipped => DoseState.skipped,
      DoseStatus.missed => DoseState.missed,
    };
  }
}

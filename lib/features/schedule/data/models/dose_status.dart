/// Outcome recorded for one scheduled dose.
///
/// The approved status model has five states, but "pending" (not yet due, or
/// due and not yet acted on) is never stored: it is derived from the absence
/// of a log row. Only the four outcomes below are saved. A dose becomes
/// missed at the next dose time or at the end of the day, whichever comes
/// first. Stored by enum name, so never rename a value after the app has
/// saved data. Display text comes from translations, not from here.
enum DoseStatus { taken, takenLate, skipped, missed }

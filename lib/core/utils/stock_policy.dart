/// The one rule for when a medication's stock counts as low, shared by the
/// inventory screen and the refill notifications.
///
/// Each medication has its own refill alert level (its threshold): the stock
/// is low when the count left is at or below it. A medication that does not
/// track stock is never low.
abstract final class StockPolicy {
  /// Threshold given to a new medication, in units, until the user sets one.
  static const int defaultThreshold = 5;

  /// True when both values are known and [remaining] is at or below
  /// [threshold].
  static bool isLow({required int? remaining, required int? threshold}) {
    if (remaining == null || threshold == null) {
      return false;
    }
    return remaining <= threshold;
  }
}

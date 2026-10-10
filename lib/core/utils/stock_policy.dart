/// The one rule for when a medication's stock counts as low, shared by the
/// inventory screen and the refill notifications.
///
/// The threshold is fixed at 10% of the stock total; the user cannot change
/// it. A medication that does not track stock is never low.
abstract final class StockPolicy {
  static const double lowStockFraction = 0.10;

  /// The part of the stock still left, from 0 to 1, or null when the stock
  /// is not tracked or the total is unknown or zero.
  static double? remainingFraction({
    required int? total,
    required int? remaining,
  }) {
    if (total == null || remaining == null || total <= 0) {
      return null;
    }
    return (remaining / total).clamp(0.0, 1.0).toDouble();
  }

  /// True when the stock is tracked and at or below [lowStockFraction].
  static bool isLow({required int? total, required int? remaining}) {
    final double? fraction = remainingFraction(
      total: total,
      remaining: remaining,
    );
    return fraction != null && fraction <= lowStockFraction;
  }
}

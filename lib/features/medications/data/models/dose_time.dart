import 'package:flutter/foundation.dart';

/// One scheduled intake time of a medication: minutes after local midnight
/// (0 to 1439) and the amount taken then (can be fractional, for example 0.5).
///
/// The public view of a dose time row: screens never see the database row.
@immutable
class DoseTime {
  const DoseTime({
    required this.id,
    required this.minuteOfDay,
    required this.quantity,
  });

  final int id;
  final int minuteOfDay;
  final double quantity;

  @override
  bool operator ==(Object other) {
    return other is DoseTime &&
        other.id == id &&
        other.minuteOfDay == minuteOfDay &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(id, minuteOfDay, quantity);
}

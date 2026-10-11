import 'package:flutter/foundation.dart';

/// The choices for the report's date range. [days] is the length of the
/// fixed ranges and 0 for [custom], which the user picks on a calendar.
enum ReportInterval {
  last7Days(7),
  last30Days(30),
  custom(0);

  const ReportInterval(this.days);

  final int days;
}

/// A range of whole days, both ends included, as local midnights.
@immutable
class ReportRange {
  const ReportRange({required this.from, required this.to});

  /// The longest range a report can cover.
  static const int maxDays = 366;

  /// The [days] days that end on [today] (today included).
  factory ReportRange.lastDays(int days, DateTime today) {
    return ReportRange(
      from: DateTime(today.year, today.month, today.day - days + 1),
      to: DateTime(today.year, today.month, today.day),
    );
  }

  final DateTime from;
  final DateTime to;

  /// The number of days in the range, both ends included.
  int get days {
    return DateTime.utc(
          to.year,
          to.month,
          to.day,
        ).difference(DateTime.utc(from.year, from.month, from.day)).inDays +
        1;
  }

  @override
  bool operator ==(Object other) {
    return other is ReportRange && other.from == from && other.to == to;
  }

  @override
  int get hashCode => Object.hash(from, to);
}

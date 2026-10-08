import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Locale-aware date and time formatting. Never format dates by hand.
///
/// Uses the active GetX locale, so Arabic and English output switch with
/// the language. Arabic date data is loaded by the Material localization
/// delegates, which the app registers in `app.dart`.
abstract final class DateFormatter {
  static const String _timeSkeleton = 'jm';
  static const String _dayMonthYearSkeleton = 'yMMMd';
  static const String _fullDateSkeleton = 'yMMMMEEEEd';
  static const String _monthYearSkeleton = 'yMMMM';
  static const String _weekdayShortSkeleton = 'E';
  static const String _dayNumberSkeleton = 'd';

  static String get _locale =>
      (Get.locale ?? AppTranslations.fallbackLocale).languageCode;

  /// For example 9:00 AM.
  static String time(DateTime value) =>
      DateFormat(_timeSkeleton, _locale).format(value);

  /// For example Aug 26, 2026.
  static String dayMonthYear(DateTime value) =>
      DateFormat(_dayMonthYearSkeleton, _locale).format(value);

  /// For example Wednesday, August 26, 2026.
  static String fullDate(DateTime value) =>
      DateFormat(_fullDateSkeleton, _locale).format(value);

  /// For example August 2026.
  static String monthYear(DateTime value) =>
      DateFormat(_monthYearSkeleton, _locale).format(value);

  /// For example Wed.
  static String weekdayShort(DateTime value) =>
      DateFormat(_weekdayShortSkeleton, _locale).format(value);

  /// For example 26.
  static String dayNumber(DateTime value) =>
      DateFormat(_dayNumberSkeleton, _locale).format(value);
}

import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Locale-aware text for dose schedule values. Never format these by hand.
///
/// Uses the active GetX locale, so Arabic and English output switch with
/// the language.
abstract final class DoseFormatter {
  static String get _locale =>
      (Get.locale ?? AppTranslations.fallbackLocale).languageCode;

  /// A time stored as minutes after midnight, for example 540 -> 9:00 AM.
  static String minuteOfDay(int minutes) {
    return DateFormatter.time(DateTime(0).add(Duration(minutes: minutes)));
  }

  /// A part from 0 to 1 as a percentage, for example 0.65 -> 65%.
  static String percent(double fraction) {
    return NumberFormat.percentPattern(_locale).format(fraction);
  }

  /// An amount per dose, for example 1.0 -> 1 and 0.5 -> 0.5.
  static String quantity(double value) {
    return NumberFormat.decimalPattern(_locale).format(value);
  }
}

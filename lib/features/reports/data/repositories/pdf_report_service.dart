import 'dart:typed_data';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:intl/intl.dart' show Bidi;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Builds the doctor's report as a PDF and hands it to the system share
/// sheet.
///
/// The text follows the app language and direction, and uses the Cairo font
/// from the app's assets so Arabic letters join correctly. The document is a
/// light printed page, so it always uses the light colors, whatever the app
/// theme. The page is built with the PDF package's own widgets, which are not
/// Flutter widgets; its small section builders are private methods here.
class PdfReportService {
  const PdfReportService();

  static const String _regularFontAsset = 'assets/fonts/Cairo-Regular.ttf';
  static const String _boldFontAsset = 'assets/fonts/Cairo-Bold.ttf';

  // Sizes are in PDF points, not screen pixels.
  static const double _margin = 32;
  static const double _gap = 10;
  static const double _bigGap = 18;
  static const double _padding = 12;
  static const double _radius = 8;
  static const double _barHeight = 6;
  static const double _titleSize = 22;
  static const double _headingSize = 14;
  static const double _bodySize = 11;
  static const double _smallSize = 9;
  static const double _percentSize = 26;
  static const double _numberSize = 16;

  /// Adherence at or above this share is shown as good, at or above
  /// [_fairRate] as fair, and below it as poor.
  static const double _goodRate = 0.85;
  static const double _fairRate = 0.6;

  static const int _percentScale = 100;

  /// The PDF bytes of [report].
  Future<Uint8List> build(DoctorReport report) async {
    final pw.Font regular = pw.Font.ttf(
      await rootBundle.load(_regularFontAsset),
    );
    final pw.Font bold = pw.Font.ttf(await rootBundle.load(_boldFontAsset));
    final String languageCode =
        (Get.locale ?? AppTranslations.fallbackLocale).languageCode;
    final bool isRtl = Bidi.isRtlLanguage(languageCode);
    const AppColorTokens colors = AppColorTokens.light;

    final pw.Document document = pw.Document(title: AppStrings.reportTitle.tr);
    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(_margin),
          theme: pw.ThemeData.withFont(base: regular, bold: bold),
          textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        ),
        footer: (pw.Context context) => pw.Text(
          AppStrings.reportFooter.tr,
          style: pw.TextStyle(
            fontSize: _smallSize,
            color: _pdf(colors.textSecondary),
          ),
        ),
        build: (pw.Context context) => <pw.Widget>[
          _header(report, colors),
          pw.SizedBox(height: _bigGap),
          _overview(report, colors),
          pw.SizedBox(height: _bigGap),
          _sectionTitle(AppStrings.reportDetailsTitle.tr, colors),
          pw.SizedBox(height: _gap),
          for (final MedicationReportLine line in report.lines) ...<pw.Widget>[
            _lineCard(line, colors),
            pw.SizedBox(height: _gap),
          ],
          pw.SizedBox(height: _gap),
          _sectionTitle(AppStrings.reportMissedTitle.tr, colors),
          pw.SizedBox(height: _gap),
          _missedList(report, colors),
          if (report.notes != null) ...<pw.Widget>[
            pw.SizedBox(height: _bigGap),
            _sectionTitle(AppStrings.reportNotesTitle.tr, colors),
            pw.SizedBox(height: _gap),
            _notes(report.notes!, colors),
          ],
        ],
      ),
    );
    return document.save();
  }

  /// Opens the system share sheet for [bytes]. Returns true when it opened.
  Future<bool> share(Uint8List bytes, DoctorReport report) async {
    try {
      return await Printing.sharePdf(
        bytes: bytes,
        filename: DateFormatter.fileName(report.from, report.to),
      );
    } on Object {
      return false;
    }
  }

  pw.Widget _header(DoctorReport report, AppColorTokens colors) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          AppStrings.reportTitle.tr,
          style: pw.TextStyle(
            fontSize: _titleSize,
            fontWeight: pw.FontWeight.bold,
            color: _pdf(colors.active),
          ),
        ),
        pw.SizedBox(height: _gap),
        pw.Text(
          '${AppStrings.reportPatientLabel.tr}: ${report.profileName}',
          style: pw.TextStyle(
            fontSize: _headingSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          AppStrings.reportRangeValue.trParams(<String, String>{
            'from': DateFormatter.dayMonthYear(report.from),
            'to': DateFormatter.dayMonthYear(report.to),
          }),
          style: pw.TextStyle(
            fontSize: _bodySize,
            color: _pdf(colors.textSecondary),
          ),
        ),
        pw.Text(
          AppStrings.reportGeneratedOn.trParams(<String, String>{
            'date': DateFormatter.dayMonthYear(DateTime.now()),
          }),
          style: pw.TextStyle(
            fontSize: _smallSize,
            color: _pdf(colors.textSecondary),
          ),
        ),
      ],
    );
  }

  pw.Widget _overview(DoctorReport report, AppColorTokens colors) {
    final double rate = report.rate ?? 0;
    return pw.Container(
      padding: const pw.EdgeInsets.all(_padding),
      decoration: pw.BoxDecoration(
        color: _pdf(colors.activeTint),
        borderRadius: pw.BorderRadius.circular(_radius),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(
                      AppStrings.reportOverviewTitle.tr,
                      style: pw.TextStyle(
                        fontSize: _headingSize,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      AppStrings.reportOverviewSummary
                          .trParams(<String, String>{
                            'taken': DoseFormatter.quantity(
                              report.takenTotal.toDouble(),
                            ),
                            'total': DoseFormatter.quantity(
                              report.prescribed.toDouble(),
                            ),
                          }),
                      style: const pw.TextStyle(fontSize: _bodySize),
                    ),
                  ],
                ),
              ),
              pw.Text(
                DoseFormatter.percent(rate),
                style: pw.TextStyle(
                  fontSize: _percentSize,
                  fontWeight: pw.FontWeight.bold,
                  color: _pdf(_rateColor(rate, colors)),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: _gap),
          _bar(rate, colors),
          pw.SizedBox(height: _gap),
          pw.Row(
            children: <pw.Widget>[
              _stat(
                count: report.notTaken,
                label: AppStrings.reportStatMissed.tr,
                background: colors.dangerTint,
                foreground: colors.danger,
              ),
              pw.SizedBox(width: _gap),
              _stat(
                count: report.takenLate,
                label: AppStrings.reportStatLate.tr,
                background: colors.warningTint,
                foreground: colors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _bar(double rate, AppColorTokens colors) {
    final int filled = (rate * _percentScale).round().clamp(0, _percentScale);
    final int rest = _percentScale - filled;
    return pw.ClipRRect(
      horizontalRadius: _barHeight,
      verticalRadius: _barHeight,
      child: pw.Row(
        children: <pw.Widget>[
          if (filled > 0)
            pw.Expanded(
              flex: filled,
              child: pw.Container(
                height: _barHeight,
                color: _pdf(_rateColor(rate, colors)),
              ),
            ),
          if (rest > 0)
            pw.Expanded(
              flex: rest,
              child: pw.Container(
                height: _barHeight,
                color: _pdf(colors.progressTrack),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _stat({
    required int count,
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(_padding),
        decoration: pw.BoxDecoration(
          color: _pdf(background),
          borderRadius: pw.BorderRadius.circular(_radius),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Text(
              DoseFormatter.quantity(count.toDouble()),
              style: pw.TextStyle(
                fontSize: _numberSize,
                fontWeight: pw.FontWeight.bold,
                color: _pdf(foreground),
              ),
            ),
            pw.Text(label, style: const pw.TextStyle(fontSize: _smallSize)),
          ],
        ),
      ),
    );
  }

  pw.Widget _sectionTitle(String text, AppColorTokens colors) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: _headingSize,
        fontWeight: pw.FontWeight.bold,
        color: _pdf(colors.textPrimary),
      ),
    );
  }

  pw.Widget _lineCard(MedicationReportLine line, AppColorTokens colors) {
    final double rate = line.rate ?? 0;
    final MealInstruction? meal = line.mealInstruction;
    final Color rateColor = _rateColor(rate, colors);

    return pw.Container(
      padding: const pw.EdgeInsets.all(_padding),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _pdf(colors.borderHairline)),
        borderRadius: pw.BorderRadius.circular(_radius),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(
                      _medicationTitle(
                        line.medicationName,
                        line.doseAmount,
                        line.doseUnit,
                      ),
                      style: pw.TextStyle(
                        fontSize: _headingSize,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (meal != null)
                      pw.Text(
                        meal.labelKey.tr,
                        style: pw.TextStyle(
                          fontSize: _smallSize,
                          color: _pdf(colors.textSecondary),
                        ),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(width: _gap),
              pw.Text(
                AppStrings.reportAdherenceBadge.trParams(<String, String>{
                  'percent': DoseFormatter.percent(rate),
                }),
                style: pw.TextStyle(
                  fontSize: _bodySize,
                  fontWeight: pw.FontWeight.bold,
                  color: _pdf(rateColor),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: _gap),
          pw.Row(
            children: <pw.Widget>[
              _column(
                AppStrings.reportColumnPrescribed.tr,
                line.prescribed,
                colors.textPrimary,
              ),
              _column(
                AppStrings.reportColumnTaken.tr,
                line.takenTotal,
                colors.success,
              ),
              _column(
                AppStrings.reportColumnMissed.tr,
                line.notTaken,
                line.notTaken == 0 ? colors.textSecondary : colors.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _column(String label, int value, Color color) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(label, style: const pw.TextStyle(fontSize: _smallSize)),
          pw.Text(
            DoseFormatter.quantity(value.toDouble()),
            style: pw.TextStyle(
              fontSize: _numberSize,
              fontWeight: pw.FontWeight.bold,
              color: _pdf(color),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _missedList(DoctorReport report, AppColorTokens colors) {
    if (report.missed.isEmpty) {
      return pw.Text(
        AppStrings.reportMissedNone.tr,
        style: pw.TextStyle(
          fontSize: _bodySize,
          color: _pdf(colors.textSecondary),
        ),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: <pw.Widget>[
        for (final MissedDoseEntry entry in report.missed)
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: _gap),
            padding: const pw.EdgeInsets.all(_padding),
            decoration: pw.BoxDecoration(
              color: _pdf(
                entry.kind == MissedDoseKind.missed
                    ? colors.dangerTint
                    : colors.warningTint,
              ),
              borderRadius: pw.BorderRadius.circular(_radius),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(
                        _medicationTitle(
                          entry.medicationName,
                          entry.doseAmount,
                          entry.doseUnit,
                        ),
                        style: pw.TextStyle(
                          fontSize: _bodySize,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${DateFormatter.dayMonthYear(entry.scheduledAt)}  '
                        '${DateFormatter.time(entry.scheduledAt)}',
                        style: const pw.TextStyle(fontSize: _smallSize),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: _gap),
                pw.Text(
                  _kindLabel(entry),
                  style: const pw.TextStyle(fontSize: _smallSize),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _notes(String notes, AppColorTokens colors) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(_padding),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _pdf(colors.borderHairline)),
        borderRadius: pw.BorderRadius.circular(_radius),
      ),
      child: pw.Text(notes, style: const pw.TextStyle(fontSize: _bodySize)),
    );
  }

  String _kindLabel(MissedDoseEntry entry) {
    if (entry.kind == MissedDoseKind.missed) {
      return AppStrings.scheduleStateMissed.tr;
    }
    final String? reason = entry.reason;
    return reason == null
        ? AppStrings.scheduleStateSkipped.tr
        : AppStrings.reportSkippedReason.trParams(<String, String>{
            'reason': reason,
          });
  }

  String _medicationTitle(String name, double amount, DoseUnit unit) {
    return '$name ${DoseFormatter.quantity(amount)} ${unit.labelKey.tr}';
  }

  Color _rateColor(double rate, AppColorTokens colors) {
    if (rate >= _goodRate) {
      return colors.success;
    }
    return rate >= _fairRate ? colors.warning : colors.danger;
  }

  PdfColor _pdf(Color color) => PdfColor.fromInt(color.toARGB32());
}

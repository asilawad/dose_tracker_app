import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/reports/controllers/report_controller.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The medication filter card: "All medications" and one choice for each
/// medication the chosen profile had doses of in the range.
///
/// Choosing a medication limits the report to it; choosing "All
/// medications" removes the limit. State comes from [ReportController].
class ReportMedicationFilterCard extends GetView<ReportController> {
  const ReportMedicationFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            AppStrings.reportMedicationTitle.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Obx(() {
            final int? selectedId = controller.selectedMedicationId.value;

            return Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceSm,
              children: <Widget>[
                AppChoiceChip(
                  label: AppStrings.reportAllMedications.tr,
                  selected: selectedId == null,
                  showCheck: true,
                  onTap: () => controller.selectMedication(null),
                ),
                for (final MedicationReportLine line
                    in controller.medicationOptions)
                  AppChoiceChip(
                    label:
                        '${line.medicationName} '
                        '${DoseFormatter.quantity(line.doseAmount)} '
                        '${line.doseUnit.labelKey.tr}',
                    selected: selectedId == line.medicationId,
                    showCheck: true,
                    onTap: () => controller.selectMedication(line.medicationId),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

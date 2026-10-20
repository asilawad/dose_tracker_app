import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/dose_time_editor_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationTimesList extends GetView<MedicationFormController> {
  const MedicationTimesList({super.key});

  void _openEditor(int index) {
    AppBottomSheet.show<void>(
      title: AppStrings.medsEditTimeTitle.tr,
      child: DoseTimeEditorSheetContent(index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          AppStrings.medsScheduleTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSizes.spaceMd),
        Obx(
          () => Column(
            children: <Widget>[
              for (int index = 0; index < controller.form.times.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceSm),
                  child: _DoseTimeRow(
                    time: controller.form.times[index],
                    canRemove: controller.form.canDecreaseFrequency,
                    onEdit: () => _openEditor(index),
                    onRemove: () => controller.form.removeTime(index),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceXs),
        Obx(
          () => OutlinedActionButton(
            label: AppStrings.medsAddTime.tr,
            icon: Icons.add_rounded,
            onPressed: controller.form.canIncreaseFrequency
                ? controller.form.addTime
                : null,
          ),
        ),
      ],
    );
  }
}

class _DoseTimeRow extends StatelessWidget {
  const _DoseTimeRow({
    required this.time,
    required this.canRemove,
    required this.onEdit,
    required this.onRemove,
  });

  final DoseTimeInput time;
  final bool canRemove;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.appBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppSizes.spaceMd,
          top: AppSizes.spaceXs,
          bottom: AppSizes.spaceXs,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: AppSizes.avatarSm,
              height: AppSizes.avatarSm,
              decoration: BoxDecoration(
                color: colors.activeTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time_rounded,
                size: AppSizes.iconMd,
                color: colors.active,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DoseFormatter.minuteOfDay(time.minuteOfDay),
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    AppStrings.medsQuantitySummary.trParams(<String, String>{
                      'count': DoseFormatter.quantity(time.quantity),
                    }),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: AppStrings.a11yEditTime.tr,
              onPressed: onEdit,
              color: colors.active,
              icon: const Icon(Icons.edit_outlined),
            ),
            if (canRemove)
              IconButton(
                tooltip: AppStrings.a11yRemoveTime.tr,
                onPressed: onRemove,
                color: colors.danger,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

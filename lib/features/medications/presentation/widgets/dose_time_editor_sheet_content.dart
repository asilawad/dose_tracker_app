import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The form inside the "edit dose time" bottom sheet: the time of day and
/// the amount taken at that time.
///
/// It edits the time at [index] of the controller's list and closes on a
/// successful save. A time already used by another dose is refused with an
/// error message. The controller comes from `AddMedicationBinding`.
class DoseTimeEditorSheetContent extends StatefulWidget {
  const DoseTimeEditorSheetContent({required this.index, super.key});

  final int index;

  @override
  State<DoseTimeEditorSheetContent> createState() =>
      _DoseTimeEditorSheetContentState();
}

class _DoseTimeEditorSheetContentState
    extends State<DoseTimeEditorSheetContent> {
  final AddMedicationController _controller =
      Get.find<AddMedicationController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  late int _minuteOfDay;

  @override
  void initState() {
    super.initState();
    final DoseTimeInput current = _controller.times[widget.index];
    _minuteOfDay = current.minuteOfDay;
    _quantityController = TextEditingController(
      text: DoseFormatter.quantity(current.quantity),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _minuteOfDay ~/ Duration.minutesPerHour,
        minute: _minuteOfDay % Duration.minutesPerHour,
      ),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _minuteOfDay = picked.hour * Duration.minutesPerHour + picked.minute;
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final double? quantity = Validators.parsePositiveNumber(
      _quantityController.text,
    );
    if (quantity == null) {
      return;
    }
    final bool saved = _controller.updateTime(
      index: widget.index,
      minuteOfDay: _minuteOfDay,
      quantity: quantity,
    );
    if (saved) {
      Get.back<void>();
    } else {
      AppSnackbar.error(AppStrings.medsErrorInvalidSchedule.tr);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TimeButton(
            label: DoseFormatter.minuteOfDay(_minuteOfDay),
            onTap: _pickTime,
          ),
          const SizedBox(height: AppSizes.spaceLg),
          AppTextField(
            label: AppStrings.medsQuantityLabel.tr,
            controller: _quantityController,
            prefixIcon: Icons.medication_liquid_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: Validators.positiveNumber,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSizes.space2xl),
          GradientButton(label: AppStrings.actionSave.tr, onPressed: _save),
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusInput);

    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.appBackground,
            borderRadius: radius,
            border: Border.all(
              color: colors.borderHairline,
              width: AppSizes.borderHairline,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: SizedBox(
                height: AppSizes.inputHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceLg,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time_rounded,
                        size: AppSizes.iconLg,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceMd),
                      Text(label, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

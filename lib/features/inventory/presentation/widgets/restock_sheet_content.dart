import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The form inside the "refill stock" bottom sheet: the count on hand after
/// refilling, and a Save button.
///
/// [onSave] gets the entered count and returns true when it was saved. The
/// sheet then closes and shows a success message; on failure it stays open
/// (the error message comes from the caller). The Save button shows a
/// spinner while saving.
class RestockSheetContent extends StatefulWidget {
  const RestockSheetContent({required this.onSave, super.key});

  final Future<bool> Function(int newStock) onSave;

  @override
  State<RestockSheetContent> createState() => _RestockSheetContentState();
}

class _RestockSheetContentState extends State<RestockSheetContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stockController = TextEditingController();
  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final int? stock = Validators.parsePositiveInt(_stockController.text);
    if (stock == null) {
      return;
    }
    setState(() => _isSaving = true);
    final bool saved = await widget.onSave(stock);
    if (!mounted) {
      return;
    }
    if (saved) {
      Get.back<void>();
      AppSnackbar.success(AppStrings.inventoryRestocked.tr);
      return;
    }
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTextField(
            label: AppStrings.inventoryRestockLabel.tr,
            controller: _stockController,
            prefixIcon: Icons.numbers_rounded,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: Validators.positiveInteger,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSizes.space2xl),
          GradientButton(
            label: AppStrings.actionSave.tr,
            isLoading: _isSaving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Labeled text field used by every form.
///
/// Set [isPassword] for the show/hide toggle. [label] and [hint] must already
/// be translated. Validation messages come from `Validators`, passed through
/// [validator]. Borders follow the theme tokens: hairline normal, active
/// color when focused, danger color on error.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.onSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: textTheme.labelMedium?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSizes.spaceSm),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          obscureText: _obscured,
          style: textTheme.bodyLarge,
          cursorColor: colors.active,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: textTheme.bodyMedium,
            errorStyle: textTheme.bodyMedium?.copyWith(color: colors.danger),
            filled: true,
            fillColor: colors.appBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceLg,
              vertical: AppSizes.spaceMd,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, color: colors.textSecondary),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscured
                        ? AppStrings.a11yShowPassword.tr
                        : AppStrings.a11yHidePassword.tr,
                    onPressed: _toggleObscured,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colors.textSecondary,
                    ),
                  )
                : null,
            enabledBorder: _border(
              colors.borderHairline,
              AppSizes.borderHairline,
            ),
            focusedBorder: _border(colors.active, AppSizes.borderEmphasis),
            errorBorder: _border(colors.danger, AppSizes.borderHairline),
            focusedErrorBorder: _border(colors.danger, AppSizes.borderEmphasis),
          ),
        ),
      ],
    );
  }
}

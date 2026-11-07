import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Labeled text field used by every form.
///
/// Set [isPassword] for the show/hide toggle. [label] and [hint] must already
/// be translated. Validation messages come from `Validators`, passed through
/// [validator]. The field is a soft fill at rest and turns white with an
/// active border when focused; errors use the danger color.
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
    this.onChanged,
    this.onSubmitted,
    this.suffixText,
    this.minLines,
    this.maxLines = 1,
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
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Unit shown at the end of the field, for example "pills".
  final String? suffixText;

  /// Lines the field shows at least, and the most it grows to. The default
  /// is a single line; a password field is always a single line.
  final int? minLines;
  final int? maxLines;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  late bool _obscured = widget.isPassword;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

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
        Text(widget.label, style: textTheme.titleSmall),
        const SizedBox(height: AppSizes.spaceSm),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          minLines: widget.isPassword ? 1 : widget.minLines,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          obscureText: _obscured,
          style: textTheme.bodyLarge?.copyWith(fontSize: AppSizes.fontBodyBold),
          cursorColor: colors.active,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: textTheme.bodyLarge?.copyWith(
              fontSize: AppSizes.fontBodyBold,
              color: colors.textTertiary,
            ),
            errorStyle: textTheme.bodySmall?.copyWith(color: colors.danger),
            suffixText: widget.suffixText,
            suffixStyle: textTheme.bodyMedium,
            filled: true,
            fillColor: _focusNode.hasFocus ? colors.surface : colors.fieldFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceLg,
              vertical: AppSizes.spaceLg,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, color: colors.textTertiary),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscured
                        ? AppStrings.a11yShowPassword.tr
                        : AppStrings.a11yHidePassword.tr,
                    onPressed: _toggleObscured,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: colors.textTertiary,
                    ),
                  )
                : null,
            enabledBorder: _border(colors.fieldFill, AppSizes.borderField),
            focusedBorder: _border(colors.active, AppSizes.borderField),
            errorBorder: _border(colors.danger, AppSizes.borderField),
            focusedErrorBorder: _border(colors.danger, AppSizes.borderField),
          ),
        ),
      ],
    );
  }
}

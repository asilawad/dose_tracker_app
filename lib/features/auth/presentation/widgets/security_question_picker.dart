import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Labeled dropdown for choosing the security question at Sign Up.
///
/// The question texts are translated from each question's key, so the list
/// follows the app language. It looks like `AppTextField` (same radius,
/// fill and borders). The selection is kept by the dropdown itself;
/// [initialQuestion] only sets the first choice and [onChanged] reports
/// every change.
class SecurityQuestionPicker extends StatelessWidget {
  const SecurityQuestionPicker({
    required this.initialQuestion,
    required this.onChanged,
    super.key,
  });

  final SecurityQuestion initialQuestion;
  final ValueChanged<SecurityQuestion> onChanged;

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
          AppStrings.authSecurityQuestionLabel.tr,
          style: textTheme.labelMedium?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSizes.spaceSm),
        DropdownButtonFormField<SecurityQuestion>(
          initialValue: initialQuestion,
          isExpanded: true,
          style: textTheme.bodyLarge,
          dropdownColor: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textSecondary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.appBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceLg,
              vertical: AppSizes.spaceMd,
            ),
            enabledBorder: _border(
              colors.borderHairline,
              AppSizes.borderHairline,
            ),
            focusedBorder: _border(colors.active, AppSizes.borderEmphasis),
          ),
          items: <DropdownMenuItem<SecurityQuestion>>[
            for (final SecurityQuestion question in SecurityQuestion.values)
              DropdownMenuItem<SecurityQuestion>(
                value: question,
                child: Text(
                  question.key.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (SecurityQuestion? question) {
            if (question != null) {
              onChanged(question);
            }
          },
        ),
      ],
    );
  }
}

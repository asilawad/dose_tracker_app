import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum _StepState { done, current, upcoming }

/// The two-step progress bar of the Forgot Password flow: "1 Verify account"
/// and "2 New password", joined by a line.
///
/// [currentStep] is one-based. Finished and current steps use the logo
/// gradient (a finished one shows a check mark), upcoming steps are grey.
/// The row mirrors automatically in RTL, and screen readers hear "Step 1 of
/// 2" instead of the visual pieces.
class ForgotPasswordStepIndicator extends StatelessWidget {
  const ForgotPasswordStepIndicator({required this.currentStep, super.key});

  final int currentStep;

  static const List<String> _labelKeys = <String>[
    AppStrings.forgotPasswordStepVerify,
    AppStrings.forgotPasswordStepNewPassword,
  ];

  static _StepState _stateOf(int number, int current) {
    if (number < current) {
      return _StepState.done;
    }
    return number == current ? _StepState.current : _StepState.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.forgotPasswordStepIndicator.trParams(<String, String>{
        'current': currentStep.toString(),
        'total': _labelKeys.length.toString(),
      }),
      child: ExcludeSemantics(
        child: Row(
          children: <Widget>[
            for (int index = 0; index < _labelKeys.length; index++) ...<Widget>[
              if (index > 0)
                Expanded(child: _StepConnector(isReached: currentStep > index)),
              Flexible(
                child: _StepPill(
                  number: index + 1,
                  label: _labelKeys[index].tr,
                  state: _stateOf(index + 1, currentStep),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({
    required this.number,
    required this.label,
    required this.state,
  });

  final int number;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isUpcoming = state == _StepState.upcoming;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: AppSizes.iconLg,
          height: AppSizes.iconLg,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isUpcoming ? null : colors.actionGradient,
            color: isUpcoming ? colors.progressTrack : null,
            shape: BoxShape.circle,
          ),
          child: state == _StepState.done
              ? Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconSm,
                  color: colors.onActive,
                )
              : Text(
                  number.toString(),
                  style: textTheme.labelMedium?.copyWith(
                    color: isUpcoming ? colors.textSecondary : colors.onActive,
                  ),
                ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              color: isUpcoming ? colors.textSecondary : colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.isReached});

  final bool isReached;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceSm),
      child: SizedBox(
        height: AppSizes.borderEmphasis,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isReached ? colors.actionGradient : null,
            color: isReached ? null : colors.progressTrack,
          ),
        ),
      ),
    );
  }
}

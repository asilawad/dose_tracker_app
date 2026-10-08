import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Primary action button: pill shape filled with the logo gradient.
///
/// States: normal, pressed (ink ripple), disabled (`onPressed` is null) and
/// loading (spinner replaces the label and taps are ignored). [label] must
/// already be translated. The shadow sits on an outer [DecoratedBox], not
/// inside the ink layer, so it is never clipped.
class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional trailing icon. Directional icons mirror automatically in RTL.
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final bool enabled = onPressed != null && !isLoading;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusButton);
    final Color contentColor = enabled || isLoading
        ? colors.onActive
        : colors.textSecondary;

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled || isLoading ? colors.actionGradient : null,
          color: enabled || isLoading ? null : colors.progressTrack,
          borderRadius: radius,
          boxShadow: enabled
              ? <BoxShadow>[
                  BoxShadow(
                    color: colors.shadowActive,
                    blurRadius: AppSizes.shadowBlurActive,
                    offset: const Offset(0, AppSizes.shadowOffsetYActive),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onPressed : null,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: AppSizes.iconMd,
                      height: AppSizes.iconMd,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.borderEmphasis,
                        color: contentColor,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: contentColor),
                        ),
                        if (icon != null) ...<Widget>[
                          const SizedBox(width: AppSizes.spaceSm),
                          Icon(
                            icon,
                            size: AppSizes.iconMd,
                            color: contentColor,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

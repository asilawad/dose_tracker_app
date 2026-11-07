import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Extended floating button with the brand gradient (design `.fab`).
/// [label] must already be translated.
class GradientFab extends StatelessWidget {
  const GradientFab({
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusButton);

    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: colors.actionGradient,
            borderRadius: radius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.shadowActive,
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onPressed,
              child: SizedBox(
                height: AppSizes.buttonHeight,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 22, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(icon, color: colors.onActive),
                      const SizedBox(width: AppSizes.spaceSm),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colors.onActive, fontSize: 15),
                      ),
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

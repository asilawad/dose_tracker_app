import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Section title row from the redesign (`.section-h`): a title at the start
/// and, at the end, an optional caption or a small text action
/// ([actionLabel] with [onAction]). Text must already be translated.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.caption,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? caption;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(2, 28, 2, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Expanded(child: Text(title, style: textTheme.headlineSmall)),
          if (caption != null)
            Text(
              caption!,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          if (actionLabel != null && onAction != null)
            Semantics(
              button: true,
              child: InkWell(
                onTap: onAction,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceXs,
                    vertical: AppSizes.spaceXs,
                  ),
                  child: Text(
                    actionLabel!,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.activeDeep,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

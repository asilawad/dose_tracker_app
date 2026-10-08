import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

/// Centered placeholder for screens with nothing to show yet, for example a
/// new account with no family profiles.
///
/// [title] and [message] must already be translated. Provide both
/// [actionLabel] and [onAction] to show a call-to-action button; leave them
/// out for a passive empty state.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool hasAction = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.space2xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppSizes.avatarXl,
              height: AppSizes.avatarXl,
              decoration: BoxDecoration(
                color: colors.activeTint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSizes.iconXl, color: colors.active),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            if (hasAction) ...<Widget>[
              const SizedBox(height: AppSizes.space2xl),
              GradientButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

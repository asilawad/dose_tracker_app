import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Centered spinner for screens that are still loading.
///
/// Pass an already-translated [message] to show text under the spinner, or
/// leave it out for the spinner alone.
class LoadingState extends StatelessWidget {
  const LoadingState({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: AppSizes.iconXl,
            height: AppSizes.iconXl,
            child: CircularProgressIndicator(
              strokeWidth: AppSizes.borderEmphasis,
              color: colors.active,
              backgroundColor: colors.progressTrack,
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: AppSizes.spaceLg),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

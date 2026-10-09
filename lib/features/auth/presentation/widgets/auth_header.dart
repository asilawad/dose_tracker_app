import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Top of the Log In and Sign Up screens: logo, app name, a large [title]
/// and a short [subtitle], all centered.
///
/// [title] and [subtitle] must already be translated. The logo is
/// decorative here because the app name right under it says the same thing.
class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExcludeSemantics(child: LogoImage(size: AppSizes.logoAuth)),
        const SizedBox(height: AppSizes.spaceSm),
        Text(AppStrings.appName.tr, style: textTheme.headlineSmall),
        const SizedBox(height: AppSizes.spaceLg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.displayMedium,
        ),
        const SizedBox(height: AppSizes.spaceSm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

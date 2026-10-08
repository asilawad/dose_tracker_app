import 'package:dose_tracker/core/constants/app_assets.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// The only widget that displays the app logo.
///
/// Every screen and header uses this, so the asset path stays in
/// `AppAssets.logo` and the logo can be replaced in one place. The caller
/// passes a size constant, for example `AppSizes.logoHeader`.
class LogoImage extends StatelessWidget {
  const LogoImage({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      width: size,
      height: size,
      semanticsLabel: AppStrings.a11yLogo.tr,
    );
  }
}

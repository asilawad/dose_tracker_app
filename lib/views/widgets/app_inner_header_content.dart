import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/views/widgets/app_header_surface.dart';
import 'package:dose_tracker/views/widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// What `AppInnerHeader` paints: circular back button, centered title and an
/// optional [trailing] action. The side slots match, so the title stays
/// centered.
class AppInnerHeaderContent extends StatelessWidget {
  const AppInnerHeaderContent({
    required this.title,
    required this.scrolled,
    this.trailing,
    super.key,
  });

  final String title;
  final bool scrolled;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppHeaderSurface(
      borderOpacity: scrolled ? 1 : 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.contentMaxWidth),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.innerHeaderPadding,
              right: AppSizes.innerHeaderPadding,
              bottom: AppSizes.headerBottomCollapsed,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                spacing: AppSizes.headerRowGap,
                children: <Widget>[
                  AppIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: () => Get.back<void>(),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: AppSizes.fontInnerHeader),
                    ),
                  ),
                  trailing ?? const SizedBox(width: AppSizes.iconButtonSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

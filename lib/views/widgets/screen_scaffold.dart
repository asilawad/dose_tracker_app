import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Base layout for every screen: themed background, safe area, horizontal
/// padding, and content capped at `AppSizes.contentMaxWidth` and centered on
/// wide screens (Windows, tablets) so the phone design is never stretched.
///
/// Forms should put their fields in a scroll view so they stay usable when
/// the keyboard is open. Set [padding] to `EdgeInsets.zero` for full-bleed
/// content.
class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSizes.screenPaddingHorizontal,
    ),
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.contentMaxWidth,
            ),
            child: Padding(padding: padding, child: body),
          ),
        ),
      ),
    );
  }
}

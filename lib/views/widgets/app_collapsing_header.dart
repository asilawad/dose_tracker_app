import 'package:dose_tracker/views/widgets/app_collapsing_header_delegate.dart';
import 'package:flutter/material.dart';

/// Large title for tab screens, as the first sliver of a `CustomScrollView`.
///
/// The title shrinks as content scrolls under its blurred sticky background.
/// All text must already be translated. Keep the view full-bleed at the top
/// so the blur reaches behind the status bar.
class AppCollapsingHeader extends StatelessWidget {
  const AppCollapsingHeader({
    required this.title,
    this.eyebrowLabel,
    this.eyebrowIcon,
    this.trailing,
    super.key,
  });

  final String title;
  final String? eyebrowLabel;
  final IconData? eyebrowIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppCollapsingHeaderDelegate(
        title: title,
        topInset: MediaQuery.paddingOf(context).top,
        eyebrowLabel: eyebrowLabel,
        eyebrowIcon: eyebrowIcon,
        trailing: trailing,
      ),
    );
  }
}

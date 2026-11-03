import 'package:dose_tracker/views/widgets/app_inner_header_delegate.dart';
import 'package:flutter/material.dart';

/// Sticky blurred app bar for inner screens, as the first sliver of a
/// `CustomScrollView`. [title] must already be translated.
class AppInnerHeader extends StatelessWidget {
  const AppInnerHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppInnerHeaderDelegate(
        title: title,
        topInset: MediaQuery.paddingOf(context).top,
        trailing: trailing,
      ),
    );
  }
}

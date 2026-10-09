import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:flutter/material.dart';

/// The line at the bottom of auth screens that switches to another screen,
/// for example "Don't have an account? **Sign Up**".
///
/// [prompt] and [linkLabel] must already be translated. The line wraps to a
/// second row instead of overflowing with long text (Arabic) or large text
/// sizes.
class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    required this.prompt,
    required this.linkLabel,
    required this.onPressed,
    super.key,
  });

  final String prompt;
  final String linkLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(prompt, style: Theme.of(context).textTheme.bodyMedium),
        AppTextLink(label: linkLabel, onPressed: onPressed),
      ],
    );
  }
}

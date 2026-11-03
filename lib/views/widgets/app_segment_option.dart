import 'package:flutter/foundation.dart';

/// One choice of an `AppSegmentedControl`. [label] must already be translated.
@immutable
class AppSegmentOption<T> {
  const AppSegmentOption({required this.value, required this.label});

  final T value;
  final String label;
}

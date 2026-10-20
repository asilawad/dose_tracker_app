import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('undo snackbar stays visible long enough to react', () {
    expect(
      AppDurations.undoSnackbarVisible,
      greaterThanOrEqualTo(const Duration(seconds: 6)),
    );
    expect(
      AppDurations.undoSnackbarVisible,
      greaterThan(AppDurations.snackbarVisible),
    );
  });

  test('regular snackbar visibility remains three seconds', () {
    expect(AppDurations.snackbarVisible, const Duration(seconds: 3));
  });
}

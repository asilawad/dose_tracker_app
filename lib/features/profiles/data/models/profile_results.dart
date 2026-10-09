import 'package:dose_tracker/features/profiles/data/models/profile.dart';

/// Typed outcomes of the profile operations. The repository returns these
/// instead of throwing, so a screen handles every case with an exhaustive
/// `switch` and the compiler flags any case that is added later and not
/// handled.

sealed class AddProfileResult {
  const AddProfileResult();
}

final class AddProfileSuccess extends AddProfileResult {
  const AddProfileSuccess(this.profile);

  final Profile profile;
}

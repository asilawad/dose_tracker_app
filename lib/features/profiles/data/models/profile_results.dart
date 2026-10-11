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

sealed class UpdateProfileResult {
  const UpdateProfileResult();
}

final class UpdateProfileSuccess extends UpdateProfileResult {
  const UpdateProfileSuccess(this.profile);

  final Profile profile;
}

/// The profile is not in the logged-in account, or was already deleted.
final class UpdateProfileNotFound extends UpdateProfileResult {
  const UpdateProfileNotFound();
}

sealed class DeleteProfileResult {
  const DeleteProfileResult();
}

final class DeleteProfileSuccess extends DeleteProfileResult {
  const DeleteProfileSuccess();
}

/// The profile is not in the logged-in account, or was already deleted.
final class DeleteProfileNotFound extends DeleteProfileResult {
  const DeleteProfileNotFound();
}

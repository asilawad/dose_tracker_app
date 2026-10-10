import 'package:dose_tracker/features/medications/data/models/medication.dart';

/// Typed outcomes of adding a medication. The repository returns these
/// instead of throwing, so a screen handles every case with an exhaustive
/// `switch` and the compiler flags any case that is added later and not
/// handled.
sealed class AddMedicationResult {
  const AddMedicationResult();
}

final class AddMedicationSuccess extends AddMedicationResult {
  const AddMedicationSuccess(this.medication);

  final Medication medication;
}

/// The chosen profile does not exist in the logged-in account.
final class AddMedicationProfileNotFound extends AddMedicationResult {
  const AddMedicationProfileNotFound();
}

/// The schedule is empty, has a time outside 0 to 1439, has a quantity that
/// is not above zero, or has the same time twice.
final class AddMedicationInvalidSchedule extends AddMedicationResult {
  const AddMedicationInvalidSchedule();
}

/// Stock tracking is on but the current stock is missing or not above zero.
final class AddMedicationInvalidStock extends AddMedicationResult {
  const AddMedicationInvalidStock();
}

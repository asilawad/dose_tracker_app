/// Unit of the dose amount, as in the Add Medication chips (mg, IU, ml, pills).
///
/// Stored in the database by enum name, so never rename a value after the
/// app has saved data. Display text comes from translations, not from here.
enum DoseUnit { mg, iu, ml, pills }

/// Meal timing instruction for a medication. Optional: a medication with no
/// meal instruction stores null instead of a value.
///
/// Stored by enum name, so never rename a value after the app has saved data.
enum MealInstruction { beforeMeal, withMeal, afterMeal }

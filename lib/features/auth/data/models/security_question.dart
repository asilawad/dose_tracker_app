import 'package:dose_tracker/core/constants/app_strings.dart';

/// The fixed list of security questions offered at Sign Up. The account
/// stores the question's translation [key], so the question is shown in the
/// current app language, and the Forgot Password step reads it back with
/// [fromKey].
///
/// Never change an existing key after the app has saved accounts, or those
/// accounts would lose their question. To add a question, add a value here
/// and a translation in both language files.
enum SecurityQuestion {
  firstSchool(AppStrings.securityQuestionFirstSchool),
  birthCity(AppStrings.securityQuestionBirthCity),
  firstPet(AppStrings.securityQuestionFirstPet),
  favoriteTeacher(AppStrings.securityQuestionFavoriteTeacher),
  childhoodNickname(AppStrings.securityQuestionChildhoodNickname);

  const SecurityQuestion(this.key);

  /// Translation key, also the value saved in the database.
  final String key;

  /// The question saved under [key], or null when the key is unknown.
  static SecurityQuestion? fromKey(String key) {
    for (final SecurityQuestion question in SecurityQuestion.values) {
      if (question.key == key) {
        return question;
      }
    }
    return null;
  }
}

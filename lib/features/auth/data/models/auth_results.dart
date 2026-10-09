import 'package:dose_tracker/features/auth/data/models/account.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';

/// Typed outcomes of the auth operations. The repository returns these
/// instead of throwing, so a screen handles every case with an exhaustive
/// `switch` and the compiler flags any case that is forgotten. The types
/// carry no password or answer, only what a screen may show.

sealed class SignUpResult {
  const SignUpResult();
}

final class SignUpSuccess extends SignUpResult {
  const SignUpSuccess(this.account);

  final Account account;
}

/// Another local account already uses this email.
final class SignUpEmailTaken extends SignUpResult {
  const SignUpEmailTaken();
}

sealed class LogInResult {
  const LogInResult();
}

final class LogInSuccess extends LogInResult {
  const LogInSuccess(this.account);

  final Account account;
}

/// Unknown email or wrong password. One result for both, so the screen never
/// reveals which of the two was wrong.
final class LogInInvalidCredentials extends LogInResult {
  const LogInInvalidCredentials();
}

sealed class FindSecurityQuestionResult {
  const FindSecurityQuestionResult();
}

final class SecurityQuestionFound extends FindSecurityQuestionResult {
  const SecurityQuestionFound(this.question);

  final SecurityQuestion question;
}

/// No local account uses this email.
final class SecurityQuestionAccountNotFound extends FindSecurityQuestionResult {
  const SecurityQuestionAccountNotFound();
}

sealed class ResetPasswordResult {
  const ResetPasswordResult();
}

final class ResetPasswordSuccess extends ResetPasswordResult {
  const ResetPasswordSuccess();
}

/// The security answer did not match, or the account no longer exists.
final class ResetPasswordWrongAnswer extends ResetPasswordResult {
  const ResetPasswordWrongAnswer();
}

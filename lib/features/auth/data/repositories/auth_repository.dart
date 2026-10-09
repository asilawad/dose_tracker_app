import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/accounts_local_data_source.dart';
import 'package:dose_tracker/core/services/password_hasher.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/features/auth/data/models/account.dart';
import 'package:dose_tracker/features/auth/data/models/auth_results.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';

/// All auth rules in one place: sign up, log in, password reset and the
/// active session. Screens never touch the database, the hasher or the
/// session directly; they call this and handle the typed results.
///
/// Emails are saved trimmed and lowercase, and security answers are
/// compared trimmed and lowercase, so "Cairo " and "cairo" match. Passwords
/// and answers are hashed before they reach the database. Logging out only
/// clears the session pointer and never deletes data.
class AuthRepository {
  AuthRepository({
    required AccountsLocalDataSource accounts,
    required PasswordHasher hasher,
    required SessionService session,
  }) : _accounts = accounts,
       _hasher = hasher,
       _session = session;

  final AccountsLocalDataSource _accounts;
  final PasswordHasher _hasher;
  final SessionService _session;

  /// Creates the account and logs it in, so the app can go straight to Home.
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
    required SecurityQuestion question,
    required String answer,
  }) async {
    final String normalizedEmail = _normalizeEmail(email);
    if (await _accounts.findByEmail(normalizedEmail) != null) {
      return const SignUpEmailTaken();
    }

    final String trimmedName = name.trim();
    final HashedSecret passwordSecret = await _hasher.hash(password);
    final HashedSecret answerSecret = await _hasher.hash(
      _normalizeAnswer(answer),
    );
    final int id = await _accounts.insert(
      name: trimmedName,
      email: normalizedEmail,
      passwordHash: passwordSecret.hash,
      passwordSalt: passwordSecret.salt,
      securityQuestionKey: question.key,
      securityAnswerHash: answerSecret.hash,
      securityAnswerSalt: answerSecret.salt,
    );
    await _session.signIn(id);
    return SignUpSuccess(
      Account(id: id, name: trimmedName, email: normalizedEmail),
    );
  }

  Future<LogInResult> logIn({
    required String email,
    required String password,
  }) async {
    final AccountRow? row = await _accounts.findByEmail(_normalizeEmail(email));
    if (row == null) {
      return const LogInInvalidCredentials();
    }
    final bool isValid = await _hasher.verify(
      secret: password,
      hash: row.passwordHash,
      salt: row.passwordSalt,
    );
    if (!isValid) {
      return const LogInInvalidCredentials();
    }
    await _session.signIn(row.id);
    return LogInSuccess(_toAccount(row));
  }

  /// Forgot Password, first step: the question saved for this email.
  Future<FindSecurityQuestionResult> findSecurityQuestion(String email) async {
    final AccountRow? row = await _accounts.findByEmail(_normalizeEmail(email));
    if (row == null) {
      return const SecurityQuestionAccountNotFound();
    }
    final SecurityQuestion? question = SecurityQuestion.fromKey(
      row.securityQuestionKey,
    );
    if (question == null) {
      return const SecurityQuestionAccountNotFound();
    }
    return SecurityQuestionFound(question);
  }

  /// Forgot Password, second step: checks the answer, then saves the new
  /// password. It does not log in; the user returns to the Log In screen.
  Future<ResetPasswordResult> resetPassword({
    required String email,
    required String answer,
    required String newPassword,
  }) async {
    final AccountRow? row = await _accounts.findByEmail(_normalizeEmail(email));
    if (row == null) {
      return const ResetPasswordWrongAnswer();
    }
    final bool answerMatches = await _hasher.verify(
      secret: _normalizeAnswer(answer),
      hash: row.securityAnswerHash,
      salt: row.securityAnswerSalt,
    );
    if (!answerMatches) {
      return const ResetPasswordWrongAnswer();
    }
    final HashedSecret passwordSecret = await _hasher.hash(newPassword);
    await _accounts.updatePassword(
      accountId: row.id,
      passwordHash: passwordSecret.hash,
      passwordSalt: passwordSecret.salt,
    );
    return const ResetPasswordSuccess();
  }

  /// The account that was logged in when the app last closed, or null. If
  /// the saved account no longer exists, the stale session is cleared.
  Future<Account?> restoreSession() async {
    final int? id = _session.activeAccountId;
    if (id == null) {
      return null;
    }
    final AccountRow? row = await _accounts.findById(id);
    if (row == null) {
      await _session.signOut();
      return null;
    }
    return _toAccount(row);
  }

  Future<void> signOut() => _session.signOut();

  Account _toAccount(AccountRow row) {
    return Account(id: row.id, name: row.name, email: row.email);
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static String _normalizeAnswer(String answer) => answer.trim().toLowerCase();
}

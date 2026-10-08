import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

/// A hashed secret ready to store. [hash] holds the iteration count and the
/// digest, [salt] is the random per-secret salt (both are plain text).
typedef HashedSecret = ({String hash, String salt});

/// Hashes and verifies passwords and security answers with PBKDF2 (HMAC
/// SHA-256) and a random salt per secret. Plain text is never stored.
///
/// The iteration count is saved inside each hash, so it can be raised later
/// without breaking existing accounts. These parameters are tied to saved
/// hashes, which is why they live here and not in a shared constants file.
/// Callers must normalize security answers (trim and lowercase) before
/// hashing, so "Cairo " and "cairo" match.
class PasswordHasher {
  const PasswordHasher();

  static const int _iterations = 120000;
  static const int _hashBits = 256;
  static const int _saltBytes = 16;
  static const int _byteRange = 256;
  static const String _separator = ':';

  Future<HashedSecret> hash(String secret) async {
    final List<int> salt = _randomBytes(_saltBytes);
    final List<int> digest = await _derive(secret, salt, _iterations);
    return (
      hash: '$_iterations$_separator${base64Encode(digest)}',
      salt: base64Encode(salt),
    );
  }

  Future<bool> verify({
    required String secret,
    required String hash,
    required String salt,
  }) async {
    final List<String> parts = hash.split(_separator);
    if (parts.length != 2) {
      return false;
    }
    final int? iterations = int.tryParse(parts.first);
    final List<int>? expected = _tryDecode(parts.last);
    final List<int>? saltBytes = _tryDecode(salt);
    if (iterations == null ||
        iterations <= 0 ||
        expected == null ||
        saltBytes == null) {
      return false;
    }
    final List<int> actual = await _derive(secret, saltBytes, iterations);
    return _constantTimeEquals(actual, expected);
  }

  Future<List<int>> _derive(
    String secret,
    List<int> salt,
    int iterations,
  ) async {
    final Pbkdf2 algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: _hashBits,
    );
    final SecretKey key = await algorithm.deriveKeyFromPassword(
      password: secret,
      nonce: salt,
    );
    return key.extractBytes();
  }

  List<int> _randomBytes(int length) {
    final Random random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(_byteRange));
  }

  List<int>? _tryDecode(String value) {
    try {
      return base64Decode(value);
    } on FormatException {
      return null;
    }
  }

  /// Compares without stopping at the first difference, so timing reveals
  /// nothing about how much of a guess was correct.
  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    int difference = 0;
    for (int i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}

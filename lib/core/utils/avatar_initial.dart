abstract final class AvatarInitial {
  static String of(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }
}

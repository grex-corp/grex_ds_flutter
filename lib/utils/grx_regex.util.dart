abstract class GrxRegexUtils {
  static const singleNameAvatarRgx = r'[A-Za-z0-9]';
  static const fullNameAvatarRgx = r'\b[A-Za-z0-9]';
  static const emailRgx =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  static const numericOnlyRgx = r'[^0-9]';

  /// Up to two uppercase initials for avatar placeholders.
  ///
  /// Uses the first letter of each word when there are two or more words;
  /// otherwise up to two alphanumeric characters from a single name.
  static String initialsFromName(String? name) {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '';
    }

    final wordCount = trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;

    final initials = RegExp(
      wordCount >= 2 ? fullNameAvatarRgx : singleNameAvatarRgx,
    )
        .allMatches(trimmed)
        .map((match) => match.group(0))
        .whereType<String>()
        .join()
        .toUpperCase();

    if (initials.isEmpty) {
      return '';
    }

    return initials.length <= 2 ? initials : initials.substring(0, 2);
  }
}

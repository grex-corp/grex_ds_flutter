import 'dart:convert';

/// Utility class for text sanitization and normalization for search operations
class GrxTextSanitizer {
  /// Normalizes text for search by:
  /// - Converting to lowercase
  /// - Removing diacritics/accents
  /// - Removing extra whitespace
  /// - Removing special characters (keeping alphanumeric and basic punctuation)
  static String normalizeForSearch(String text) {
    if (text.isEmpty) return text;
    
    return removeDiacritics(text)
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[^\w\s\-\.]'), ' ') // Replace special chars with spaces
        .replaceAll(RegExp(r'\s+'), ' ') // Clean up spaces again
        .trim();
  }

  /// Removes diacritics/accents from text
  static String removeDiacritics(String text) {
    if (text.isEmpty) return text;
    
    const Map<String, String> diacriticsMap = {
      'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'Ā': 'A', 'ā': 'a', 'Ă': 'A', 'ă': 'a', 'Ą': 'A', 'ą': 'a',
      'Ç': 'C', 'ç': 'c', 'Ć': 'C', 'ć': 'c', 'Ĉ': 'C', 'ĉ': 'c',
      'Ċ': 'C', 'ċ': 'c', 'Č': 'C', 'č': 'c', 'Ď': 'D', 'ď': 'd',
      'Đ': 'D', 'đ': 'd', 'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'Ē': 'E', 'ē': 'e',
      'Ĕ': 'E', 'ĕ': 'e', 'Ė': 'E', 'ė': 'e', 'Ę': 'E', 'ę': 'e',
      'Ě': 'E', 'ě': 'e', 'Ĝ': 'G', 'ĝ': 'g', 'Ğ': 'G', 'ğ': 'g',
      'Ġ': 'G', 'ġ': 'g', 'Ģ': 'G', 'ģ': 'g', 'Ĥ': 'H', 'ĥ': 'h',
      'Ħ': 'H', 'ħ': 'h', 'Ì': 'I', 'Í': 'I', 'Î': 'I', 'Ï': 'I',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'Ĩ': 'I', 'ĩ': 'i',
      'Ī': 'I', 'ī': 'i', 'Ĭ': 'I', 'ĭ': 'i', 'Į': 'I', 'į': 'i',
      'İ': 'I', 'ı': 'i', 'Ĵ': 'J', 'ĵ': 'j', 'Ķ': 'K', 'ķ': 'k',
      'ĸ': 'k', 'Ĺ': 'L', 'ĺ': 'l', 'Ļ': 'L', 'ļ': 'l', 'Ľ': 'L',
      'ľ': 'l', 'Ŀ': 'L', 'ŀ': 'l', 'Ł': 'L', 'ł': 'l', 'Ñ': 'N',
      'ñ': 'n', 'Ń': 'N', 'ń': 'n', 'Ņ': 'N', 'ņ': 'n', 'Ň': 'N',
      'ň': 'n', 'ŉ': 'n', 'Ŋ': 'N', 'ŋ': 'n', 'Ò': 'O', 'Ó': 'O',
      'Ô': 'O', 'Õ': 'O', 'Ö': 'O', 'Ø': 'O', 'ò': 'o', 'ó': 'o',
      'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'Ō': 'O', 'ō': 'o',
      'Ŏ': 'O', 'ŏ': 'o', 'Ő': 'O', 'ő': 'o', 'Ŕ': 'R', 'ŕ': 'r',
      'Ŗ': 'R', 'ŗ': 'r', 'Ř': 'R', 'ř': 'r', 'Ś': 'S', 'ś': 's',
      'Ŝ': 'S', 'ŝ': 's', 'Ş': 'S', 'ş': 's', 'Š': 'S', 'š': 's',
      'Ţ': 'T', 'ţ': 't', 'Ť': 'T', 'ť': 't', 'Ŧ': 'T', 'ŧ': 't',
      'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U', 'ù': 'u', 'ú': 'u',
      'û': 'u', 'ü': 'u', 'Ũ': 'U', 'ũ': 'u', 'Ū': 'U', 'ū': 'u',
      'Ŭ': 'U', 'ŭ': 'u', 'Ů': 'U', 'ů': 'u', 'Ű': 'U', 'ű': 'u',
      'Ų': 'U', 'ų': 'u', 'Ŵ': 'W', 'ŵ': 'w', 'Ŷ': 'Y', 'ŷ': 'y',
      'Ÿ': 'Y', 'Ź': 'Z', 'ź': 'z', 'Ż': 'Z', 'ż': 'z', 'Ž': 'Z', 'ž': 'z',
    };
    
    String result = text;
    diacriticsMap.forEach((diacritic, replacement) {
      result = result.replaceAll(diacritic, replacement);
    });
    
    return result;
  }

  /// Advanced normalization that includes:
  /// - Diacritic removal
  /// - Case normalization
  /// - Whitespace normalization
  /// - Special character handling
  static String advancedNormalize(String text) {
    if (text.isEmpty) return text;
    
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '') // Remove special chars
        .replaceAll(RegExp(r'\s+'), ' ') // Clean up spaces again
        .trim();
  }

  /// Normalizes text using Unicode normalization (NFD + diacritic removal)
  static String unicodeNormalize(String text) {
    if (text.isEmpty) return text;
    
    // Convert to NFD (Normalized Decomposed Form) to separate base characters from diacritics
    final normalized = const Utf8Decoder().convert(
      const Utf8Encoder().convert(text).map((byte) => byte).toList(),
    );
    
    // Remove diacritics and normalize
    return removeDiacritics(normalized)
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Checks if search text matches target text using normalized comparison
  static bool matchesSearch(String searchText, String targetText) {
    if (searchText.isEmpty) return true;
    if (targetText.isEmpty) return false;
    
    final normalizedSearch = normalizeForSearch(searchText);
    final normalizedTarget = normalizeForSearch(targetText);
    
    return normalizedTarget.contains(normalizedSearch);
  }

  /// Checks if search text matches any of the provided target texts
  static bool matchesAnySearch(String searchText, List<String> targetTexts) {
    if (searchText.isEmpty) return true;
    if (targetTexts.isEmpty) return false;
    
    final normalizedSearch = normalizeForSearch(searchText);
    
    return targetTexts.any((target) => 
        normalizeForSearch(target).contains(normalizedSearch)
    );
  }

  /// Performs fuzzy search by checking if all words in search text are present in target
  static bool fuzzyMatches(String searchText, String targetText) {
    if (searchText.isEmpty) return true;
    if (targetText.isEmpty) return false;
    
    final normalizedSearch = normalizeForSearch(searchText);
    final normalizedTarget = normalizeForSearch(targetText);
    
    final searchWords = normalizedSearch.split(' ').where((word) => word.isNotEmpty).toList();
    if (searchWords.isEmpty) return true;
    
    // Check if all search words are present as complete words in the target
    return searchWords.every((word) => 
        RegExp(r'\b' + RegExp.escape(word) + r'\b').hasMatch(normalizedTarget)
    );
  }

  /// Performs fuzzy search on multiple target texts
  static bool fuzzyMatchesAny(String searchText, List<String> targetTexts) {
    if (searchText.isEmpty) return true;
    if (targetTexts.isEmpty) return false;
    
    return targetTexts.any((target) => fuzzyMatches(searchText, target));
  }

  /// Sanitizes text for display (removes potentially harmful characters)
  static String sanitizeForDisplay(String text) {
    if (text.isEmpty) return text;
    
    return text
        .replaceAll(RegExp(r'[<>]'), '') // Remove potential HTML tags
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '') // Remove control characters
        .trim();
  }

  /// Normalizes phone numbers for search (removes formatting)
  static String normalizePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;
    
    return phoneNumber
        .replaceAll(RegExp(r'[^\d+]'), '') // Keep only digits and +
        .replaceAll(RegExp(r'^\+'), '') // Remove leading +
        .trim();
  }

  /// Normalizes country codes for search
  static String normalizeCountryCode(String countryCode) {
    if (countryCode.isEmpty) return countryCode;
    
    return countryCode
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z]'), '') // Keep only letters
        .trim();
  }
}

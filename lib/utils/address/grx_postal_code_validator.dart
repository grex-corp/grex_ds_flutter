import 'package:grex_ds/models/address/grx_address_schema.model.dart';

/// Result of schema-driven postal code validation.
final class GrxPostalCodeValidationResult {
  final bool isValid;
  final String? errorMessage;

  const GrxPostalCodeValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  static const valid = GrxPostalCodeValidationResult(isValid: true);

  factory GrxPostalCodeValidationResult.invalid(String message) =>
      GrxPostalCodeValidationResult(isValid: false, errorMessage: message);
}

/// Centralized, schema-driven postal code validator.
final class GrxPostalCodeValidator {
  const GrxPostalCodeValidator();

  GrxPostalCodeValidationResult validate({
    required String input,
    required GrxPostalCodeRule rule,
    bool isRequired = false,
  }) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      if (isRequired) {
        return GrxPostalCodeValidationResult.invalid(rule.hint ?? '');
      }
      return GrxPostalCodeValidationResult.valid;
    }

    final patterns = rule.effectivePatterns;
    if (patterns.isEmpty) {
      return GrxPostalCodeValidationResult.valid;
    }

    final normalized = rule.stripNonDigits
        ? trimmed.replaceAll(RegExp('[^0-9]'), '')
        : trimmed;

    for (final pattern in patterns) {
      if (pattern.isEmpty) continue;
      final regex = RegExp(pattern);
      final match = regex.firstMatch(normalized);
      if (match != null &&
          match.start == 0 &&
          match.end == normalized.length) {
        return GrxPostalCodeValidationResult.valid;
      }
    }

    if (!rule.stripNonDigits && RegExp('[^0-9]').hasMatch(trimmed)) {
      final digitsOnly = trimmed.replaceAll(RegExp('[^0-9]'), '');
      if (digitsOnly.isNotEmpty) {
        for (final pattern in patterns) {
          if (pattern.isEmpty) continue;
          final regex = RegExp(pattern);
          final match = regex.firstMatch(digitsOnly);
          if (match != null &&
              match.start == 0 &&
              match.end == digitsOnly.length) {
            return GrxPostalCodeValidationResult.valid;
          }
        }
      }
    }

    return GrxPostalCodeValidationResult.invalid(rule.hint ?? '');
  }
}

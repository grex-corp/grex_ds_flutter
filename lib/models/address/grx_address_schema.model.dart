import 'grx_subdivision.model.dart';

/// Postal code validation rule from schema.
final class GrxPostalCodeRule {
  final String? regex;
  final List<String>? patterns;
  final String? hint;
  final bool stripNonDigits;
  final List<String>? examples;

  const GrxPostalCodeRule({
    this.regex,
    this.patterns,
    this.hint,
    this.stripNonDigits = false,
    this.examples,
  });

  List<String> get effectivePatterns {
    if (patterns != null && patterns!.isNotEmpty) return patterns!;
    if (regex != null && regex!.isNotEmpty) return [regex!];
    return [];
  }

  factory GrxPostalCodeRule.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const GrxPostalCodeRule();
    final regex = map['regex'] as String? ?? map['regex_pattern'] as String?;
    final hint = map['hint'] as String? ?? map['hint_text'] as String?;
    List<String>? patterns;
    final patternsRaw = map['patterns'] ??
        map['regex_patterns'] ??
        map['regexList'] ??
        map['regex_list'];
    if (patternsRaw is List) {
      patterns = patternsRaw
          .map((e) => e?.toString().trim())
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
      if (patterns.isEmpty) patterns = null;
    }
    final stripNonDigits =
        map['stripNonDigits'] == true || map['strip_non_digits'] == true;
    List<String>? examples;
    final examplesRaw = map['examples'];
    if (examplesRaw is List) {
      examples = examplesRaw
          .map((e) => e?.toString().trim())
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
      if (examples.isEmpty) examples = null;
    }
    return GrxPostalCodeRule(
      regex: regex,
      patterns: patterns,
      hint: hint,
      stripNonDigits: stripNonDigits,
      examples: examples,
    );
  }

  Map<String, dynamic> toMap() => {
    if (regex != null) 'regex': regex,
    if (patterns != null && patterns!.isNotEmpty) 'patterns': patterns,
    if (hint != null) 'hint': hint,
    if (stripNonDigits) 'stripNonDigits': stripNonDigits,
    if (examples != null && examples!.isNotEmpty) 'examples': examples,
  };
}

/// Postal code UI configuration from schema.
final class GrxPostalCodeUiModel {
  final String? inputType;
  final String? mask;
  final int? maxLength;
  final String? hint;
  final String? format;

  const GrxPostalCodeUiModel({
    this.inputType,
    this.mask,
    this.maxLength,
    this.hint,
    this.format,
  });

  factory GrxPostalCodeUiModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const GrxPostalCodeUiModel();

    String? inputType;
    final inputTypeValue = map['inputType'] ?? map['input_type'];
    if (inputTypeValue is String) {
      final normalized = inputTypeValue.toLowerCase().trim();
      if (normalized == 'numeric' ||
          normalized == 'alphanumeric' ||
          normalized == 'text') {
        inputType = normalized;
      }
    }

    String? mask;
    final maskValue = map['mask'];
    if (maskValue is String && maskValue.isNotEmpty) {
      mask = maskValue;
    }

    int? maxLength;
    final maxLengthValue = map['maxLength'] ?? map['max_length'];
    if (maxLengthValue != null) {
      if (maxLengthValue is int) {
        maxLength = maxLengthValue > 0 ? maxLengthValue : null;
      } else if (maxLengthValue is num) {
        maxLength = maxLengthValue.toInt() > 0 ? maxLengthValue.toInt() : null;
      }
    }

    String? hint;
    final hintValue = map['hint'];
    if (hintValue is String && hintValue.isNotEmpty) {
      hint = hintValue;
    }

    String? format;
    final formatValue = map['format'];
    if (formatValue is String && formatValue.isNotEmpty) {
      format = formatValue;
    }

    return GrxPostalCodeUiModel(
      inputType: inputType,
      mask: mask,
      maxLength: maxLength,
      hint: hint,
      format: format,
    );
  }

  Map<String, dynamic> toMap() => {
    if (inputType != null) 'inputType': inputType,
    if (mask != null) 'mask': mask,
    if (maxLength != null) 'maxLength': maxLength,
    if (hint != null) 'hint': hint,
    if (format != null) 'format': format,
  };
}

/// Address schema model matching backend contract.
final class GrxAddressSchemaModel {
  final String countryCode;
  final Map<String, String> labels;
  final List<String> order;
  final List<String> required;
  final GrxPostalCodeRule? postalCodeRule;
  final GrxPostalCodeUiModel? postalCodeUi;
  final List<String>? notes;
  final List<GrxSubdivisionModel>? subdivisions;

  const GrxAddressSchemaModel({
    required this.countryCode,
    required this.labels,
    required this.order,
    required this.required,
    this.postalCodeRule,
    this.postalCodeUi,
    this.notes,
    this.subdivisions,
  });

  factory GrxAddressSchemaModel.fromMap({required Map<String, dynamic> map}) {
    String normalizeFieldId(String fieldId) {
      switch (fieldId) {
        case 'postalCode':
          return 'postal_code';
        case 'administrativeArea':
          return 'administrative_area';
        case 'dependentLocality':
          return 'dependent_locality';
        case 'countryCode':
          return 'country_code';
        case 'line1':
        case 'line2':
        case 'locality':
        case 'country':
        case 'country_code':
        case 'postal_code':
        case 'administrative_area':
        case 'dependent_locality':
          return fieldId;
        default:
          return fieldId
              .replaceAllMapped(
                RegExp('([A-Z])'),
                (match) => '_${match.group(1)!.toLowerCase()}',
              )
              .toLowerCase();
      }
    }

    final labelsMap = map['labels'] as Map? ?? {};
    final labels = <String, String>{};
    final processedKeys = <String>{};

    labelsMap.forEach((key, value) {
      final keyStr = key.toString();
      final normalizedKey = normalizeFieldId(keyStr);
      final isCamelCase =
          keyStr != normalizedKey && RegExp('[A-Z]').hasMatch(keyStr);
      if (isCamelCase && !processedKeys.contains(normalizedKey)) {
        labels[normalizedKey] = value?.toString() ?? '';
        processedKeys.add(normalizedKey);
      }
    });

    labelsMap.forEach((key, value) {
      final keyStr = key.toString();
      final normalizedKey = normalizeFieldId(keyStr);
      if (!processedKeys.contains(normalizedKey)) {
        labels[normalizedKey] = value?.toString() ?? '';
        processedKeys.add(normalizedKey);
      }
    });

    final orderList = map['order'] as List? ?? [];
    final normalizedOrder = <String>[];
    final seenFields = <String>{};
    for (final item in orderList) {
      final fieldId = item?.toString() ?? '';
      if (fieldId.isEmpty) continue;

      final normalized = normalizeFieldId(fieldId);
      if (normalized != 'country_code' &&
          normalized != 'country' &&
          !seenFields.contains(normalized)) {
        normalizedOrder.add(normalized);
        seenFields.add(normalized);
      }
    }

    final requiredList = map['required'] as List? ?? [];
    final normalizedRequired = <String>[];
    final seenRequired = <String>{};
    for (final item in requiredList) {
      final fieldId = item?.toString() ?? '';
      if (fieldId.isEmpty) continue;

      final normalized = normalizeFieldId(fieldId);
      if (normalized != 'country_code' &&
          normalized != 'country' &&
          !seenRequired.contains(normalized)) {
        normalizedRequired.add(normalized);
        seenRequired.add(normalized);
      }
    }

    List<String>? notes;
    final notesValue = map['notes'];
    if (notesValue != null) {
      if (notesValue is List) {
        notes = notesValue.map((item) => item?.toString() ?? '').toList();
      } else if (notesValue is String) {
        notes = [notesValue];
      }
    }

    List<GrxSubdivisionModel>? subdivisions;
    final subdivisionsValue = map['subdivisions'];
    if (subdivisionsValue != null && subdivisionsValue is List) {
      subdivisions = <GrxSubdivisionModel>[];
      for (final item in subdivisionsValue) {
        if (item is Map) {
          try {
            subdivisions.add(
              GrxSubdivisionModel.fromMap(Map<String, dynamic>.from(item)),
            );
          } catch (_) {
            continue;
          }
        }
      }
      if (subdivisions.isEmpty) {
        subdivisions = null;
      }
    }

    GrxPostalCodeUiModel? postalCodeUi;
    final postalCodeUiValue = map['postalCodeUi'] ?? map['postal_code_ui'];
    if (postalCodeUiValue != null && postalCodeUiValue is Map<String, dynamic>) {
      try {
        postalCodeUi = GrxPostalCodeUiModel.fromMap(postalCodeUiValue);
      } catch (_) {
        postalCodeUi = null;
      }
    }

    final countryCodeValue = map['countryCode'] ?? map['country_code'];
    if (countryCodeValue is! String) {
      throw ArgumentError('Missing required field: countryCode');
    }

    final postalCodeRuleMap =
        map['postalCodeRule'] as Map<String, dynamic>? ??
        map['postal_code_rule'] as Map<String, dynamic>?;

    return GrxAddressSchemaModel(
      countryCode: countryCodeValue,
      labels: labels,
      order: normalizedOrder,
      required: normalizedRequired,
      postalCodeRule: GrxPostalCodeRule.fromMap(postalCodeRuleMap),
      postalCodeUi: postalCodeUi,
      notes: notes,
      subdivisions: subdivisions,
    );
  }

  Map<String, dynamic> toMap() => {
    'country_code': countryCode,
    'labels': labels,
    'order': order,
    'required': required,
    if (postalCodeRule != null) 'postal_code_rule': postalCodeRule!.toMap(),
    if (postalCodeUi != null) 'postalCodeUi': postalCodeUi!.toMap(),
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    if (subdivisions != null && subdivisions!.isNotEmpty)
      'subdivisions': subdivisions!.map((s) => s.toMap()).toList(),
  };

  bool isFieldRequired(String fieldName) => required.contains(fieldName);

  String? getFieldLabel(String fieldName) => labels[fieldName];
}

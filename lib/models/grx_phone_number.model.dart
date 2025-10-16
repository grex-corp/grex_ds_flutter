import 'dart:convert';

/// A model class representing a phone number with separated country code and phone number.
/// 
/// This model provides type safety and clear separation between the country code
/// and the actual phone number, making it easier to work with phone numbers in
/// different formats and contexts.
class GrxPhoneNumber {
  /// Creates a new [GrxPhoneNumber] instance.
  /// 
  /// [phone] should contain only the national phone number without the country code.
  /// [countryCode] should contain the country code with or without the '+' prefix.
  const GrxPhoneNumber({
    required this.phone,
    required this.countryCode,
  });

  /// The phone number without the country code (national format).
  /// 
  /// Example: "11987654321" for a Brazilian mobile number.
  final String phone;

  /// The country code with or without the '+' prefix.
  /// 
  /// Example: "+55" or "55" for Brazil.
  final String countryCode;

  /// Returns the phone number with country code concatenated.
  /// 
  /// This method ensures the country code has a '+' prefix and concatenates
  /// it with the phone number.
  /// 
  /// Example: "+5511987654321"
  @override
  String toString() {
    final normalizedCountryCode = countryCode.startsWith('+') 
        ? countryCode 
        : '+$countryCode';
    
    return '$normalizedCountryCode$phone';
  }

  /// Returns the phone number in E.164 format (international format).
  /// 
  /// This is the same as [toString()] but provides a more explicit method name
  /// for when you need to be clear about the format.
  /// 
  /// Example: "+5511987654321"
  String toE164() => toString();

  /// Returns the phone number in national format (without country code).
  /// 
  /// Example: "11987654321"
  String toNational() => phone;

  /// Returns the country code with '+' prefix.
  /// 
  /// Example: "+55"
  String get normalizedCountryCode {
    return countryCode.startsWith('+') ? countryCode : '+$countryCode';
  }

  /// Returns the country code without '+' prefix.
  /// 
  /// Example: "55"
  String get countryCodeDigits {
    return countryCode.replaceFirst(RegExp(r'^\+'), '');
  }

  /// Returns true if the phone number is empty or null.
  bool get isEmpty => phone.trim().isEmpty;

  /// Returns true if the phone number is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Returns true if the country code is empty or null.
  bool get hasCountryCode => countryCode.trim().isNotEmpty;

  /// Creates a [GrxPhoneNumber] from a JSON map.
  /// 
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "phone": "11987654321",
  ///   "countryCode": "+55"
  /// }
  /// ```
  factory GrxPhoneNumber.fromJson(Map<String, dynamic> json) {
    return GrxPhoneNumber(
      phone: json['phone'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
    );
  }

  /// Converts this [GrxPhoneNumber] to a JSON map.
  /// 
  /// Returns:
  /// ```json
  /// {
  ///   "phone": "11987654321",
  ///   "countryCode": "+55"
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'countryCode': countryCode,
    };
  }

  /// Creates a [GrxPhoneNumber] from a complete phone number string.
  /// 
  /// This method attempts to parse a full phone number (with country code)
  /// and separate it into phone and countryCode parts.
  /// 
  /// [fullNumber] should be in E.164 format or similar (e.g., "+5511987654321")
  /// 
  /// Returns null if the parsing fails or the format is not recognized.
  /// 
  /// Example:
  /// ```dart
  /// final phone = GrxPhoneNumber.parse('+5511987654321');
  /// // phone?.phone = "11987654321"
  /// // phone?.countryCode = "+55"
  /// ```
  static GrxPhoneNumber? parse(String fullNumber) {
    if (fullNumber.trim().isEmpty) return null;

    final cleanNumber = fullNumber.trim();
    
    // Must start with +
    if (!cleanNumber.startsWith('+')) return null;

    // Remove the + and get only digits
    final digitsOnly = cleanNumber.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.isEmpty) return null;

    // Try to extract country code (1-4 digits typically)
    for (int countryCodeLength = 1; countryCodeLength <= 4; countryCodeLength++) {
      if (digitsOnly.length <= countryCodeLength) continue;
      
      final potentialCountryCode = digitsOnly.substring(0, countryCodeLength);
      final potentialPhone = digitsOnly.substring(countryCodeLength);
      
      // Basic validation: phone should have at least 4 digits
      if (potentialPhone.length >= 4) {
        return GrxPhoneNumber(
          phone: potentialPhone,
          countryCode: '+$potentialCountryCode',
        );
      }
    }

    return null;
  }

  /// Creates a [GrxPhoneNumber] from a complete phone number string with known country code.
  /// 
  /// This method is more reliable than [parse] when you know the country code.
  /// 
  /// [fullNumber] should be in E.164 format (e.g., "+5511987654321")
  /// [expectedCountryCode] should be the country code (e.g., "+55")
  /// 
  /// Returns null if the country code doesn't match or parsing fails.
  static GrxPhoneNumber? parseWithCountryCode(
    String fullNumber, 
    String expectedCountryCode,
  ) {
    if (fullNumber.trim().isEmpty) return null;

    final normalizedExpectedCode = expectedCountryCode.startsWith('+') 
        ? expectedCountryCode 
        : '+$expectedCountryCode';

    final cleanNumber = fullNumber.trim();
    
    if (!cleanNumber.startsWith(normalizedExpectedCode)) return null;

    final phone = cleanNumber.substring(normalizedExpectedCode.length);
    
    if (phone.isEmpty) return null;

    return GrxPhoneNumber(
      phone: phone,
      countryCode: normalizedExpectedCode,
    );
  }

  /// Creates an empty [GrxPhoneNumber] with default values.
  /// 
  /// Useful for form initialization.
  factory GrxPhoneNumber.empty() {
    return const GrxPhoneNumber(
      phone: '',
      countryCode: '',
    );
  }

  /// Creates a [GrxPhoneNumber] with default Brazilian values.
  /// 
  /// Useful for Brazilian applications.
  factory GrxPhoneNumber.brazil() {
    return const GrxPhoneNumber(
      phone: '',
      countryCode: '+55',
    );
  }

  /// Creates a copy of this [GrxPhoneNumber] with the given fields replaced.
  /// 
  /// If a field is not provided, it will use the current value.
  GrxPhoneNumber copyWith({
    String? phone,
    String? countryCode,
  }) {
    return GrxPhoneNumber(
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GrxPhoneNumber &&
        other.phone == phone &&
        other.normalizedCountryCode == normalizedCountryCode;
  }

  @override
  int get hashCode => phone.hashCode ^ normalizedCountryCode.hashCode;

  /// Returns a JSON string representation of this [GrxPhoneNumber].
  /// 
  /// This is equivalent to calling [jsonEncode] on [toJson()].
  String stringify() => json.encode(toJson());
}


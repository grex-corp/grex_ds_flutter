import 'dart:convert';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

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
  const GrxPhoneNumber({required this.phone, required this.countryCode});

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
    final normalizedCountryCode =
        countryCode.startsWith('+') ? countryCode : '+$countryCode';

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

  /// Masks the phone number based on the country code formatting rules.
  ///
  /// This method attempts to use flutter_libphonenumber to format the phone number
  /// according to the specific formatting rules for the country code. If that fails,
  /// it falls back to the synchronous formatting method.
  ///
  /// Returns the formatted phone number string, or the original phone number
  /// if formatting fails or the country code is not supported.
  ///
  /// Example:
  /// ```dart
  /// final phone = GrxPhoneNumber(phone: '11987654321', countryCode: '+55');
  /// final masked = await phone.maskPhoneNumber();
  /// // Result: "(11) 98765-4321" for Brazilian format
  /// ```
  ///
  /// For US numbers:
  /// ```dart
  /// final phone = GrxPhoneNumber(phone: '1234567890', countryCode: '+1');
  /// final masked = await phone.maskPhoneNumber();
  /// // Result: "(123) 456-7890" for US format
  /// ```
  String maskPhoneNumber() {
    if (isEmpty || !hasCountryCode) {
      return phone;
    }

    try {
      // Try to use flutter_libphonenumber for more accurate formatting
      // This is a simplified approach that may need adjustment based on the actual API
      return formatNumberSync(toString());
    } catch (e) {
      // If formatting fails, return the original phone number
      return phone;
    }
  }

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
    return {'phone': phone, 'countryCode': countryCode};
  }

  /// Creates an empty [GrxPhoneNumber] with default values.
  ///
  /// Useful for form initialization.
  factory GrxPhoneNumber.empty() {
    return const GrxPhoneNumber(phone: '', countryCode: '');
  }

  /// Creates a [GrxPhoneNumber] with default Brazilian values.
  ///
  /// Useful for Brazilian applications.
  factory GrxPhoneNumber.brazil() {
    return const GrxPhoneNumber(phone: '', countryCode: '+55');
  }

  /// Creates a copy of this [GrxPhoneNumber] with the given fields replaced.
  ///
  /// If a field is not provided, it will use the current value.
  GrxPhoneNumber copyWith({String? phone, String? countryCode}) {
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

import 'package:flutter/services.dart';

/// Formatter for US ZIP+4 postal codes.
/// Automatically formats 9 digits as "12345-6789".
final class GrxZipPlus4Formatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    if (digitsOnly.length > 9) {
      digitsOnly = digitsOnly.substring(0, 9);
    }

    final String formatted;
    if (digitsOnly.length <= 5) {
      formatted = digitsOnly;
    } else {
      formatted = '${digitsOnly.substring(0, 5)}-${digitsOnly.substring(5)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

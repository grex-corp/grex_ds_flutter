import 'package:flutter/services.dart';

/// Generic mask formatter for postal codes.
/// Supports mask patterns like '#####-###' where '#' is a digit placeholder.
final class GrxPostalCodeMaskFormatter extends TextInputFormatter {
  final String mask;
  final String placeholder;

  GrxPostalCodeMaskFormatter({
    required this.mask,
    this.placeholder = '#',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    final buffer = StringBuffer();
    var digitIndex = 0;

    for (var i = 0; i < mask.length && digitIndex < digitsOnly.length; i++) {
      final maskChar = mask[i];
      if (maskChar == placeholder) {
        buffer.write(digitsOnly[digitIndex]);
        digitIndex++;
      } else {
        buffer.write(maskChar);
      }
    }

    final formatted = buffer.toString();
    final cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

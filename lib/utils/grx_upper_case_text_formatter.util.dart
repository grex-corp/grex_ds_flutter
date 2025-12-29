import 'package:flutter/services.dart';

/// A [TextInputFormatter] that converts all input text to uppercase.
///
/// This formatter automatically converts any text entered into a text field
/// to uppercase letters as the user types.
///
/// Example:
/// ```dart
/// TextField(
///   inputFormatters: [
///     GrxUpperCaseTextFormatter(),
///   ],
/// )
/// ```
class GrxUpperCaseTextFormatter extends TextInputFormatter {
  /// Creates a [GrxUpperCaseTextFormatter].
  const GrxUpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the text hasn't changed, return as is
    if (newValue.text == oldValue.text) {
      return newValue;
    }

    // Convert text to uppercase
    final upperText = newValue.text.toUpperCase();

    // Since converting to uppercase doesn't change text length,
    // we can maintain the same cursor position
    return TextEditingValue(
      text: upperText,
      selection: newValue.selection,
    );
  }
}


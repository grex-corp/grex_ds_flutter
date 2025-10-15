import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../../models/grx_country.model.dart';
import '../../models/grx_phone_number.model.dart';
import '../../services/grx_bottom_sheet.service.dart';
import '../../utils/grx_country.util.dart';
import '../bottom_sheet/ds_bottom_sheet_countries.widget.dart';
import '../grx_stateful.widget.dart';
import '../typography/grx_label_large_text.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_text_form_field.widget.dart';

class GrxPhoneFormField extends GrxStatefulWidget {
  GrxPhoneFormField({
    final Key? key,
    required this.labelText,
    this.controller,
    this.value,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.sentences,
    this.textAlignVertical = TextAlignVertical.center,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
    this.hintText,
    this.hintMaxLines,
    this.autovalidateMode = AutovalidateMode.always,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusNode,
    this.autoFocus = false,
    this.enabled = true,
    this.flexible = false,
    this.isLoading = false,
  }) : super(key: key ?? ValueKey<int>(labelText.hashCode));

  /// Phone number controller that works with [GrxPhoneNumber] model
  final GrxFormFieldController<GrxPhoneNumber>? controller;
  
  /// Phone number value using [GrxPhoneNumber] model
  final GrxPhoneNumber? value;
  
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  
  /// Phone number callback that provides [GrxPhoneNumber] model
  final void Function(GrxPhoneNumber? phone)? onChanged;
  
  /// Phone number callback that provides [GrxPhoneNumber] model
  final void Function(GrxPhoneNumber? phone)? onSaved;
  
  /// Phone number validator that works with [GrxPhoneNumber] model
  final FormFieldValidator<GrxPhoneNumber?>? validator;
  
  final EdgeInsets? contentPadding;
  final TextCapitalization textCapitalization;
  final TextAlignVertical textAlignVertical;
  final int? maxLines;
  final bool alignLabelWithHint;
  final String? hintText;
  final int? hintMaxLines;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  
  /// Phone number callback that provides [GrxPhoneNumber] model
  final void Function(GrxPhoneNumber? phone)? onFieldSubmitted;
  
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool enabled;
  final bool flexible;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxPhoneFormFieldState();
}

class _GrxPhoneFormFieldState extends State<GrxPhoneFormField> {
  // Phone number controller
  late final controller = widget.controller ?? GrxFormFieldController<GrxPhoneNumber>();
  
  // Internal state
  String selectedCountryCode = '+55'; // Default to Brazil
  String selectedRegionCode = 'BR'; // Default region code
  LibPhonenumberTextFormatter? formatter;
  bool _isInitialized = false;
  Map<String, CountryWithPhoneCode> regions = {};
  
  // Current phone number state
  GrxPhoneNumber _currentPhoneNumber = GrxPhoneNumber.empty();
  
  // Internal text controller for display formatting
  late final GrxFormFieldController<String> _textController = GrxFormFieldController<String>();

  @override
  void initState() {
    super.initState();
    _initializeLibPhoneNumber();
  }

  Future<void> _initializeLibPhoneNumber() async {
    // Note: flutter_libphonenumber should be initialized via GrexDS.init()
    // If not initialized yet, initialize it here as a fallback
    try {
      regions = await getAllSupportedRegions();
    } catch (e) {
      // If getAllSupportedRegions fails, it means init wasn't called
      // Initialize it now as a fallback
      await init();
      regions = await getAllSupportedRegions();
    }


    // Try to get device region
    String? deviceRegion;
    try {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final countryCode = locale.countryCode?.toUpperCase();

      if (countryCode != null && regions.containsKey(countryCode)) {
        deviceRegion = countryCode;
      }
    } catch (e) {
      deviceRegion = null;
    }

    // Handle initial phone value
    if (widget.value != null) {
      await _parsePhoneValue(widget.value!, deviceRegion);
    } else {
      // Initialize with empty phone number and default country
      if (deviceRegion != null) {
        selectedRegionCode = deviceRegion;
        final regionInfo = regions[deviceRegion];
        if (regionInfo != null) {
          selectedCountryCode = '+${regionInfo.phoneCode}';
        }
      }
      
      // Initialize the controllers with empty phone number
      _currentPhoneNumber = GrxPhoneNumber(
        phone: '',
        countryCode: selectedCountryCode,
      );
      controller.updateValue(_currentPhoneNumber);
      _textController.text = ''; // Initialize text controller with empty string
    }

    // Create formatter
    _updateFormatter();

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _parsePhoneValue(GrxPhoneNumber phoneValue, String? deviceRegion) async {
    // Update internal state
    _currentPhoneNumber = phoneValue;
    
    // Update phone controller
    controller.updateValue(phoneValue);
    
    // Set country code and region
    if (phoneValue.hasCountryCode) {
      selectedCountryCode = phoneValue.normalizedCountryCode;
      
      // Find the region for this country code
      for (final entry in regions.entries) {
        if ('+${entry.value.phoneCode}' == selectedCountryCode) {
          selectedRegionCode = entry.key;
          break;
        }
      }
    } else if (deviceRegion != null) {
      selectedRegionCode = deviceRegion;
      final regionInfo = regions[deviceRegion];
      if (regionInfo != null) {
        selectedCountryCode = '+${regionInfo.phoneCode}';
      }
    }
    
    // Update formatter
    _updateFormatter();
    
    // Set the formatted display value
    await _setFormattedValue(phoneValue.phone);
  }


  Future<void> _setFormattedValue(String value) async {
    if (value.isEmpty) {
      _textController.text = '';
      _updatePhoneNumber('');
      return;
    }

    // Clean the value to only digits
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanValue.isEmpty) {
      _textController.text = '';
      _updatePhoneNumber('');
      return;
    }

    // For Brazil, apply custom formatting to ensure correct masks
    if (selectedRegionCode == 'BR') {
      _applyBrazilFormatting(cleanValue);
      return;
    }

    // For other countries, use flutter_libphonenumber
    try {
      final fullNumber = '$selectedCountryCode$cleanValue';
      final formattedResult = await format(fullNumber, selectedRegionCode);
      final formatted =
          formattedResult['formatted'] ?? formattedResult.values.first;

      // Remove country code prefix from formatted result
      String displayValue = formatted;
      if (formatted.startsWith(selectedCountryCode)) {
        displayValue = formatted.substring(selectedCountryCode.length).trim();
      }

      // Additional cleaning: remove any leading + or spaces
      displayValue = displayValue.replaceFirst(RegExp(r'^\+?\s*'), '');

      _textController.text = displayValue;
      _updatePhoneNumber(cleanValue);
    } catch (e) {
      // If formatting fails, just use the cleaned value
      _textController.text = cleanValue;
      _updatePhoneNumber(cleanValue);
    }
  }

  /// Updates the phone number model and controllers with the current values
  void _updatePhoneNumber(String cleanPhoneNumber) {
    final newPhoneNumber = GrxPhoneNumber(
      phone: cleanPhoneNumber,
      countryCode: selectedCountryCode,
    );
    
    _currentPhoneNumber = newPhoneNumber;
    controller.updateValue(newPhoneNumber);
    
    // Call the callback
    widget.onChanged?.call(newPhoneNumber);
  }

  void _applyBrazilFormatting(String cleanValue) {
    String formattedValue;
    
    if (cleanValue.length < 2) {
      formattedValue = cleanValue;
    } else {
      final areaCode = cleanValue.substring(0, 2);

      if (cleanValue.length <= 2) {
        formattedValue = '($areaCode';
      } else if (cleanValue.length <= 6) {
        // Partial number
        final rest = cleanValue.substring(2);
        formattedValue = '($areaCode) $rest';
      } else if (cleanValue.length <= 10) {
        // Old format: (XX) XXXX-XXXX
        final firstPart = cleanValue.substring(2, 6);
        final secondPart = cleanValue.substring(6);
        formattedValue = '($areaCode) $firstPart-$secondPart';
      } else {
        // New format: (XX) XXXXX-XXXX (11 digits)
        final firstPart = cleanValue.substring(2, 7);
        final secondPart = cleanValue.substring(
          7,
          cleanValue.length > 11 ? 11 : cleanValue.length,
        );
        formattedValue = '($areaCode) $firstPart-$secondPart';
      }
    }
    
    _textController.text = formattedValue;
    _updatePhoneNumber(cleanValue);
  }


  CountryWithPhoneCode? _getCountryForRegion(String regionCode) {
    try {
      return regions[regionCode];
    } catch (e) {
      return null;
    }
  }

  void _updateFormatter() {
    // Update formatter with new country
    final country = _getCountryForRegion(selectedRegionCode);
    if (country != null) {
      formatter = LibPhonenumberTextFormatter(
        country: country,
        inputContainsCountryCode: false,
      );
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (selectedRegionCode == 'BR') {
      return [BrazilPhoneInputFormatter()];
    } else if (formatter != null) {
      return [formatter!];
    }
    return [];
  }

  Future<String?> _showCountryCodeSelector(BuildContext context) async {
    // Get current country or default to Brazil
    final currentCountry = GrxCountryUtils.countries.firstWhere(
      (c) => c.code == selectedCountryCode,
      orElse: () => GrxCountryUtils.countries.first,
    );

    final bottomSheet = GrxBottomSheetService(
      context: context,
      title: 'Select Country Code',
      builder: (controller) {
        return GrxBottomSheetCountries(selectedCountry: currentCountry);
      },
    );

    final result = await bottomSheet.show<GrxCountry>();
    return result?.code;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return GrxTextFormField(
        controller: _textController,
        labelText: widget.labelText,
        enabled: false,
        hintText: 'Loading...',
      );
    }

    return GrxTextFormField(
      controller: _textController,
      value: _textController.text,
      labelText: widget.labelText,
      keyboardType: widget.keyboardType ?? TextInputType.phone,
      obscureText: widget.obscureText,
      prefix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final result = await _showCountryCodeSelector(context);

              if (result != null) {
                // Find the region for this country code
                for (final entry in regions.entries) {
                  if ('+${entry.value.phoneCode}' == result) {
                    selectedRegionCode = entry.key;
                    break;
                  }
                }

                selectedCountryCode = result;
                _updateFormatter();

                // Reformat the current value with the new country code
                final currentValue = _textController.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                if (currentValue.isNotEmpty) {
                  await _setFormattedValue(currentValue);
                }

                setState(() {});
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GrxLabelLargeText(selectedCountryCode),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ],
      ),
      onChanged: (value) {
        // Parse the current text and update phone number
        final cleanNumber = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
        _updatePhoneNumber(cleanNumber);
      },
      onSaved: (value) {
        widget.onSaved?.call(_currentPhoneNumber);
      },
      validator: (value) {
        return widget.validator?.call(_currentPhoneNumber);
      },
      contentPadding: widget.contentPadding,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: widget.textAlignVertical,
      maxLines: widget.maxLines,
      alignLabelWithHint: widget.alignLabelWithHint,
      hintText: widget.hintText,
      hintMaxLines: widget.hintMaxLines,
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (value) {
        widget.onFieldSubmitted?.call(_currentPhoneNumber);
      },
      focusNode: widget.focusNode,
      autoFocus: widget.autoFocus,
      enabled: widget.enabled,
      flexible: widget.flexible,
      inputFormatters: _getInputFormatters(),
      isLoading: widget.isLoading,
    );
  }
}

/// Custom TextInputFormatter for Brazilian phone numbers
/// Handles both 10-digit (landline) and 11-digit (mobile) formats
class BrazilPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    final oldCursorPosition = oldValue.selection.baseOffset;
    
    // Check if this is a deletion operation
    final isDeleting = newText.length < oldText.length;
    
    // Remove all non-digit characters from both old and new text
    final oldDigitsOnly = oldText.replaceAll(RegExp(r'[^0-9]'), '');
    final newDigitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // If all digits are removed, return empty
    if (newDigitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Handle special deletion case: if user is trying to delete formatting characters
    if (isDeleting && oldDigitsOnly == newDigitsOnly) {
      // User is deleting formatting characters, not digits
      // Allow this by removing one digit from the end
      if (oldDigitsOnly.length > 1) {
        final adjustedDigits = oldDigitsOnly.substring(0, oldDigitsOnly.length - 1);
        final formattedText = _formatBrazilianNumber(adjustedDigits);
        return TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      } else {
        // If only one digit, allow complete deletion
        return const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
      }
    }

    // Limit to 11 digits
    final limitedDigits = newDigitsOnly.length > 11 
        ? newDigitsOnly.substring(0, 11) 
        : newDigitsOnly;

    // Format the number
    final formattedText = _formatBrazilianNumber(limitedDigits);
    
    // Calculate the correct cursor position
    int newCursorPosition;
    
    if (isDeleting) {
      // When deleting, try to maintain a logical cursor position
      newCursorPosition = _calculateCursorPositionForDeletion(
        oldText, 
        oldCursorPosition, 
        formattedText, 
        oldDigitsOnly, 
        limitedDigits,
      );
    } else {
      // When typing, place cursor at the end of the formatted text
      newCursorPosition = formattedText.length;
    }
    
    // Ensure cursor position is within bounds
    newCursorPosition = newCursorPosition.clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
  
  /// Formats Brazilian phone numbers with proper masks
  String _formatBrazilianNumber(String digits) {
    if (digits.isEmpty) return '';
    
    final buffer = StringBuffer();
    
    // Area code
    buffer.write('(');
    buffer.write(digits.substring(0, digits.length >= 2 ? 2 : digits.length));
    
    if (digits.length >= 2) {
      buffer.write(') ');
      
      if (digits.length <= 10) {
        // 10-digit format: (XX) XXXX-XXXX
        final firstPart = digits.substring(2, digits.length >= 6 ? 6 : digits.length);
        buffer.write(firstPart);
        
        if (digits.length > 6) {
          buffer.write('-');
          buffer.write(digits.substring(6));
        }
      } else {
        // 11-digit format: (XX) XXXXX-XXXX
        final firstPart = digits.substring(2, digits.length >= 7 ? 7 : digits.length);
        buffer.write(firstPart);
        
        if (digits.length > 7) {
          buffer.write('-');
          buffer.write(digits.substring(7));
        }
      }
    }
    
    return buffer.toString();
  }
  
  /// Calculates appropriate cursor position during deletion
  int _calculateCursorPositionForDeletion(
    String oldText,
    int oldCursorPosition,
    String newFormattedText,
    String oldDigits,
    String newDigits,
  ) {
    // If we're deleting and the cursor is at the end, move it back appropriately
    if (oldCursorPosition == oldText.length) {
      // Special case: if we have only area code digits (2 or fewer), allow deletion to continue
      if (newDigits.length <= 2 && newFormattedText.endsWith(') ')) {
        // Allow deletion of the closing parenthesis and space
        return newFormattedText.length - 2;
      }
      
      // If we deleted a digit, place cursor at the end of the new formatted text
      return newFormattedText.length;
    }
    
    // If we're deleting from the middle, try to maintain relative position
    final deletedDigitCount = oldDigits.length - newDigits.length;
    
    if (deletedDigitCount > 0) {
      // Find where the cursor should be based on the remaining digits
      final digitPosition = _findDigitPositionInFormattedText(
        newFormattedText, 
        newDigits.length,
      );
      return digitPosition;
    }
    
    // Default: place at end
    return newFormattedText.length;
  }
  
  /// Finds the position in formatted text where a specific number of digits would end
  int _findDigitPositionInFormattedText(String formattedText, int digitCount) {
    int digitIndex = 0;
    
    for (int i = 0; i < formattedText.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(formattedText[i])) {
        digitIndex++;
        if (digitIndex == digitCount) {
          return i + 1; // Position after this digit
        }
      }
    }
    
    return formattedText.length;
  }
}

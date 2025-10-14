import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import '../../models/grx_country.model.dart';
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

  final GrxFormFieldController<String>? controller;
  final String? value;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSaved;
  final FormFieldValidator<String?>? validator;
  final EdgeInsets? contentPadding;
  final TextCapitalization textCapitalization;
  final TextAlignVertical textAlignVertical;
  final int? maxLines;
  final bool alignLabelWithHint;
  final String? hintText;
  final int? hintMaxLines;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final void Function(String? value)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool enabled;
  final bool flexible;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxPhoneFormFieldState();
}

class _GrxPhoneFormFieldState extends State<GrxPhoneFormField> {
  late final controller = widget.controller ?? GrxFormFieldController<String>();
  String selectedCountryCode = '+55'; // Default to Brazil
  String selectedRegionCode = 'BR'; // Default region code
  LibPhonenumberTextFormatter? formatter;
  bool _isInitialized = false;
  Map<String, CountryWithPhoneCode> regions = {};

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

    if (widget.value != null && widget.value!.isNotEmpty) {
      await _parseInitialValue(widget.value!, deviceRegion);
    } else if (deviceRegion != null) {
      // Set country code based on device region
      selectedRegionCode = deviceRegion;
      final regionInfo = regions[deviceRegion];
      if (regionInfo != null) {
        selectedCountryCode = '+${regionInfo.phoneCode}';
      }
    }

    // Create formatter
    _updateFormatter();

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _parseInitialValue(String value, String? deviceRegion) async {
    // Clean the input value
    final cleanValue = value.trim();

    // If the number starts with +, manually extract the country code
    if (cleanValue.startsWith('+')) {
      final extractedInfo = _extractCountryCodeFromNumber(cleanValue);

      if (extractedInfo != null) {
        selectedCountryCode = extractedInfo['countryCode'];
        selectedRegionCode = extractedInfo['regionCode'];
        final nationalNumber = extractedInfo['nationalNumber'];

        // Update formatter for the new region
        _updateFormatter();

        // Format and set the national number
        await _setFormattedValue(nationalNumber);
        return;
      }
    }

    // For numbers without country code, use default or device region
    if (deviceRegion != null) {
      selectedRegionCode = deviceRegion;
      final regionInfo = regions[deviceRegion];
      if (regionInfo != null) {
        selectedCountryCode = '+${regionInfo.phoneCode}';
      }
    }

    // Update formatter
    _updateFormatter();

    // Set the value
    await _setFormattedValue(cleanValue.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  /// Manually extracts country code from international phone numbers
  Map<String, dynamic>? _extractCountryCodeFromNumber(String phoneNumber) {
    if (!phoneNumber.startsWith('+')) return null;

    // Remove the + and get only digits
    final digitsOnly = phoneNumber.substring(1).replaceAll(RegExp(r'[^0-9]'), '');

    // Try to match country codes (longest first to avoid partial matches)
    // Sort regions by phone code length descending
    final sortedRegions = regions.entries.toList()
      ..sort((a, b) => b.value.phoneCode.length.compareTo(a.value.phoneCode.length));

    for (final entry in sortedRegions) {
      final phoneCode = entry.value.phoneCode;
      if (digitsOnly.startsWith(phoneCode)) {
        return {
          'countryCode': '+$phoneCode',
          'regionCode': entry.key,
          'nationalNumber': digitsOnly.substring(phoneCode.length),
        };
      }
    }

    return null;
  }

  Future<void> _setFormattedValue(String value) async {
    if (value.isEmpty) {
      controller.text = '';
      return;
    }

    // Clean the value to only digits
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanValue.isEmpty) {
      controller.text = '';
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

      controller.text = displayValue;
    } catch (e) {
      // If formatting fails, just use the cleaned value
      controller.text = cleanValue;
    }
  }

  void _applyBrazilFormatting(String cleanValue) {
    if (cleanValue.length < 2) {
      controller.text = cleanValue;
      return;
    }

    final areaCode = cleanValue.substring(0, 2);

    if (cleanValue.length <= 2) {
      controller.text = '($areaCode';
    } else if (cleanValue.length <= 6) {
      // Partial number
      final rest = cleanValue.substring(2);
      controller.text = '($areaCode) $rest';
    } else if (cleanValue.length <= 10) {
      // Old format: (XX) XXXX-XXXX
      final firstPart = cleanValue.substring(2, 6);
      final secondPart = cleanValue.substring(6);
      controller.text = '($areaCode) $firstPart-$secondPart';
    } else {
      // New format: (XX) XXXXX-XXXX (11 digits)
      final firstPart = cleanValue.substring(2, 7);
      final secondPart = cleanValue.substring(
        7,
        cleanValue.length > 11 ? 11 : cleanValue.length,
      );
      controller.text = '($areaCode) $firstPart-$secondPart';
    }
  }

  String? _getFullNumber() {
    final cleanNumber = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanNumber.isNotEmpty ? '$selectedCountryCode$cleanNumber' : null;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return GrxTextFormField(
        controller: controller,
        labelText: widget.labelText,
        enabled: false,
        hintText: 'Loading...',
      );
    }

    return GrxTextFormField(
      controller: controller,
      value: controller.text,
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
                final currentValue = controller.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                if (currentValue.isNotEmpty) {
                  await _setFormattedValue(currentValue);
                }

                setState(() {});
                widget.onChanged?.call(_getFullNumber());
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
        widget.onChanged?.call(_getFullNumber());
      },
      onSaved: (value) => widget.onSaved?.call(_getFullNumber()),
      validator: widget.validator,
      contentPadding: widget.contentPadding,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: widget.textAlignVertical,
      maxLines: widget.maxLines,
      alignLabelWithHint: widget.alignLabelWithHint,
      hintText: widget.hintText,
      hintMaxLines: widget.hintMaxLines,
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted:
          (value) => widget.onFieldSubmitted?.call(_getFullNumber()),
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
    final text = newValue.text;

    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 11 digits
    final limitedDigits =
        digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;

    if (limitedDigits.isEmpty) {
      return const TextEditingValue();
    }

    final buffer = StringBuffer();

    // Area code
    if (limitedDigits.isNotEmpty) {
      buffer.write('(');
      buffer.write(
        limitedDigits.substring(
          0,
          limitedDigits.length >= 2 ? 2 : limitedDigits.length,
        ),
      );

      if (limitedDigits.length >= 2) {
        buffer.write(') ');

        // First part of the number
        if (limitedDigits.length <= 10) {
          // 10-digit format: (XX) XXXX-XXXX
          final firstPartLength =
              limitedDigits.length >= 6 ? 4 : limitedDigits.length - 2;
          buffer.write(limitedDigits.substring(2, 2 + firstPartLength));

          if (limitedDigits.length > 6) {
            buffer.write('-');
            buffer.write(limitedDigits.substring(6));
          }
        } else {
          // 11-digit format: (XX) XXXXX-XXXX
          final firstPartLength =
              limitedDigits.length >= 7 ? 5 : limitedDigits.length - 2;
          buffer.write(limitedDigits.substring(2, 2 + firstPartLength));

          if (limitedDigits.length > 7) {
            buffer.write('-');
            buffer.write(limitedDigits.substring(7));
          }
        }
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

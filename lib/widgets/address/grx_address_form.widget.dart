import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../delegates/grx_address_form_delegate.dart';
import '../../enums/grx_autocomplete_loading_style.enum.dart';
import '../../models/address/grx_address_form_strings.dart';
import '../../models/address/grx_address_schema.model.dart';
import '../../models/address/grx_autocomplete_item.model.dart';
import '../../models/address/grx_canonical_address.model.dart';
import '../../models/address/grx_subdivision.model.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../../themes/typography/utils/grx_font_weights.dart';
import '../../utils/address/grx_postal_code_mask_formatter.dart';
import '../../utils/address/grx_postal_code_validator.dart';
import '../../utils/address/grx_zip_plus_4_formatter.dart';
import '../buttons/grx_primary_button.widget.dart';
import '../fields/controllers/grx_form_field.controller.dart';
import '../fields/grx_autocomplete_dropdown_form_field.widget.dart';
import '../fields/grx_dropdown_form_field.widget.dart';
import '../fields/grx_text_form_field.widget.dart';
import '../typography/grx_label_text.widget.dart';



/// Stable field kind for UI decisions; avoids breakage when schema casing changes.
enum _GrxAddressFormField {
  line1,
  line2,
  dependentLocality,
  locality,
  administrativeArea,
  postalCode,
  country,
  unknown;

  static _GrxAddressFormField fromNormalizedId(String? id) {
    if (id == null || id.isEmpty) return _GrxAddressFormField.unknown;
    return switch (id) {
      'line1' => line1,
      'line2' => line2,
      'dependent_locality' => dependentLocality,
      'locality' => locality,
      'administrative_area' => administrativeArea,
      'postal_code' => postalCode,
      'country_code' => country,
      'country' => country,
      _ => unknown,
    };
  }
}

/// Schema-driven address form widget
class GrxAddressForm extends StatefulWidget {
  final GrxAddressFormDelegate delegate;
  final GrxAddressFormStrings strings;
  final GrxCanonicalAddressModel? initialValue;
  final String? defaultCountryCode;
  final ValueChanged<GrxCanonicalAddressModel?>? onChanged;
  final ValueChanged<GrxCanonicalAddressModel>? onSubmit;
  /// Called after a new schema is loaded (e.g. on country change). Parent can trigger Form.validate() so postal code and required checks reflect the new schema immediately.
  final VoidCallback? onSchemaLoaded;
  /// Optional callback to request the parent Form to validate (e.g. when an address field changes so other fields' required/errors update). If null, Form.maybeOf(context)?.validate() is used.
  final VoidCallback? onRequestValidation;
  /// Called once with a function that runs required-field validation (line1, etc. when address is being filled). Parent should call it before save so address is validated even if Form.validate() doesn't run these fields.
  final void Function(bool Function() validate)? registerValidate;
  final bool enabled;
  final bool isLoading;
  final bool allowEmpty;

  const GrxAddressForm({
    super.key,
    required this.delegate,
    required this.strings,
    this.initialValue,
    this.defaultCountryCode,
    this.onChanged,
    this.onSubmit,
    this.onSchemaLoaded,
    this.onRequestValidation,
    this.registerValidate,
    this.enabled = true,
    this.isLoading = false,
    this.allowEmpty = false,
  });

  @override
  State<GrxAddressForm> createState() => _GrxAddressFormState();
}

class _GrxAddressFormState extends State<GrxAddressForm> {
  static const _postalCodeValidator = GrxPostalCodeValidator();

  GrxAddressSchemaModel? _schema;
  List<GrxSubdivisionModel>? _sortedSubdivisions; // Cached sorted subdivisions
  final Map<String, GrxFormFieldController<String>> _controllers = {};
  String? _selectedCountryCode;
  final Map<String, String?> _fieldErrors = {};
  bool _isLoadingSchema = false;
  List<String> _sortedCountries = []; // Cached sorted countries
  bool _isLoadingCountries = false;

  // Autocomplete state
  late final GrxFormFieldController<String> _addressSearchController;
  String? _placesSession;
  String? _searchError;
  bool _isFillingFromAutocomplete = false;

  // CEP lookup (BR only)
  bool _isLookingUpCep = false;
  String? _cepError;

  // Focus node for line1 (used for auto-focus after CEP lookup)
  final FocusNode _line1FocusNode = FocusNode();
  final FocusNode _postalCodeFocusNode = FocusNode();

  Timer? _addressRevalidationTimer;

  // BR line1 number validation state tracking
  bool _didLookupCepThisSession = false;
  bool _line1Touched = false;

  // Reliability mechanism: epoch counter to force helper rebuild after CEP lookup
  final ValueNotifier<int> _helperEpoch = ValueNotifier<int>(0);

  // Guard to prevent state updates during dropdown initialization
  bool _adminAreaDropdownInitializing = true;

  /// Country of the schema when current dependent controllers were created.
  /// Used to only recreate controllers on country change, not on first load (keeps prefilled values).
  String? _schemaCountryWhenControllersCreated;

  // Store lat/lng from place-details (not editable fields)
  double? _addressLat;
  double? _addressLng;

  /// Cached postal-code input config — stable references avoid TextField remounts.
  List<TextInputFormatter>? _postalCodeInputFormatters;
  TextInputType? _postalCodeKeyboardType;

  /// Safe setState helper that defers updates if called during build phase
  void _safeSetState(void Function() fn, {String? reason}) {
    if (!mounted) return;

    final phase = SchedulerBinding.instance.schedulerPhase;
    final isDuringBuild =
        phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks ||
        phase == SchedulerPhase.transientCallbacks;

    if (isDuringBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(fn);
        }
      });
    } else {
      setState(fn);
    }
  }

  /// Request a post-frame rebuild to ensure UI reflects controller text changes
  /// Use this after controller.text mutations that may not trigger automatic rebuilds
  void _requestPostFrameRefresh(String reason) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _safeSetState(() {}, reason: 'Post-frame refresh: $reason');
      }
    });
  }

  /// Schema epoch/fingerprint for dynamic keys. When this changes, schema-sensitive
  /// fields (postal_code, administrative_area) are recreated so validation and
  /// options reflect the current schema.
  String _schemaEpochKey() {
    final cc = (_selectedCountryCode ?? '').toUpperCase();
    final rule = _schema?.postalCodeRule;
    final patterns = (rule != null && rule.effectivePatterns.isNotEmpty)
        ? rule.effectivePatterns.join('|')
        : 'no-rule';
    final subsCount = _sortedSubdivisions?.length ?? 0;
    return '$cc::$patterns::$subsCount';
  }

  /// Key for a form field. Schema-sensitive fields use epoch so they rebuild on
  /// country/schema change; others use a stable suffix to avoid losing focus.
  Key _fieldKey(String fieldName) {
    const schemaSensitive = <String>{'administrative_area'};
    final suffix =
        schemaSensitive.contains(fieldName) ? _schemaEpochKey() : 'stable';
    return ValueKey('address_field_${fieldName}_$suffix');
  }

  /// Defers address revalidation so input formatters finish updating controllers
  /// before required-state checks run, without triggering parent Form.validate()
  /// on every keystroke (which can steal focus when the parent rebuilds).
  void _scheduleAddressFieldRevalidation() {
    _safeSetState(() {}, reason: 'Refresh form to revalidate on address field change');

    _addressRevalidationTimer?.cancel();
    _addressRevalidationTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      _safeSetState(() {}, reason: 'Deferred address field revalidation');
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize autocomplete search controller
    _addressSearchController = GrxFormFieldController<String>();

    // Initialize country code
    _selectedCountryCode = widget.defaultCountryCode ?? widget.initialValue?.countryCode ?? 'BR';

    if (widget.initialValue != null) {
      _initializeControllers(widget.initialValue!);
    }

    // Setup focus listeners for line1 (BR number validation)
    _line1FocusNode.addListener(() {
      if (!mounted) return;
      if (_line1FocusNode.hasFocus) {
        // Focus gained: mark as touched
        _safeSetState(() {
          _line1Touched = true;
        }, reason: 'Mark line1 as touched on focus');
      } else {
        // Focus lost (blur): evaluate valid number/no-number marker rule if BR
        if (_selectedCountryCode?.toUpperCase() == 'BR') {
          final shouldCheck = _didLookupCepThisSession || _line1Touched;
          if (shouldCheck) {
            final line1Controller = _controllers['line1'];
            final hasValidPattern = line1Controller != null && _hasBrValidNumberOrNoNumber(line1Controller.text);
            _safeSetState(() {
              // Update epoch to refresh helper visibility
              _helperEpoch.value = _helperEpoch.value + 1;
            }, reason: 'Set line1 error flag on blur based on valid pattern presence');
          }
        }
      }
    });

    _postalCodeFocusNode.addListener(() {
      if (!mounted || _postalCodeFocusNode.hasFocus) return;
      _scheduleAddressFieldRevalidation();
    });

    // Defer async operations to post-frame to avoid build-time issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCountries();
        _loadSchema();
        // Allow dropdown callbacks after first frame
        _adminAreaDropdownInitializing = false;
      }
    });
  }

  /// Async search callback for GrxAutocompleteDropdownFormField
  Future<Iterable<GrxAutocompleteItemModel>?> _onSearch(String? query) async {
    // Clear error when search starts
    if (_searchError != null) {
      _safeSetState(() {
        _searchError = null;
      }, reason: 'Clear search error on new search');
    }

    // Return empty if query is null or country not selected
    if (query == null || _selectedCountryCode == null) {
      return null;
    }

    final trimmedQuery = query.trim();

    // DS handles minChars, but we can still return empty if query is too short
    // (though DS should prevent this call if minChars is set)
    if (trimmedQuery.isEmpty) {
      return [];
    }

    try {
      // Generate session token if not exists (start of new search cycle)
      _placesSession ??= _generateSessionToken(trimmedQuery);

      final suggestions = await widget.delegate.autocomplete(
        query: trimmedQuery,
        countryCode: _selectedCountryCode!,
        session: _placesSession,
      );

      return suggestions;
    } catch (error) {
      // Return empty list to show emptyText instead of crashing
      _safeSetState(() {
        _searchError = widget.strings.addressSearchError;
      }, reason: 'Set search error on autocomplete failure');
      return [];
    }
  }

  String _generateSessionToken(String query) {
    // Simple UUID-like token generation
    return '${DateTime.now().millisecondsSinceEpoch}_${_selectedCountryCode}_${query.hashCode}';
  }

  /// Selection callback for GrxAutocompleteDropdownFormField
  Future<void> _onSuggestionSelected(GrxAutocompleteItemModel? item) async {
    if (item == null || _selectedCountryCode == null) {
      return;
    }

    _safeSetState(() {
      _searchError = null;
      _isFillingFromAutocomplete = true;
    }, reason: 'Set loading state for autocomplete selection');

    try {
      final address = await widget.delegate.fetchPlaceDetails(
        placeId: item.placeId,
        countryCode: _selectedCountryCode!,
        session: _placesSession,
      );

      // Clear all address fields first to prevent stale values when canonical has nulls
      _clearAddressFieldsForSchema();

      // Fill form fields with canonical address
      _fillFormFromCanonicalAddress(address);

      // Clear all field errors after autocomplete fill (fresh address context)
      // This ensures stale validation errors don't persist after programmatic updates
      _safeSetState(_fieldErrors.clear, reason: 'Clear all field errors after autocomplete fill');

      // Set controller text to show selected description (should not trigger search due to disableSearchOnSelect)
      _addressSearchController.text = item.description;

      // Clear session token after successful selection (new session next time)
      _placesSession = null;

      // Notify parent of change
      _notifyChanged();

      // Trigger safe refresh of field validators after fill completes
      // This ensures DS fields rebuild and re-read controller + error state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _safeSetState(() {
            // Empty setState to trigger rebuild of form fields
            // This refreshes validator state without changing any values
          }, reason: 'Refresh field validators after autocomplete fill');
        }
      });
    } catch (error) {
      if (mounted) {
        _safeSetState(() {
          _searchError = widget.strings.addressSearchError;
        }, reason: 'Set error on place details failure');
      }
    } finally {
      if (mounted) {
        _safeSetState(() {
          _isFillingFromAutocomplete = false;
        }, reason: 'Clear filling state in finally block');
      }
    }
  }

  /// Clear all address fields based on canonical UI field allowlist
  /// Used before filling from autocomplete to prevent stale values
  /// Only clears known canonical UI fields, not arbitrary schema keys
  void _clearAddressFieldsForSchema() {
    // Allowlist of canonical UI fields that the form actually controls
    // This is safer than relying on schema.order which may contain unknown keys
    const canonicalFields = [
      'line1',
      'line2',
      'dependent_locality',
      'locality',
      'administrative_area',
      'postal_code',
    ];

    for (final fieldName in canonicalFields) {
      final controller = _controllers[fieldName];
      if (controller != null) {
        controller.text = '';
      }
    }

    // Clear lat/lng and form errors (use setState for primitive state fields)
    _safeSetState(() {
      _addressLat = null;
      _addressLng = null;
      _fieldErrors.clear();
      _searchError = null;
      _cepError = null;
    }, reason: 'Clear lat/lng and form errors before autocomplete fill');
  }

  void _fillFormFromCanonicalAddress(GrxCanonicalAddressModel address) {
    // Update controllers with canonical address values
    // Using _safeSetState to ensure UI updates
    _safeSetState(() {
      if (address.line1 != null) {
        _controllers['line1']?.text = address.line1!;
      }
      if (address.line2 != null) {
        _controllers['line2']?.text = address.line2!;
      }
      if (address.dependentLocality != null) {
        _controllers['dependent_locality']?.text = address.dependentLocality!;
      }
      if (address.locality != null) {
        _controllers['locality']?.text = address.locality!;
      }
      if (address.administrativeArea != null) {
        _controllers['administrative_area']?.text = address.administrativeArea!;
      }
      if (address.postalCode != null) {
        _controllers['postal_code']?.text = address.postalCode!;
      }

      // Store lat/lng from place-details (only if present)
      if (address.lat != null) {
        _addressLat = address.lat;
      }
      if (address.lng != null) {
        _addressLng = address.lng;
      }
    });
  }

  /// BR-specific: Handle post-CEP behavior for line1 field
  /// - Auto-focus line1
  /// - Append ", " if line1 has no valid number/no-number marker and doesn't end with ", "
  /// - Does NOT trigger validation error (error only on blur/save)
  void _handlePostCepLine1Behavior() {
    if (_selectedCountryCode?.toUpperCase() != 'BR') return;

    final line1Controller = _controllers['line1'];
    if (line1Controller == null) return;

    final currentText = line1Controller.text;
    final hasValidPattern = _hasBrValidNumberOrNoNumber(currentText);

    // If line1 has no valid number pattern or "no number" marker, prepare it for input
    // Only append if line1 is non-empty (empty fields don't need comma)
    if (!hasValidPattern && currentText.trim().isNotEmpty) {
      final trimmed = currentText.trim();
      // Check original text to see if it already ends with ", " (before trimming)
      if (!currentText.endsWith(', ')) {
        line1Controller.text = '$trimmed, ';
        // Place cursor at the end
        line1Controller.selection = TextSelection.fromPosition(
          TextPosition(offset: line1Controller.text.length),
        );
      }
    }

    // Auto-focus line1 after CEP fill (defer to next frame to ensure field is built)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _line1FocusNode.canRequestFocus) {
        _line1FocusNode.requestFocus();
      }
    });
  }

  /// BR-specific: Determine if helper text should be shown for line1 number
  /// Helper shows only after CEP lookup success when line1 lacks a valid number or "no number" marker
  bool _shouldShowBrLine1NumberHelper() {
    if (_selectedCountryCode?.toUpperCase() != 'BR') return false;

    final line1Controller = _controllers['line1'];
    if (line1Controller == null) return false;

    final line1Text = line1Controller.text;

    // Helper shows only if:
    // - CEP was looked up this session (primary trigger)
    // - AND line1 does NOT contain a valid number pattern OR "no number" marker
    if (!_didLookupCepThisSession) return false;

    return !_hasBrValidNumberOrNoNumber(line1Text);
  }

  /// Check if line1 contains a BR street number pattern
  /// Pattern rules:
  /// - Comma-number style: ", digits" anywhere after text (e.g., "Rua X, 123")
  /// - Trailing space-number: " digits" at end (e.g., "Rua X 123")
  /// - Optional suffix letters: "123A" is valid
  /// - Does NOT match highway codes like "BR-116" (no comma or trailing pattern)
  bool _hasBrStreetNumberPattern(String value) {
    if (value.trim().isEmpty) return false;

    // Pattern 1: Comma followed by optional space and digits (with optional letter suffix)
    // Matches: "Rua X, 123", "Av. Paulista, 1000A", "Street, 45B"
    final commaPattern = RegExp(r',\s*\d+[A-Za-z]?');
    if (commaPattern.hasMatch(value)) return true;

    // Pattern 2: Trailing space followed by digits (with optional letter suffix) at end
    // Matches: "Rua X 123", "Main St 45A"
    // Must be at the end (not in middle like "BR-116")
    final trailingPattern = RegExp(r'\s+\d+[A-Za-z]?\s*$');
    if (trailingPattern.hasMatch(value)) return true;

    return false;
  }

  /// Check if line1 contains a BR "no number" marker (S/N, SN, sem número, etc.)
  /// Accepts common variations:
  /// - s/n, sn, s/nº, s/n°, s/nº.
  /// - sem numero, sem número
  /// Case-insensitive, allows punctuation and separators (comma, hyphen, space)
  bool _hasBrNoNumberMarker(String value) {
    if (value.trim().isEmpty) return false;

    // Normalize: lowercase, collapse whitespace for matching
    final normalized = value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // Pattern 1: "sem numero" or "sem número" (with or without accent)
    // Matches: "sem numero", "sem número", "sem-numero", "sem, numero"
    final semNumeroPattern = RegExp(r'\bsem\s*[,\-]?\s*n[uú]mero\b');
    if (semNumeroPattern.hasMatch(normalized)) return true;

    // Pattern 2: "s/n", "sn", "s/nº", "s/n°", "s/nº." variations
    // Matches: "s/n", "sn", "s/nº", "s/n°", "s/nº.", "s / n", "s-n"
    // Must be word boundary or after comma/hyphen/space
    final snPattern = RegExp(r'(\b|[,-\s])s\s*[/\\-]?\s*n\s*([º°o]\.?)?\b');
    if (snPattern.hasMatch(normalized)) return true;

    // Pattern 3: Standalone "sn" as a word (not part of another word)
    // Matches: "sn" but not "asn" or "snake"
    final standaloneSnPattern = RegExp(r'\bsn\b');
    if (standaloneSnPattern.hasMatch(normalized)) return true;

    return false;
  }

  /// Combined validator: returns true if line1 has either a street number pattern OR a "no number" marker
  /// This is the single source of truth for BR line1 validation
  bool _hasBrValidNumberOrNoNumber(String value) {
    return _hasBrStreetNumberPattern(value) || _hasBrNoNumberMarker(value);
  }

  /// Normalize BR CEP to digits-only (removes hyphens, spaces, etc.)
  String _normalizeBrCepDigits(String value) {
    return value.replaceAll(RegExp('[^0-9]'), '');
  }

  /// Unified entry point for BR CEP lookup (button or keyboard submit)
  /// Validates CEP length before making API call
  void _onBrCepSubmitOrSearch({required String reason}) {
    if (_selectedCountryCode?.toUpperCase() != 'BR') return;
    if (_isLookingUpCep) return; // Prevent double requests

    final postalController = _controllers['postal_code'];
    if (postalController == null) return;

    final raw = postalController.text;
    final digits = _normalizeBrCepDigits(raw);

    // Validate minimum length (8 digits for BR CEP)
    if (digits.length != 8) {
      _safeSetState(() {
        _fieldErrors['postal_code'] = widget.strings.addressPostalCodeInvalidBrCep;
      }, reason: 'BR CEP invalid length: $reason');
      return;
    }

    // Clear any existing postal_code error before lookup
    _safeSetState(() {
      _fieldErrors.remove('postal_code');
    }, reason: 'Clear postal_code error before CEP lookup: $reason');

    // Trigger actual lookup (will use digits-only internally)
    _lookupCep();
  }

  Future<void> _lookupCep() async {
    if (_selectedCountryCode?.toUpperCase() != 'BR') return;
    if (_schema == null) return;

    final postalController = _controllers['postal_code'];
    if (postalController == null) return;

    final postal = postalController.text;
    final digitsOnly = _normalizeBrCepDigits(postal);

    if (digitsOnly.isEmpty || digitsOnly.length != 8) {
      _safeSetState(() {
        _cepError = widget.strings.addressPostalCodeInvalidBrCep;
      }, reason: 'CEP lookup blocked: invalid postal code length');
      return;
    }

    _safeSetState(() {
      _isLookingUpCep = true;
      _cepError = null;
    }, reason: 'Start CEP lookup');

    try {
      final canonical = await widget.delegate.lookupBrazilZipcode(digitsOnly);

      if (canonical == null) {
        _safeSetState(() {
          _cepError = widget.strings.cepNotFound;
        }, reason: 'CEP lookup returned no canonical');
        return;
      }

      _clearAddressFieldsForSchema();
      _fillFormFromCanonicalAddress(canonical);
      _formatPostalCodeControllerForDisplay(schema: _schema!);

      // BR-specific: Set session flag and clear error flag (no immediate error after CEP)
      _safeSetState(() {
        _didLookupCepThisSession = true;
// Ensure no immediate error
        _fieldErrors.clear();
        // Increment epoch to force helper rebuild
        _helperEpoch.value = _helperEpoch.value + 1;
      }, reason: 'Set CEP session flag and clear errors after CEP fill');

      // BR-specific post-CEP behavior: auto-focus line1 and prepare for number input
      _handlePostCepLine1Behavior();

      // Force a post-frame rebuild to ensure helper text visibility updates
      // after all controller text mutations (including potential ", " append)
      _requestPostFrameRefresh('BR CEP completed');

      _notifyChanged();
    } catch (error) {
      _safeSetState(() {
        _cepError = widget.strings.addressSearchError;
      }, reason: 'CEP lookup failed');
    } finally {
      _safeSetState(() {
        _isLookingUpCep = false;
      }, reason: 'End CEP lookup');
    }
  }

  Future<void> _loadCountries() async {
    _safeSetState(() {
      _isLoadingCountries = true;
    }, reason: 'Start loading countries');

    try {
      final countries = await widget.delegate.fetchAvailableCountries();
      final defaultCode = widget.defaultCountryCode ?? widget.initialValue?.countryCode ?? 'BR';

      // Set default selection: prefer BR if available, otherwise first country
      String? selectedCode = defaultCode;
      if (!countries.contains(defaultCode) && countries.isNotEmpty) {
        selectedCode = countries.first;
      }

      // Sort countries once when loaded (not during build)
      final sortedCountries = List<String>.from(countries)..sort((a, b) => _countryName(a).compareTo(_countryName(b)));

      _safeSetState(() {
        _sortedCountries = sortedCountries;
        _isLoadingCountries = false;
        if (selectedCode != null && selectedCode != _selectedCountryCode) {
          _selectedCountryCode = selectedCode;
          _loadSchema();
        }
      }, reason: 'Update countries and trigger schema load');
    } catch (error) {
      // Fallback to hardcoded list if API fails
      final fallbackCountries = ['BR', 'US', 'PT'];
      final sortedFallback = List<String>.from(fallbackCountries)
        ..sort((a, b) => _countryName(a).compareTo(_countryName(b)));

      _safeSetState(() {
        _sortedCountries = sortedFallback;
        _isLoadingCountries = false;
      }, reason: 'Set fallback countries on load error');
    }
  }

  void _initializeControllers(GrxCanonicalAddressModel address) {
    // Create controllers exactly once - never recreate them after this point
    // This ensures FormFields maintain stable references to their controllers
    if (_controllers.isEmpty) {
      _controllers['line1'] = GrxFormFieldController<String>(text: address.line1 ?? '');
      _controllers['line2'] = GrxFormFieldController<String>(text: address.line2 ?? '');
      _controllers['dependent_locality'] = GrxFormFieldController<String>(text: address.dependentLocality ?? '');
      _controllers['locality'] = GrxFormFieldController<String>(text: address.locality ?? '');
      _controllers['administrative_area'] = GrxFormFieldController<String>(text: address.administrativeArea ?? '');
      _controllers['postal_code'] = GrxFormFieldController<String>(text: address.postalCode ?? '');
    } else {
      // If controllers already exist (e.g., from schema load), update their text instead of recreating
      // This maintains controller instance stability
      _controllers['line1']?.text = address.line1 ?? '';
      _controllers['line2']?.text = address.line2 ?? '';
      _controllers['dependent_locality']?.text = address.dependentLocality ?? '';
      _controllers['locality']?.text = address.locality ?? '';
      _controllers['administrative_area']?.text = address.administrativeArea ?? '';
      _controllers['postal_code']?.text = address.postalCode ?? '';
    }

    // Clear any stale field errors for prefilled valid values
    // This prevents false "Campo inválido" errors when editing existing addresses
    _clearStaleErrorsForPrefilledFields();
  }

  /// Clear field errors for fields that have valid prefilled values
  /// This prevents stale errors from showing "Campo inválido" for valid prefilled fields
  void _clearStaleErrorsForPrefilledFields() {
    final fieldsToClear = <String>[];
    for (final entry in _fieldErrors.entries) {
      final fieldName = entry.key;
      final controller = _controllers[fieldName];
      if (controller != null && controller.text.trim().isNotEmpty) {
        fieldsToClear.add(fieldName);
      }
    }
    if (fieldsToClear.isNotEmpty) {
      for (final fieldName in fieldsToClear) {
        _fieldErrors.remove(fieldName);
      }
    }
  }

  void _cachePostalCodeInputConfig(GrxAddressSchemaModel schema) {
    final postalCodeUi = schema.postalCodeUi;

    if (postalCodeUi == null) {
      _postalCodeKeyboardType = TextInputType.number;
      _postalCodeInputFormatters = [FilteringTextInputFormatter.digitsOnly];
      return;
    }

    if (postalCodeUi.format == 'zip_plus_4') {
      _postalCodeKeyboardType = TextInputType.number;
      _postalCodeInputFormatters = [GrxZipPlus4Formatter()];
      return;
    }

    if (postalCodeUi.mask != null && postalCodeUi.mask!.isNotEmpty) {
      final formatters = <TextInputFormatter>[
        GrxPostalCodeMaskFormatter(mask: postalCodeUi.mask!),
      ];
      final maxLength = postalCodeUi.maxLength;
      if (maxLength != null) {
        formatters.add(LengthLimitingTextInputFormatter(maxLength));
      }
      _postalCodeKeyboardType = TextInputType.number;
      _postalCodeInputFormatters = formatters;
      return;
    }

    if (postalCodeUi.inputType != null) {
      final formatters = <TextInputFormatter>[];
      switch (postalCodeUi.inputType) {
        case 'numeric':
          _postalCodeKeyboardType = TextInputType.number;
          formatters.add(
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
          );
        case 'alphanumeric':
          _postalCodeKeyboardType = TextInputType.text;
          formatters.add(
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
          );
        default:
          _postalCodeKeyboardType = TextInputType.text;
      }
      final maxLength = postalCodeUi.maxLength;
      if (maxLength != null) {
        formatters.add(LengthLimitingTextInputFormatter(maxLength));
      }
      _postalCodeInputFormatters = formatters;
      return;
    }

    final formatters = <TextInputFormatter>[];
    final maxLength = postalCodeUi.maxLength;
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }
    _postalCodeKeyboardType = TextInputType.text;
    _postalCodeInputFormatters = formatters;
  }

  void _formatPostalCodeControllerForDisplay({required GrxAddressSchemaModel schema}) {
    final controller = _controllers['postal_code'];
    if (controller == null) return;

    final raw = controller.text.trim();
    if (raw.isEmpty) return;

    final ui = schema.postalCodeUi;
    if (ui == null) return;

    TextInputFormatter? formatter;
    if (ui.format == 'zip_plus_4') {
      formatter = GrxZipPlus4Formatter();
    } else if (ui.mask != null && ui.mask!.isNotEmpty) {
      formatter = GrxPostalCodeMaskFormatter(mask: ui.mask!);
    }

    if (formatter == null) return;

    final formatted = formatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: raw),
    );

    controller.text = formatted.text;
  }

  Future<void> _loadSchema() async {
    if (_selectedCountryCode == null) return;

    _safeSetState(() {
      _isLoadingSchema = true;
    }, reason: 'Start loading schema');

    try {
      final schema = await widget.delegate.fetchSchema(_selectedCountryCode!);

      // Initialize controllers if not already initialized
      // Exclude country fields from dynamic field rendering (handled by dedicated selector)
      // Normalized schema already filters these, but double-check for safety
      final dynamicFields = schema.order
          .where((field) => field != 'country_code' && field != 'country' && field != 'countryCode')
          .toList();

      if (_controllers.isEmpty) {
        for (final field in dynamicFields) {
          _controllers[field] = GrxFormFieldController<String>();
        }
      } else {
        for (final field in dynamicFields) {
          if (!_controllers.containsKey(field)) {
            _controllers[field] = GrxFormFieldController<String>();
          }
        }
      }

      // Sort subdivisions once when schema is loaded (not during build)
      List<GrxSubdivisionModel>? sortedSubdivisions;
      if (schema.subdivisions != null && schema.subdivisions!.isNotEmpty) {
        sortedSubdivisions = List<GrxSubdivisionModel>.from(schema.subdivisions!)
          ..sort((a, b) {
            final nameA = _subdivisionDisplayName(a.code, a.name);
            final nameB = _subdivisionDisplayName(b.code, b.name);
            return nameA.compareTo(nameB);
          });

        // Normalize legacy admin area codes to ISO 3166-2 format
        final adminAreaController = _controllers['administrative_area'];
        if (adminAreaController != null && _selectedCountryCode != null) {
          final currentValue = adminAreaController.text.trim();
          if (currentValue.isNotEmpty) {
            // Check if already ISO format (contains "-")
            final isAlreadyISO = currentValue.contains('-');

            if (!isAlreadyISO) {
              // Check if it matches any subdivision code exactly
              final matchesExact = sortedSubdivisions.any((s) => s.code == currentValue);

              if (!matchesExact) {
                // Try to convert legacy code (e.g., "RS") to ISO format (e.g., "BR-RS")
                final candidateISO = '$_selectedCountryCode-$currentValue';
                final matchesCandidate = sortedSubdivisions.any((s) => s.code == candidateISO);

                if (matchesCandidate) {
                  // Update controller directly (no setState needed)
                  adminAreaController.text = candidateISO;
                }
              }
            }
          }
        }
      }

      final countryChanged = _schemaCountryWhenControllersCreated != null &&
          schema.countryCode != _schemaCountryWhenControllersCreated;
      final controllersToDispose = <GrxFormFieldController<String>>[];
      _safeSetState(() {
        if (countryChanged) {
          const dependentKeys = [
            'postal_code',
            'administrative_area',
            'locality',
            'dependent_locality',
          ];
          for (final key in dependentKeys) {
            if (_controllers[key] != null) {
              controllersToDispose.add(_controllers[key]!);
              _controllers[key] = GrxFormFieldController<String>();
            }
          }
        }
        _schemaCountryWhenControllersCreated = schema.countryCode;
        _schema = schema;
        _sortedSubdivisions = sortedSubdivisions;
        _isLoadingSchema = false;
        for (final field in schema.order) {
          _fieldErrors.remove(field);
        }
      }, reason: countryChanged ? 'Update schema and recreate dependent controllers' : 'Update schema');
      if (controllersToDispose.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final c in controllersToDispose) {
            c.dispose();
          }
        });
      }

      // Format prefilled postal_code for display after schema load.
      _cachePostalCodeInputConfig(schema);
      _formatPostalCodeControllerForDisplay(schema: schema);

      // Clear stale errors for prefilled fields after formatting
      _clearStaleErrorsForPrefilledFields();

      // Revalidate so postal code and required checks immediately reflect the new schema
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _adminAreaDropdownInitializing = false;
        Form.maybeOf(context)?.validate();
        widget.onSchemaLoaded?.call();
      });
    } catch (error) {
      _safeSetState(() {
        _isLoadingSchema = false;
      }, reason: 'Clear schema loading state on error');
      // Error handling could be improved with snackbar
    }
  }

  void _onCountryChanged(String? countryCode) {
    if (countryCode == _selectedCountryCode) return;

    // Unfocus line1 if it's currently focused (prevents blur handler from executing with old country)
    if (_line1FocusNode.hasFocus) {
      _line1FocusNode.unfocus();
    }

    // Reset all address fields when country changes (except country itself)
    for (final c in _controllers.values) {
      c.text = '';
    }
    _addressSearchController.text = '';

    _safeSetState(() {
      _selectedCountryCode = countryCode;
      _schema = null;
      _sortedSubdivisions = null;
      _fieldErrors.clear();
      _placesSession = null;
      _searchError = null;
      _cepError = null;
      _didLookupCepThisSession = false;
      _line1Touched = false;
      _helperEpoch.value = 0;
      _adminAreaDropdownInitializing = true;
      _addressLat = null;
      _addressLng = null;
      _postalCodeInputFormatters = null;
      _postalCodeKeyboardType = null;
    }, reason: 'Update country and clear form state');

    _loadSchema();
  }

  GrxCanonicalAddressModel _buildAddress() {
    return GrxCanonicalAddressModel(
      countryCode: _selectedCountryCode,
      line1: _controllers['line1']?.text.trim().isEmpty == true ? null : _controllers['line1']?.text.trim(),
      line2: _controllers['line2']?.text.trim().isEmpty == true ? null : _controllers['line2']?.text.trim(),
      dependentLocality: _controllers['dependent_locality']?.text.trim().isEmpty == true
          ? null
          : _controllers['dependent_locality']?.text.trim(),
      locality: _controllers['locality']?.text.trim().isEmpty == true ? null : _controllers['locality']?.text.trim(),
      administrativeArea: _controllers['administrative_area']?.text.trim().isEmpty == true
          ? null
          : _controllers['administrative_area']?.text.trim(),
      postalCode: _controllers['postal_code']?.text.trim().isEmpty == true
          ? null
          : _controllers['postal_code']?.text.trim(),
      lat: _addressLat,
      lng: _addressLng,
    );
  }

  void _notifyChanged() {
    final address = _buildAddress();
    
    // If address is empty and there was an initial value, treat as removal
    // This allows users to clear all fields to remove the address
    // Only treat as removal if allowEmpty is true (otherwise it's just invalid)
    if (widget.allowEmpty && 
        address.isEmpty && 
        widget.initialValue != null && 
        !widget.initialValue!.isEmpty) {
      widget.onChanged?.call(null);
    } else {
      widget.onChanged?.call(address);
    }
  }

  /// Clear all address fields (used for "Remove address" button)
  void _clearAllFields() {
    // Clear controllers immediately (before clearing state)
    // This ensures the dropdown reads empty value on next rebuild
    const canonicalFields = [
      'line1',
      'line2',
      'dependent_locality',
      'locality',
      'administrative_area',
      'postal_code',
    ];

    for (final fieldName in canonicalFields) {
      final controller = _controllers[fieldName];
      if (controller != null) {
        controller.text = '';
      }
    }
    
    // Clear autocomplete search controller
    _addressSearchController.text = '';
    
    // Clear lat/lng and form errors, and reset country
    final defaultCode = widget.defaultCountryCode ?? 'BR';
    final countryChanged = _selectedCountryCode != defaultCode;
    
    // Clear state and reset country immediately
    _safeSetState(() {
      _addressLat = null;
      _addressLng = null;
      _fieldErrors.clear();
      _searchError = null;
      _cepError = null;
      _didLookupCepThisSession = false;
      _line1Touched = false;
      
      // Reset country selection to default
      if (countryChanged) {
        _selectedCountryCode = defaultCode;
      }
    }, reason: 'Clear all fields for address removal');
    
    // If country changed, reload schema (this will trigger rebuild)
    if (countryChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadSchema();
      });
    } else {
      // If country didn't change, force a rebuild to ensure dropdown reflects cleared controller
      // The dropdown reads controller.text during build, so we need to rebuild after clearing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        // Force rebuild so dropdown reads empty controller value
        _safeSetState(() {}, reason: 'Force rebuild after clearing fields');
      });
    }
    
    // Notify that address was removed after clearing (in next frame to ensure UI is updated)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onChanged?.call(null);
    });
  }

  /// Runs required-field validation (same logic as _validateField for required when _isAddressBeingFilled).
  /// Returns false and sets _fieldErrors if any required field is empty. Parent should call this before save.
  bool validateRequiredFields() {
    if (_schema == null) return true;
    if (widget.allowEmpty && _buildAddress().isEmpty) return true;
    if (!_isAddressBeingFilled()) return true;
    bool valid = true;
    final order = _schema!.order
        .where((f) => f != 'country_code' && f != 'country' && f != 'countryCode')
        .toList();
    for (final fieldName in order) {
      if (!_schema!.isFieldRequired(fieldName)) continue;
      final c = _controllers[fieldName];
      final value = c?.text.trim() ?? '';
      if (value.isEmpty) {
        _fieldErrors[fieldName] = widget.strings.invalidField;
        valid = false;
      } else {
        _fieldErrors.remove(fieldName);
      }
    }
    if (!valid && mounted) setState(() {});
    return valid;
  }

  /// Validate address with backend (can be called from parent form)
  /// Flow: Check BR line1 digit rule → Normalize → Validate → Return normalized address if valid
  Future<bool> validate() async {
    final address = _buildAddress();

    if (widget.allowEmpty && address.isEmpty) {
      return true;
    }

    // BR-specific: Before validation, check line1 for valid number/no-number marker and set error flag
    if (_selectedCountryCode?.toUpperCase() == 'BR') {
      final line1Controller = _controllers['line1'];
      final hasValidPattern = line1Controller != null && _hasBrValidNumberOrNoNumber(line1Controller.text);
      _safeSetState(() {
      }, reason: 'Set line1 error flag before save validation');
    }

    _safeSetState(_fieldErrors.clear, reason: 'Clear field errors before validation');

    try {
      final normalizedAddress = await widget.delegate.normalizeAddress(address);

      try {
        await widget.delegate.validateAddress(normalizedAddress);
        if (widget.onSubmit != null) {
          widget.onSubmit?.call(normalizedAddress);
        }
        return true;
      } on GrxAddressValidationException catch (e) {
        _safeSetState(() {
          for (final entry in e.fieldErrors.entries) {
            _fieldErrors[entry.key] =
                entry.value.isNotEmpty ? entry.value.first : null;
          }
        });
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  /// Resolves localized field label from i18n, with fallback to schema or humanized key
  String _fieldLabel(BuildContext context, String fieldKey) {
    // Map schema field keys to i18n keys
    // For line1 and line2, use country-aware labels (BR uses "Endereço"/"Complemento", others use locale-based labels)
    switch (fieldKey) {
      case 'line1':
        // Use country-aware label: BR uses "Endereço", others use locale-based "Street address" / "Dirección"
        return widget.strings.addressLine1Label;
      case 'line2':
        // Use country-aware label: BR uses "Complemento", others use locale-based labels
        return widget.strings.addressLine2Label;
      case 'dependent_locality':
        return widget.strings.dependentLocality;
      case 'locality':
        return widget.strings.locality;
      case 'administrative_area':
        return widget.strings.administrativeArea;
      case 'postal_code':
        return widget.strings.postalCode;
      case 'country_code':
      case 'country':
        return widget.strings.country;
      default:
        // Fallback 1: Try schema labels if available
        if (_schema != null) {
          final schemaLabel = _schema!.getFieldLabel(fieldKey);
          if (schemaLabel != null && schemaLabel.isNotEmpty) {
            return schemaLabel;
          }
        }
        // Fallback 2: Humanize the field key
        return fieldKey
            .split('_')
            .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  /// Resolves localized country name from i18n, with fallback to code
  String _countryName(String code) {
    switch (code.toUpperCase()) {
      case 'BR':
        return widget.strings.countryBR;
      case 'UY':
        return widget.strings.countryUY;
      case 'AR':
        return widget.strings.countryAR;
      case 'PY':
        return widget.strings.countryPY;
      case 'MZ':
        return widget.strings.countryMZ;
      case 'US':
        return widget.strings.countryUS;
      case 'PT':
        return widget.strings.countryPT;
      case 'ES':
        return widget.strings.countryES;
      default:
        return code; // Fallback to code if unknown
    }
  }

  /// Controller key for each address field (must match keys in _controllers, which use schema/snake_case).
  static String _controllerKey(_GrxAddressFormField kind) {
    return switch (kind) {
      _GrxAddressFormField.line1 => 'line1',
      _GrxAddressFormField.line2 => 'line2',
      _GrxAddressFormField.dependentLocality => 'dependent_locality',
      _GrxAddressFormField.locality => 'locality',
      _GrxAddressFormField.administrativeArea => 'administrative_area',
      _GrxAddressFormField.postalCode => 'postal_code',
      _GrxAddressFormField.country => 'country',
      _GrxAddressFormField.unknown => '',
    };
  }

  /// True if any address field (except country) has a non-empty value.
  /// When false, required checks are skipped (no field is required until user starts filling).
  bool _isAddressBeingFilled() {
    const addressFieldKinds = [
      _GrxAddressFormField.line1,
      _GrxAddressFormField.line2,
      _GrxAddressFormField.dependentLocality,
      _GrxAddressFormField.locality,
      _GrxAddressFormField.administrativeArea,
      _GrxAddressFormField.postalCode,
    ];
    for (final fieldKind in addressFieldKinds) {
      final key = _controllerKey(fieldKind);
      final c = _controllers[key];
      if (c != null && c.text.trim().isNotEmpty) return true;
    }
    return false;
  }

  String? _validateField(String fieldName, String? value) {
    if (_schema == null) return null;

    final fieldKind = _GrxAddressFormField.fromNormalizedId(fieldName);
    if (fieldKind == _GrxAddressFormField.country) {
      return null;
    }

    final controller = _controllers[fieldName];
    final actualValue = (controller != null && controller.text.isNotEmpty) ? controller.text : (value ?? '');

    if (fieldKind == _GrxAddressFormField.postalCode && _postalCodeFocusNode.hasFocus) {
      return null;
    }

    if (widget.allowEmpty && _buildAddress().isEmpty) {
      return null;
    }

    // BR line1: enforce number/no-number rule only when field has content; when empty, fall through to required check below so CEP/city/state trigger validation like other countries.
    if (fieldKind == _GrxAddressFormField.line1 && _selectedCountryCode?.toUpperCase() == 'BR') {
      if (actualValue.trim().isNotEmpty) {
        if (!_hasBrValidNumberOrNoNumber(actualValue)) {
          return widget.strings.addressNumberRequired;
        }
      }
    }

    // Required only when address is being filled (any field has value)
    if (_schema!.isFieldRequired(fieldName) && actualValue.trim().isEmpty) {
      if (_isAddressBeingFilled()) {
        return widget.strings.invalidField;
      }
      return null;
    }

    // Check backend field errors
    final backendError = _fieldErrors[fieldName];
    if (backendError != null && backendError.isNotEmpty) {
      return backendError;
    }

    if (fieldKind == _GrxAddressFormField.postalCode && _schema!.postalCodeRule != null) {
      final rule = _schema!.postalCodeRule!;
      if (rule.effectivePatterns.isNotEmpty) {
        final result = _postalCodeValidator.validate(
          input: actualValue,
          rule: rule,
          isRequired: _schema!.isFieldRequired(fieldName),
        );
        if (!result.isValid) {
          return result.errorMessage ?? widget.strings.invalidField;
        }
      }
    }

    return null;
  }

  /// Helper to get display name for subdivision (prefer i18n, fallback to backend name)
  String _subdivisionDisplayName(String code, String fallbackName) {
    // Try to map known codes using R.strings keys
    // Pattern: subdivision{COUNTRY}{CODE} (e.g., subdivisionBRRS for BR-RS)
    // For now, no specific i18n keys exist, so we fallback to backend name
    // This can be extended later if i18n keys are added

    // If fallback name is provided and not empty, use it
    if (fallbackName.isNotEmpty) {
      return fallbackName;
    }

    // If no fallback, return the code itself
    return code;
  }

  Widget _buildField(BuildContext context, String fieldName) {
    if (_schema == null) return const SizedBox.shrink();

    final controller = _controllers[fieldName];
    if (controller == null) return const SizedBox.shrink();

    final label = _fieldLabel(context, fieldName);
    final isRequired = _schema!.isFieldRequired(fieldName);
    final hasError = _fieldErrors.containsKey(fieldName);

    // Special handling for administrative_area: render dropdown if subdivisions exist
    final fieldKind = _GrxAddressFormField.fromNormalizedId(fieldName);
    if (fieldKind == _GrxAddressFormField.administrativeArea &&
        _sortedSubdivisions != null &&
        _sortedSubdivisions!.isNotEmpty) {
      // Use pre-sorted subdivisions (sorted at schema load time, not during build)
      final subdivisions = _sortedSubdivisions!;

      // Get current value (ISO code) from controller and find matching subdivision
      final currentCode = controller.text.trim().isEmpty ? null : controller.text.trim();
      final currentSubdivision = currentCode != null
          ? subdivisions.firstWhere(
              (s) => s.code == currentCode,
              orElse: () => GrxSubdivisionModel(code: currentCode, name: currentCode),
            )
          : null;

      return GrxDropdownFormField<GrxSubdivisionModel>(
        key: _fieldKey(fieldName),
        labelText: label + (isRequired ? ' *' : ''),
        hintText: widget.strings.enterAdministrativeArea,
        selectBottomSheetTitle: label,
        value: currentSubdivision,
        data: subdivisions,
        displayText: (subdivision) => _subdivisionDisplayName(subdivision.code, subdivision.name),
        searchable: true,
        onSelectItem: (subdivision) {
          // Guard: ignore callbacks during dropdown initialization
          if (_adminAreaDropdownInitializing) {
            return;
          }

          if (subdivision != null) {
            // Update controller with ISO code (no setState needed - controller change triggers rebuild)
            controller.text = subdivision.code;

            // Clear field error in microtask if needed (not during init)
            if (hasError) {
              scheduleMicrotask(() {
                if (!mounted) return;
                _safeSetState(() {
                  _fieldErrors.remove(fieldName);
                }, reason: 'Clear field error after admin area selection');
              });
            }

            _notifyChanged();
          }
        },
        enabled: widget.enabled && !_isLoadingSchema,
        isLoading: widget.isLoading || _isLoadingSchema,
        validator: (subdivision) {
          // Guard: validator should not have side effects during init
          if (_adminAreaDropdownInitializing) {
            return null; // Return null during init to avoid validation side effects
          }
          // Extract code from subdivision for validation
          final code = subdivision?.code;
          return _validateField(fieldName, code);
        },
      );
    }

    // Get placeholder text from i18n (example-based)
    String hintText;
    switch (fieldKind) {
      case _GrxAddressFormField.line1:
        hintText = widget.strings.addressLine1Placeholder;
        break;
      case _GrxAddressFormField.line2:
        hintText = widget.strings.addressLine2Placeholder;
        break;
      case _GrxAddressFormField.dependentLocality:
        hintText = widget.strings.addressDependentLocalityPlaceholder;
        break;
      case _GrxAddressFormField.locality:
        hintText = widget.strings.addressLocalityPlaceholder;
        break;
      case _GrxAddressFormField.administrativeArea:
        hintText = widget.strings.addressAdministrativeAreaPlaceholder;
        break;
      case _GrxAddressFormField.postalCode:
        hintText = _schema?.postalCodeUi?.hint ?? widget.strings.addressPostalCodePlaceholder;
        break;
      default:
        hintText = 'Enter $label';
    }

    // Determine keyboard type and input formatters
    TextInputType? keyboardType;
    List<TextInputFormatter>? inputFormatters;

    // Special handling for postal_code based on schema.postalCodeUi
    if (fieldKind == _GrxAddressFormField.postalCode) {
      keyboardType = _postalCodeKeyboardType ?? TextInputType.number;
      inputFormatters = _postalCodeInputFormatters ??
          [FilteringTextInputFormatter.digitsOnly];
    } else if (fieldKind == _GrxAddressFormField.line1 || fieldKind == _GrxAddressFormField.line2) {
      keyboardType = TextInputType.streetAddress;
    } else {
      keyboardType = TextInputType.text;
    }

    // BR-specific: Use focus node for line1 to enable auto-focus after CEP lookup
    final focusNode = switch (fieldKind) {
      _GrxAddressFormField.line1 when _selectedCountryCode?.toUpperCase() == 'BR' =>
        _line1FocusNode,
      _GrxAddressFormField.postalCode => _postalCodeFocusNode,
      _ => null,
    };

    // Use always so every field validates on every change (same behavior as zipcode).
    // Errors update while typing; BR line1 number error remains gated by _showLine1NumberError.

    // BR postal_code: Enable keyboard submit for CEP lookup
    final isBrPostalCode = fieldKind == _GrxAddressFormField.postalCode && _selectedCountryCode?.toUpperCase() == 'BR';

    final fieldKey = _fieldKey(fieldName);

    final field = GrxTextFormField(
      key: fieldKey,
      controller: controller,
      labelText: label + (isRequired ? ' *' : ''),
      hintText: hintText,
      keyboardType: keyboardType,
      textInputAction: isBrPostalCode ? TextInputAction.search : TextInputAction.done,
      showClearButton: fieldKind != _GrxAddressFormField.postalCode,
      validator: (value) {
        // So that when Form.validate() runs after validateRequiredFields(), this field shows the error (same as locality).
        final forced = _fieldErrors[fieldName];
        if (forced != null && forced.isNotEmpty) return forced;
        return _validateField(fieldName, value);
      },
      focusNode: focusNode,
      onFieldSubmitted: isBrPostalCode ? (_) => _onBrCepSubmitOrSearch(reason: 'keyboard_submit') : null,
      onChanged: (_) {
        if (fieldKind == _GrxAddressFormField.postalCode) {
          _fieldErrors.remove('postal_code');
          if (hasError) {
            _fieldErrors.remove(fieldName);
          }
          final hadCepError = _cepError != null;
          _cepError = null;
          _notifyChanged();
          if (hadCepError) {
            _safeSetState(() {}, reason: 'Clear visible CEP lookup error');
          }
          return;
        }

        if (hasError) {
          _safeSetState(() {
            _fieldErrors.remove(fieldName);
          }, reason: 'Clear field error on text change');
        }

        const addressFieldIds = [
          _GrxAddressFormField.line1,
          _GrxAddressFormField.line2,
          _GrxAddressFormField.dependentLocality,
          _GrxAddressFormField.locality,
          _GrxAddressFormField.administrativeArea,
          _GrxAddressFormField.postalCode,
        ];
        if (addressFieldIds.contains(fieldKind) &&
            fieldKind != _GrxAddressFormField.postalCode) {
          _scheduleAddressFieldRevalidation();
        }
        if (fieldKind == _GrxAddressFormField.line1 && _selectedCountryCode?.toUpperCase() == 'BR') {
          final line1Controller = _controllers['line1'];
          if (line1Controller != null && _hasBrValidNumberOrNoNumber(line1Controller.text)) {
            _safeSetState(() {
// Clear error flag
              _fieldErrors.remove('line1'); // Clear any existing error
              // Increment epoch to update helper visibility
              _helperEpoch.value = _helperEpoch.value + 1;
            }, reason: 'Clear BR line1 validation error when valid pattern detected');
          }
        }
        _notifyChanged();
      },
      enabled: widget.enabled && !_isLoadingSchema,
      isLoading: widget.isLoading || _isLoadingSchema,
      inputFormatters: inputFormatters,
    );

    if (fieldKind == _GrxAddressFormField.line1 && _selectedCountryCode?.toUpperCase() == 'BR') {
      // Use ValueListenableBuilder to ensure helper rebuilds when epoch changes
      return ValueListenableBuilder<int>(
        valueListenable: _helperEpoch,
        builder: (context, epoch, child) {
          final showHelper = _shouldShowBrLine1NumberHelper();
          final errorText = _fieldErrors[fieldName];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GrxSpacing.xxs,
            children: [
              field,
              if (showHelper)
                Padding(
                  padding: const EdgeInsets.only(top: GrxSpacing.xxs),
                  child: GrxLabelText(
                    widget.strings.addAddressNumberHelper,
                    color: GrxColors.neutrals.shade600,
                    overflow: TextOverflow.visible,
                  ),
                ),
              if (errorText != null && errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: GrxSpacing.xxs),
                  child: GrxLabelText(
                    errorText,
                    color: GrxColors.error.shade200,
                  ),
                ),
            ],
          );
        },
      );
    }

    if (fieldKind == _GrxAddressFormField.postalCode && _selectedCountryCode?.toUpperCase() == 'BR') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GrxSpacing.s,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GrxSpacing.sm,
            children: [
              Expanded(child: field),
              GrxPrimaryButton(
                key: const Key('address_postal_code_lookup_button'),
                text: widget.strings.searchCep,
                isLoading: _isLookingUpCep,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                enabled: widget.enabled && !_isLoadingSchema && !_isLookingUpCep,
                onPressed: () => _onBrCepSubmitOrSearch(reason: 'button_click'),
              ),
            ],
          ),
          if (_cepError != null)
            GrxLabelText(
              _cepError,
              color: GrxColors.error.shade200,
            ),
        ],
      );
    }

    // Show error below field when _fieldErrors is set (e.g. from validateRequiredFields) so error shows even if Form doesn't run this field's validator (same pattern as _cepError for postal_code).
    final errorText = _fieldErrors[fieldName];
    if (errorText != null && errorText.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GrxSpacing.xxs,
        children: [
          field,
          GrxLabelText(
            errorText,
            color: GrxColors.error.shade200,
          ),
        ],
      );
    }
    return field;
  }

  @override
  Widget build(BuildContext context) {
    if (_schema != null && widget.registerValidate != null) {
      widget.registerValidate!(validateRequiredFields);
    }
    final isBrazil = _selectedCountryCode?.toUpperCase() == 'BR';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        // Country selector (shows localized names, stores codes)
        Builder(
          builder: (context) {
            // Use pre-sorted countries (sorted at load time, not during build)
            final countries = _sortedCountries.isEmpty
                ? ['BR', 'US', 'PT'] // Fallback if not loaded yet
                : _sortedCountries;

            return GrxDropdownFormField<String>(
              labelText: widget.strings.country,
              hintText: widget.strings.enterYourCountry,
              selectBottomSheetTitle: widget.strings.country,
              value: _selectedCountryCode,
              data: countries,
              displayText: _countryName,
              searchable: true,
              onSelectItem: _onCountryChanged,
              enabled: widget.enabled && !_isLoadingSchema && !_isLoadingCountries,
              isLoading: widget.isLoading || _isLoadingSchema || _isLoadingCountries,
            );
          },
        ),

        // Only show fields below when a country is selected
        if (_selectedCountryCode != null) ...[
        // Non-BR: Address autocomplete (primary)
        if (!isBrazil) ...[
          GrxAutocompleteDropdownFormField<GrxAutocompleteItemModel>(
            controller: _addressSearchController,
            labelText: widget.strings.searchAddress,
            hintText: widget.strings.enterAddressSearch,
            displayText: (item) => item.description,
            minChars: 3,
            debounceDuration: const Duration(milliseconds: 300),
            emptyText: widget.strings.noAddressResults,
            isLoading: _isFillingFromAutocomplete,
            loadingStyle: GrxAutocompleteLoadingStyle.suffixSpinner,
            onSearch: _onSearch,
            onSelectItem: _onSuggestionSelected,
            enabled: widget.enabled && _selectedCountryCode != null && !_isLoadingSchema && !_isLoadingCountries,
          ),
          Padding(
            padding: const EdgeInsets.only(top: GrxSpacing.xxs),
            child: GrxLabelText(
              widget.strings.addressSearchHelperText,
              color: GrxColors.neutrals.shade600,
              overflow: TextOverflow.visible,
            ),
          ),
          if (_searchError != null)
            Padding(
              padding: const EdgeInsets.only(top: GrxSpacing.xxs),
              child: GrxLabelText(
                _searchError ?? '',
                overflow: TextOverflow.visible,
                color: GrxColors.error.shade200,
              ),
            ),
        ],

        // "Remove address" button - always visible when allowEmpty; enabled only when there's something to remove
        if (widget.allowEmpty && widget.enabled && !widget.isLoading && !_isLoadingSchema)
          Builder(
            builder: (context) {
              final currentAddress = _buildAddress();
              final hasFilledAddress = !currentAddress.isEmpty;
              return Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: hasFilledAddress ? _clearAllFields : null,
                  icon: Icon(
                    GrxIcons.bin,
                    size: 18,
                    color: hasFilledAddress ? GrxColors.error : GrxColors.neutrals.shade400,
                  ),
                  label: GrxLabelText(
                    widget.strings.removeAddress,
                    color: hasFilledAddress ? GrxColors.error.shade200 : GrxColors.neutrals.shade400,
                    fontWeight: GrxFontWeights.medium,
                  ),
                ),
              );
            },
          ),

        // Dynamic fields based on schema (exclude country fields - handled by dedicated selector).
        // KeyedSubtree with schema epoch forces full subtree recreation on country/schema change
        // so FormField state never sticks (fixes postal_code "always invalid" after country switch).
        if (_schema != null)
          KeyedSubtree(
            key: ValueKey('address_schema_fields_${_schemaEpochKey()}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: _schema!.order
                  .where((field) =>
                      field != 'country_code' && field != 'country' && field != 'countryCode')
                  .map((field) => _buildField(context, field))
                  .toList(),
            ),
          ),

        if (_isLoadingSchema)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(GrxSpacing.s),
              child: CircularProgressIndicator(),
            ),
          ),
        ], // _selectedCountryCode != null
      ],
    );
  }

  @override
  void dispose() {
    _addressRevalidationTimer?.cancel();
    _addressSearchController.dispose();
    _line1FocusNode.dispose();
    _postalCodeFocusNode.dispose();
    _helperEpoch.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

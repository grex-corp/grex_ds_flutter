import '../models/address/grx_address_schema.model.dart';
import '../models/address/grx_autocomplete_item.model.dart';
import '../models/address/grx_canonical_address.model.dart';

/// Thrown by [GrxAddressFormDelegate.validateAddress] when validation fails.
final class GrxAddressValidationException implements Exception {
  final Map<String, List<String>> fieldErrors;

  const GrxAddressValidationException({required this.fieldErrors});

  @override
  String toString() => 'GrxAddressValidationException(fieldErrors: $fieldErrors)';
}

/// Network and backend operations for [GrxAddressForm].
/// Apps provide an implementation; the design system widget never calls HTTP directly.
abstract class GrxAddressFormDelegate {
  const GrxAddressFormDelegate();

  Future<List<String>> fetchAvailableCountries();

  Future<GrxAddressSchemaModel> fetchSchema(String countryCode);

  Future<List<GrxAutocompleteItemModel>> autocomplete({
    required String query,
    required String countryCode,
    String? session,
  });

  Future<GrxCanonicalAddressModel> fetchPlaceDetails({
    required String placeId,
    required String countryCode,
    String? session,
  });

  Future<GrxCanonicalAddressModel?> lookupBrazilZipcode(String digitsOnly);

  Future<GrxCanonicalAddressModel> normalizeAddress(
    GrxCanonicalAddressModel address,
  );

  /// Throws [GrxAddressValidationException] when the address is invalid.
  Future<void> validateAddress(GrxCanonicalAddressModel address);
}

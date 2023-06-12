import '../enums/grx_country_id.enum.dart';

extension GrxCountryIdExtension on GrxCountryId {
  GrxCountryId getValue(String? value) => GrxCountryId.values.firstWhere(
        (id) => id.name.toUpperCase() == value?.toUpperCase(),
        orElse: () => GrxCountryId.unknown,
      );
}

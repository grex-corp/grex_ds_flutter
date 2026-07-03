/// Subdivision model (state/province/region) with ISO 3166-2 code and name.
final class GrxSubdivisionModel {
  final String code;
  final String name;

  const GrxSubdivisionModel({
    required this.code,
    required this.name,
  });

  factory GrxSubdivisionModel.fromMap(Map<String, dynamic> map) {
    final code =
        (map['code'] ?? map['Code'] ?? map['iso_code'] ?? map['isoCode'])
            ?.toString() ??
        '';
    final name =
        (map['name'] ?? map['Name'] ?? map['display_name'] ?? map['displayName'])
            ?.toString() ??
        '';

    if (code.isEmpty) {
      throw ArgumentError('Missing required field: code');
    }

    return GrxSubdivisionModel(
      code: code,
      name: name.isNotEmpty ? name : code,
    );
  }

  Map<String, dynamic> toMap() => {
    'code': code,
    'name': name,
  };
}

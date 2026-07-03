/// Canonical address model matching backend contract.
final class GrxCanonicalAddressModel {
  final int? id;
  final String? countryCode;
  final String? line1;
  final String? line2;
  final String? dependentLocality;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final double? lat;
  final double? lng;
  final int? schemaVersion;
  final DateTime? normalizedAt;

  const GrxCanonicalAddressModel({
    this.id,
    this.countryCode,
    this.line1,
    this.line2,
    this.dependentLocality,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.lat,
    this.lng,
    this.schemaVersion,
    this.normalizedAt,
  });

  factory GrxCanonicalAddressModel.fromMap({required Map<String, dynamic> map}) {
    return GrxCanonicalAddressModel(
      id: _readInt(map, const ['id']),
      countryCode: _readStringLike(map, const ['countryCode']),
      line1: _readStringLike(map, const ['line1']),
      line2: _readStringLike(map, const ['line2']),
      dependentLocality: _readStringLike(map, const ['dependentLocality']),
      locality: _readStringLike(map, const ['locality']),
      administrativeArea: _readStringLike(map, const ['administrativeArea']),
      postalCode: _readStringLike(map, const ['postalCode']),
      lat: _readDouble(map, const ['lat']),
      lng: _readDouble(map, const ['lng']),
      schemaVersion: _readInt(map, const ['schemaVersion']),
      normalizedAt: _readDateTime(map, const ['normalizedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    if (countryCode != null) 'countryCode': countryCode,
    if (line1 != null) 'line1': line1,
    if (line2 != null) 'line2': line2,
    if (dependentLocality != null) 'dependentLocality': dependentLocality,
    if (locality != null) 'locality': locality,
    if (administrativeArea != null) 'administrativeArea': administrativeArea,
    if (postalCode != null) 'postalCode': postalCode,
    if (lat != null) 'lat': lat,
    if (lng != null) 'lng': lng,
    if (schemaVersion != null) 'schemaVersion': schemaVersion,
    if (normalizedAt != null)
      'normalizedAt': normalizedAt!.toUtc().toIso8601String(),
  };

  bool get isEmpty =>
      line1 == null &&
      line2 == null &&
      dependentLocality == null &&
      locality == null &&
      administrativeArea == null &&
      postalCode == null &&
      lat == null &&
      lng == null;

  GrxCanonicalAddressModel copyWith({
    int? id,
    String? countryCode,
    String? line1,
    String? line2,
    String? dependentLocality,
    String? locality,
    String? administrativeArea,
    String? postalCode,
    double? lat,
    double? lng,
    int? schemaVersion,
    DateTime? normalizedAt,
  }) {
    return GrxCanonicalAddressModel(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      dependentLocality: dependentLocality ?? this.dependentLocality,
      locality: locality ?? this.locality,
      administrativeArea: administrativeArea ?? this.administrativeArea,
      postalCode: postalCode ?? this.postalCode,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      normalizedAt: normalizedAt ?? this.normalizedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GrxCanonicalAddressModel &&
        other.id == id &&
        other.countryCode == countryCode &&
        other.line1 == line1 &&
        other.line2 == line2 &&
        other.dependentLocality == dependentLocality &&
        other.locality == locality &&
        other.administrativeArea == administrativeArea &&
        other.postalCode == postalCode &&
        other.lat == lat &&
        other.lng == lng &&
        other.schemaVersion == schemaVersion &&
        other.normalizedAt == normalizedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    countryCode,
    line1,
    line2,
    dependentLocality,
    locality,
    administrativeArea,
    postalCode,
    lat,
    lng,
    schemaVersion,
    normalizedAt,
  );

  String get formattedAddress {
    final parts = <String>[];

    void add(String? value) {
      final v = value?.trim();
      if (v != null && v.isNotEmpty) parts.add(v);
    }

    add(line1);
    add(line2);
    add(dependentLocality);
    add(locality);
    add(administrativeArea);
    add(postalCode);
    add(countryCode);

    return parts.join(', ');
  }

  static Object? _readAny(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key)) return map[key];
    }
    return null;
  }

  static String? _readStringLike(Map<String, dynamic> map, List<String> keys) {
    final value = _readAny(map, keys);
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  static int? _readInt(Map<String, dynamic> map, List<String> keys) {
    final value = _readAny(map, keys);
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _readDouble(Map<String, dynamic> map, List<String> keys) {
    final value = _readAny(map, keys);
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _readDateTime(Map<String, dynamic> map, List<String> keys) {
    final value = _readAny(map, keys);
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

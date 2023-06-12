import 'dart:convert';

import '../enums/grx_country_id.enum.dart';

class GrxCountry {
  const GrxCountry({
    required this.id,
    required this.code,
    required this.name,
    required this.flag,
    this.language,
    this.phoneMasks = const [],
    this.zipcodeMasks = const [],
  });

  final GrxCountryId id;
  final String code;
  final String name;
  final String flag;
  final String? language;
  final List<String> phoneMasks;
  final List<String> zipcodeMasks;

  GrxCountry.fromJson(Map<String, dynamic> json)
      : id = GrxCountryId.unknown.getValue(json['id']),
        code = json['code'],
        name = json['name'],
        flag = json['flag'],
        language = json['language'],
        phoneMasks = json['phoneMasks'] ?? [],
        zipcodeMasks = json['zipcodeMasks'] ?? [];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id.name,
      'code': code,
      'name': name,
      'flag': flag,
      'language': language,
      'phoneMasks': phoneMasks,
      'zipcodeMasks': zipcodeMasks,
    };
  }

  String stringify() => json.encode(toJson());
}

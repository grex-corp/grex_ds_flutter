class GrxFederativeUnit {
  const GrxFederativeUnit({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  GrxFederativeUnit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

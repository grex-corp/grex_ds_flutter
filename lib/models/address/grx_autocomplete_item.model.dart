/// Autocomplete suggestion item model.
final class GrxAutocompleteItemModel {
  final String placeId;
  final String description;
  final String? mainText;
  final String? secondaryText;

  const GrxAutocompleteItemModel({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
  });

  factory GrxAutocompleteItemModel.fromMap({required Map<String, dynamic> map}) {
    final placeId = _getStringValue(map, ['place_id', 'placeId']);
    final description = _getStringValue(
      map,
      ['description', 'full_text', 'text', 'fullText'],
    );
    final mainText = _getStringValue(
      map,
      ['main_text', 'mainText', 'primary_text', 'primaryText'],
      nullable: true,
    );
    final secondaryText = _getStringValue(
      map,
      ['secondary_text', 'secondaryText'],
      nullable: true,
    );

    if (placeId == null || description == null) {
      throw ArgumentError(
        'Missing required fields: placeId=${placeId == null}, '
        'description=${description == null}',
      );
    }

    return GrxAutocompleteItemModel(
      placeId: placeId,
      description: description,
      mainText: mainText,
      secondaryText: secondaryText,
    );
  }

  static String? _getStringValue(
    Map<String, dynamic> map,
    List<String> keys, {
    bool nullable = false,
  }) {
    for (final key in keys) {
      final value = map[key];
      if (value != null) {
        if (value is String) {
          return value;
        } else if (value is num) {
          return value.toString();
        }
      }
    }
    return nullable ? null : throw ArgumentError('No valid key found in $keys');
  }

  Map<String, dynamic> toMap() => {
    'place_id': placeId,
    'description': description,
    if (mainText != null) 'main_text': mainText,
    if (secondaryText != null) 'secondary_text': secondaryText,
  };
}

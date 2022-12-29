import '../enums/parent_worship_type.dart';

extension ParentWorshipTypeExtension on ParentWorshipType {
  String getDescription() {
    String description;

    switch (this) {
      case ParentWorshipType.churchBeliever:
        description = 'Crente da Igreja';
        break;
      case ParentWorshipType.believerOutsideChurch:
        description = 'Crente de Outra Igreja';
        break;
      case ParentWorshipType.nonBeliever:
        description = 'Não Crente';
        break;
      default:
        description = 'Não Definido';
    }

    return description;
  }

  ParentWorshipType getValue(String stringValue) {
    ParentWorshipType value;

    switch (stringValue.toLowerCase().replaceAll('parentworshiptype.', '')) {
      case 'churchbeliever':
        value = ParentWorshipType.churchBeliever;
        break;
      case 'believeroutsidechurch':
        value = ParentWorshipType.believerOutsideChurch;
        break;
      case 'nonbeliever':
        value = ParentWorshipType.nonBeliever;
        break;
      default:
        value = ParentWorshipType.unknown;
    }

    return value;
  }
}

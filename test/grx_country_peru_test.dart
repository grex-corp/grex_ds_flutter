import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/grex_ds.dart';

void main() {
  test(
    'Peru is an operational country with Spanish, postal mask, and departments',
    () {
      final peru = GrxCountryUtils.getCountry(GrxCountryId.PE);

      expect(peru, isNotNull);
      expect(peru!.code, '+51');
      expect(peru.name, 'Peru');
      expect(peru.flag, 'peru_flag');
      expect(peru.language, 'es');
      expect(peru.phoneMasks, ['### ### ###']);
      expect(peru.zipcodeMasks, ['#####']);
      expect(peru.states, hasLength(26));

      final ids = peru.states.map((state) => state.id).toList();
      expect(ids, contains('LIM'));
      expect(ids, contains('LMA'));
      expect(ids, isNot(contains('PE-LIM')));
      expect(peru.states.firstWhere((state) => state.id == 'LIM').name, 'Lima');
      expect(
        peru.states.firstWhere((state) => state.id == 'LMA').name,
        'Municipalidad Metropolitana de Lima',
      );
      expect(
        peru.states.firstWhere((state) => state.id == 'HUC').name,
        'Huánuco',
      );
      expect(
        peru.states.map((state) => state.name),
        isNot(contains('Não Informado')),
      );
    },
  );
}

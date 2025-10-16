import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../../enums/parent_worship_type.dart';
import '../../extensions/string_extension.dart';
import '../../models/knowledge_trail_model.dart';
import '../../models/person.model.dart';
import '../../models/role.model.dart';
import '../../pages/knowledge_trail_select.page.dart';

class FieldsSampleApp extends StatefulWidget {
  const FieldsSampleApp({
    super.key,
    required this.person,
    required this.leaders,
    required this.roles,
  });

  final Person person;
  final List<Person> leaders;
  final List<Role> roles;

  @override
  State<StatefulWidget> createState() => _FieldsSampleAppState();
}

class _FieldsSampleAppState extends State<FieldsSampleApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          GrxTextFormField(
            value: widget.person.name,
            labelText: 'pages.people.name'.translate,
            hintText: 'José Algusto',
            onSaved: (value) => widget.person.name = value!,
            validator:
                (value) =>
                    (value?.isEmpty ?? true) ? 'Insira o nome da pessoa' : null,
            isLoading: _isLoading,
          ),
          GrxPhoneFormField(
            value: widget.person.phone,
            labelText: 'pages.people.phone'.translate,
            onSaved: (value) {
              print('Phone: $value');
              widget.person.phone = value!;
            },
            validator:
                (value) =>
                    (value?.isEmpty ?? true)
                        ? 'Insira o telefone da pessoa'
                        : null,
            isLoading: _isLoading,
          ),
          GrxDateTimePickerFormField(
            value: widget.person.birthDate,
            labelText: 'pages.people.birth-date'.translate,
            // hintText: 'fields.datetime.hint'.translate,
            dialogConfirmText: 'confirm'.translate,
            dialogCancelText: 'cancel'.translate,
            dialogErrorFormatText: 'fields.datetime.error-format'.translate,
            dialogErrorInvalidText: 'fields.datetime.error-invalid'.translate,
            isDateTime: true,
            onSelectItem: (value) => print('Selected birth date: $value'),
            onSaved: (value) {
              print('Saved Birthdate: $value');

              widget.person.birthDate = value;
            },
            // validator: (value) => (value?.isEmpty ?? true)
            //     ? 'Insira a data de nascimento'
            //     : null,
            isLoading: _isLoading,
          ),
          GrxDropdownFormField<Person>(
            value: widget.person.leadership,
            labelText: 'Liderança Direta',
            onSelectItem: (value) => print('Selected Value: ${value?.name}'),
            data: widget.leaders,
            searchable: true,
            itemBuilder:
                (context, index, value) => SizedBox(
                  height: 50,
                  child: Center(
                    child: Row(children: [GrxHeadlineText(value.name)]),
                  ),
                ),
            displayText: (value) => value.name,
            onSaved: (value) {
              print('Saved leader: $value');

              widget.person.leadership = value;
            },
            validator:
                (value) => value == null ? 'O líder deve ser informado' : null,
            isLoading: _isLoading,
          ),
          GrxDropdownFormField<ParentWorshipType>(
            value: widget.person.fatherType,
            labelText: 'O Pai é?',
            onSelectItem: (value) => print('Selected Value: ${value?.name}'),
            data: ParentWorshipType.values,
            displayText: (value) => value.getDescription(),
            onSaved: (value) {
              print('Saved leader: $value');

              widget.person.fatherType = value ?? ParentWorshipType.unknown;
            },
            validator:
                (value) => value == null ? 'O Tipo deve ser informado' : null,
            isLoading: _isLoading,
          ),
          GrxAutocompleteDropdownFormField<ParentWorshipType>(
            value: ParentWorshipType.unknown.getDescription(),
            labelText: 'Rua',
            onSelectItem:
                (value) => print('Selected Value Rua: ${value?.name}'),
            onSearch: (value) async {
              if (value?.isEmpty ?? true) return null;

              await Future.delayed(const Duration(seconds: 2));

              return ParentWorshipType.values
                  .where((element) => element.getDescription().contains(value!))
                  .toList();
            },
            displayText: (value) => value.getDescription(),
            onSaved: (value) {
              print('Saved Street: $value');
            },
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'A rua deve ser informada' : null,
            isLoading: _isLoading,
          ),
          GrxMultiSelectFormField<Role>(
            value: widget.person.roles,
            searchable: true,
            labelText: 'Funções',
            onSelectItems: (value) => print('Selected Value: ${value?.length}'),
            data: widget.roles,
            itemBuilder:
                (context, index, value, onChanged, isSelected) => InkWell(
                  onTap: onChanged,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GrxHeadlineText(value.name),
                          GrxRoundedCheckbox(
                            value: isSelected,
                            radius: 10,
                            onChanged: (_) => onChanged?.call(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            displayText: (value) => value.name,
            valueKey: (person) => person.id,
            onSaved: (value) {
              print('Saved roles: $value');

              widget.person.roles = value!;
            },
            validator:
                (value) =>
                    (value?.isEmpty ?? true)
                        ? 'Ao menos uma função deve ser informada'
                        : null,
            isLoading: _isLoading,
          ),
          GrxCustomDropdownFormField<KnowledgeTrail>(
            value: widget.person.trail,
            labelText: 'Trilho do Vencedor',
            onSelectItem: (value) => print('Selected Value: ${value?.name}'),
            builder:
                (controller, selectedValue) => KnowledgeTrailSelectPage(
                  data: selectedValue,
                  controller: controller,
                ),
            displayText: (value) => value.name,
            onSaved: (value) {
              print('Saved trail: $value');

              widget.person.trail = value;
            },
            // validator: (value) => (value?.isEmpty ?? true)
            //     ? 'O líder deve ser informado'
            //     : null,
            isLoading: _isLoading,
          ),
          GrxDashedDivider(padding: EdgeInsets.symmetric(vertical: 15.0)),
          GrxSwitchFormField(
            value: widget.person.createUser,
            labelText: 'Criar usuário',
            onSaved: (value) => widget.person.createUser = value,
            onChanged: (value) => print('Changed: $value'),
            isLoading: _isLoading,
          ),
          GrxDashedDivider(title: 'Dados Auxiliares'),
          // GrxCheckboxListTile(
          //   title: 'Solteiro',
          //   value: widget.person.single,
          //   isLoading: _isLoading,
          //   onTap: () {
          //     setState(() {
          //       widget.person.single = !widget.person.single;
          //     });
          //   },
          // ),
          // GrxRoundedCheckbox(
          //   value: widget.person.single,
          //   isLoading: _isLoading,
          // ),
        ],
      ),
    );
  }
}

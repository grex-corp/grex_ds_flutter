import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:sample/extensions/string_extension.dart';

import 'enums/parent_worship_type.dart';
import 'models/knowledge_trail_model.dart';
import 'models/person.model.dart';
import 'models/role.model.dart';
import 'pages/knowledge_trail_select.page.dart';

class FieldsSample extends StatefulWidget {
  const FieldsSample({
    super.key,
    required this.person,
    required this.leaders,
    required this.roles,
  });

  final Person person;
  final List<Person> leaders;
  final List<Role> roles;

  @override
  State<StatefulWidget> createState() => _FieldsSampleState();
}

class _FieldsSampleState extends State<FieldsSample> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrxTextFormField(
          initialValue: widget.person.name,
          labelText: 'pages.people.name'.translate,
          hintText: 'José Algusto',
          onSaved: (value) => widget.person.name = value!,
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'Insira o nome da pessoa' : null,
          isLoading: _isLoading,
        ),
        GrxDateTimePickerFormField(
          initialValue: widget.person.birthDate,
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
          initialValue: widget.person.leadership,
          labelText: 'Liderança Direta',
          onSelectItem: (value) => print('Selected Value: ${value?.name}'),
          data: widget.leaders,
          searchable: true,
          itemBuilder: (context, index, value) => SizedBox(
            height: 50,
            child: Center(
              child: Row(
                children: [
                  GrxHeadlineMediumText(value.name),
                ],
              ),
            ),
          ),
          displayText: (value) => value.name,
          onSaved: (value) {
            print('Saved leader: $value');

            widget.person.leadership = value;
          },
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'O líder deve ser informado' : null,
          isLoading: _isLoading,
        ),
        GrxDropdownFormField<ParentWorshipType>(
          initialValue: widget.person.fatherType,
          labelText: 'O Pai é?',
          onSelectItem: (value) => print('Selected Value: ${value?.name}'),
          data: ParentWorshipType.values,
          displayText: (value) => value.getDescription(),
          onSaved: (value) {
            print('Saved leader: $value');

            widget.person.fatherType = value ?? ParentWorshipType.unknown;
          },
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'O Tipo deve ser informado' : null,
          isLoading: _isLoading,
        ),
        GrxMultiSelectFormField<Role>(
          initialValue: widget.person.roles,
          searchable: true,
          labelText: 'Funções',
          onSelectItems: (value) => print('Selected Value: ${value?.length}'),
          data: widget.roles,
          itemBuilder: (context, index, value, onChanged, isSelected) =>
              InkWell(
            onTap: onChanged,
            child: SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GrxHeadlineMediumText(value.name),
                    GrxRoundedCheckbox(
                      initialValue: isSelected,
                      radius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          displayText: (value) => value.name,
          valueKey: (person) => person.id,
          onSaved: (value) => widget.person.roles = value!,
          validator: (value) => (value?.isEmpty ?? true)
              ? 'Ao menos uma função deve ser informada'
              : null,
          isLoading: _isLoading,
        ),
        GrxCustomDropdownFormField<KnowledgeTrail>(
          initialValue: widget.person.trail,
          labelText: 'Trilho do Vencedor',
          onSelectItem: (value) => print('Selected Value: ${value?.name}'),
          builder: (controller, selectedValue) => KnowledgeTrailSelectPage(
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
        const GrxDashedDivider(
          padding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        GrxSwitchFormField(
          initialValue: widget.person.createUser,
          labelText: 'Criar usuário',
          onSaved: (value) => widget.person.createUser = value,
          isLoading: _isLoading,
        ),
        const GrxDashedDivider(
          title: 'Dados Auxiliares',
        ),
        GrxCheckboxListTile(
          title: 'Solteiro',
          isChecked: widget.person.single,
          isLoading: _isLoading,
          onTap: () {
            setState(() {
              widget.person.single = !widget.person.single;
            });
          },
        ),
        GrxRoundedCheckbox(
          initialValue: widget.person.single,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}

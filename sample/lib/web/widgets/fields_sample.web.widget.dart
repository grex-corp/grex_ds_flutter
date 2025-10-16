import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../../extensions/string_extension.dart';
import '../../models/person.model.dart';
import '../../models/role.model.dart';

class FieldsSampleWeb extends StatefulWidget {
  const FieldsSampleWeb({
    super.key,
    required this.person,
    required this.leaders,
    required this.roles,
  });

  final Person person;
  final List<Person> leaders;
  final List<Role> roles;

  @override
  State<StatefulWidget> createState() => _FieldsSampleWebState();
}

class _FieldsSampleWebState extends State<FieldsSampleWeb> {
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            [
                  GrxTextFormField(
                    value: widget.person.name,
                    labelText: 'pages.people.name'.translate,
                    hintText: 'José Algusto',
                    onSaved: (value) => widget.person.name = value!,
                    validator:
                        (value) =>
                            (value?.isEmpty ?? true)
                                ? 'Insira o nome da pessoa'
                                : null,
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
                    dialogErrorFormatText:
                        'fields.datetime.error-format'.translate,
                    dialogErrorInvalidText:
                        'fields.datetime.error-invalid'.translate,
                    isDateTime: true,
                    onSelectItem:
                        (value) => print('Selected birth date: $value'),
                    onSaved: (value) {
                      print('Saved Birthdate: $value');

                      widget.person.birthDate = value;
                    },
                    // validator: (value) => (value?.isEmpty ?? true)
                    //     ? 'Insira a data de nascimento'
                    //     : null,
                    isLoading: _isLoading,
                  ),
                ]
                .map(
                  (child) => Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: child,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

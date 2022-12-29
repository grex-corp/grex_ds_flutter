import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:sample/extensions/string_extension.dart';

import 'enums/parent_worship_type.dart';
import 'localization/app_localizations.dart';
import 'models/knowledge_trail_model.dart';
import 'models/person.model.dart';
import 'models/role.model.dart';
import 'pages/knowledge_trail_select.page.dart';

final _leaders = [
  Person(id: 1, name: '1st Person'),
  Person(id: 2, name: '2nd Person'),
  Person(id: 3, name: '3rd Person'),
  Person(id: 4, name: '4th Person'),
  Person(id: 5, name: '5th Person'),
  Person(id: 6, name: '6th Person'),
  Person(id: 7, name: '7th Person'),
  Person(id: 8, name: '8th Person'),
  Person(id: 9, name: '9th Person'),
  Person(id: 10, name: '10th Person'),
  Person(id: 11, name: '11th Person'),
  Person(id: 12, name: '12th Person'),
  Person(id: 13, name: '13th Person'),
  Person(id: 14, name: '14th Person'),
  Person(id: 15, name: '15th Person'),
  Person(id: 16, name: '16th Person'),
  Person(id: 17, name: '17th Person'),
  Person(id: 18, name: '18th Person'),
  Person(id: 19, name: '19th Person'),
  Person(id: 20, name: '20th Person'),
];

final _roles = [
  Role(id: 1, name: '1st Role', priority: 1),
  Role(id: 2, name: '2nd Role', priority: 2),
  Role(id: 3, name: '3rd Role', priority: 3),
  Role(id: 4, name: '4th Role', priority: 4),
  Role(id: 5, name: '5th Role', priority: 5),
  Role(id: 6, name: '6th Role', priority: 6),
  Role(id: 7, name: '7th Role', priority: 7),
  Role(id: 8, name: '8th Role', priority: 8),
  Role(id: 9, name: '9th Role', priority: 9),
  Role(id: 10, name: '10th Role', priority: 10),
  Role(id: 11, name: '11th Role', priority: 11),
  Role(id: 12, name: '12th Role', priority: 12),
  Role(id: 13, name: '13th Role', priority: 13),
  Role(id: 14, name: '14th Role', priority: 14),
  Role(id: 15, name: '15th Role', priority: 15),
  Role(id: 16, name: '16th Role', priority: 16),
  Role(id: 17, name: '17th Role', priority: 17),
  Role(id: 18, name: '18th Role', priority: 18),
  Role(id: 19, name: '19th Role', priority: 19),
  Role(id: 20, name: '20th Role', priority: 20),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: GrxThemeData.theme,
      localizationsDelegates: const [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late Person person;
  late AnimationController iconAnimationController;
  File? selectedImage;

  @override
  void initState() {
    person = Person(
      id: 22,
      name: 'Leonardo Gabriel',
      birthDate: DateTime.now(),
      leadership: _leaders.first,
      roles: [
        _roles.first,
      ],
    );

    iconAnimationController = AnimationController(
      vsync: this,
      duration: GrxUtils.defaultAnimationDuration,
    );
    iconAnimationController.forward();

    super.initState();
  }

  bool _validateForm() {
    final form = formKey.currentState;

    if (form?.validate() ?? false) {
      form!.save();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const GrxHeadlineLargeText('Healine Large Text'),
                const GrxHeadlineText('Headline Text'),
                const GrxHeadlineMediumText('Headline Medium Text'),
                const GrxHeadlineSmallText('Headline Small Text'),
                const GrxBodyText('Body Text'),
                const GrxCaptionLargeText('Caption Large Text'),
                const GrxCaptionText('Caption Text'),
                const GrxCaptionSmallText('Caption Small Text'),
                const GrxOverlineText('Overline Text'),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GrxTextFormField(
                        initialValue: person.name,
                        labelText: 'pages.people.name'.translate,
                        hintText: 'José Algusto',
                        onSaved: (value) => person.name = value!,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Insira o nome da pessoa'
                            : null,
                      ),
                      GrxDateTimePickerFormField(
                        initialValue: person.birthDate,
                        labelText: 'pages.people.birth-date'.translate,
                        // hintText: 'fields.datetime.hint'.translate,
                        dialogConfirmText: 'confirm'.translate,
                        dialogCancelText: 'cancel'.translate,
                        dialogErrorFormatText:
                            'fields.datetime.error-format'.translate,
                        dialogErrorInvalidText:
                            'fields.datetime.error-invalid'.translate,
                        isDateTime: true,
                        onSelectItem: (value) =>
                            print('Selected birth date: $value'),
                        onSaved: (value) {
                          print('Saved Birthdate: $value');

                          person.birthDate = value;
                        },
                        // validator: (value) => (value?.isEmpty ?? true)
                        //     ? 'Insira a data de nascimento'
                        //     : null,
                      ),
                      GrxDropdownFormField<Person>(
                        initialValue: person.leadership,
                        labelText: 'Liderança Direta',
                        onSelectItem: (value) =>
                            print('Selected Value: ${value?.name}'),
                        data: _leaders,
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

                          person.leadership = value;
                        },
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'O líder deve ser informado'
                            : null,
                      ),
                      GrxDropdownFormField<ParentWorshipType>(
                        initialValue: person.fatherType,
                        labelText: 'O Pai é?',
                        onSelectItem: (value) =>
                            print('Selected Value: ${value?.name}'),
                        data: ParentWorshipType.values,
                        displayText: (value) => value.getDescription(),
                        onSaved: (value) {
                          print('Saved leader: $value');

                          person.fatherType =
                              value ?? ParentWorshipType.unknown;
                        },
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'O Tipo deve ser informado'
                            : null,
                      ),
                      GrxMultiSelectFormField<Role>(
                        initialValue: person.roles,
                        searchable: true,
                        labelText: 'Funções',
                        onSelectItems: (value) =>
                            print('Selected Value: ${value?.length}'),
                        data: _roles,
                        itemBuilder:
                            (context, index, value, onChanged, isSelected) =>
                                InkWell(
                          onTap: onChanged,
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: Row(
                                children: [
                                  GrxHeadlineMediumText(value.name),
                                  isSelected
                                      ? const Icon(
                                          GrxIcons.check,
                                          color: GrxColors.cff1eb35e,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                        ),
                        displayText: (value) => value.name,
                        valueKey: (person) => person.id,
                        onSaved: (value) => person.roles = value!,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Ao menos uma função deve ser informada'
                            : null,
                      ),
                      GrxCustomDropdownFormField<KnowledgeTrail>(
                        initialValue: person.trail,
                        labelText: 'Trilho do Vencedor',
                        onSelectItem: (value) =>
                            print('Selected Value: ${value?.name}'),
                        builder: (controller, selectedValue) =>
                            KnowledgeTrailSelectPage(
                          data: selectedValue,
                          controller: controller,
                        ),
                        displayText: (value) => value.name,
                        onSaved: (value) {
                          print('Saved trail: $value');

                          person.trail = value;
                        },
                        // validator: (value) => (value?.isEmpty ?? true)
                        //     ? 'O líder deve ser informado'
                        //     : null,
                      ),
                      GrxSwitchFormField(
                        initialValue: person.createUser,
                        labelText: 'Criar usuário',
                        onSaved: (value) => person.createUser = value,
                      ),
                      GrxCheckboxListTile(
                        title: 'Solteiro',
                        isChecked: person.single,
                        onTap: () {
                          setState(() {
                            person.single = !person.single;
                          });
                        },
                      ),
                      GrxRoundedCheckbox(
                        initialValue: person.single,
                      ),
                      GrxFloatingActionButton(
                        isLoading: false,
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.close_menu,
                          progress: iconAnimationController,
                          color: GrxColors.cffffffff,
                          size: 30,
                        ),
                        onPressed: () {
                          if (iconAnimationController.isCompleted) {
                            iconAnimationController.reverse();
                          } else {
                            iconAnimationController.forward();
                          }
                        },
                      ),
                      GrxPrimaryButton(
                        text: 'Enviar',
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        icon: GrxIcons.check,
                        onPressed: () {},
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GrxIconButton(
                            icon: GrxIcons.whatsapp,
                            margin:
                                const EdgeInsets.only(bottom: 16, right: 10),
                            onPressed: () {},
                          ),
                          GrxIconButton(
                            icon: GrxIcons.phone,
                            margin: const EdgeInsets.only(bottom: 16),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      GrxTextIconButton(
                        icon: GrxIcons.whatsapp,
                        text: 'WhatsApp',
                        iconSize: 50,
                        margin: const EdgeInsets.only(bottom: 16),
                        onPressed: () {},
                      ),
                      GrxUserAvatar(
                        radius: 40,
                        uri: Uri.parse(
                            'https://firebasestorage.googleapis.com/v0/b/appgrexdb.appspot.com/o/Images%2FPeople%2FWK242KO734Q9nPKThs9B?alt=media&token=e8906f71-58d5-42cb-9184-6f77a6c15694'),
                        heroTag: 4,
                        // openPreview: false,
                        // editable: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GrxUserAvatar(
                        radius: 70,
                        imageFile: selectedImage,
                        uri: Uri.parse(
                            'https://firebasestorage.googleapis.com/v0/b/appgrexdb.appspot.com/o/Images%2FPeople%2FWK242KO734Q9nPKThs9B?alt=media&token=e8906f71-58d5-42cb-9184-6f77a6c15694'),
                        heroTag: 5,
                        // openPreview: false,
                        editable: true,
                        onPickAvatar: (file) async {
                          selectedImage = file;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GrxSecondaryButton(
                        text: 'Cadastrar',
                        mainAxisSize: MainAxisSize.min,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        icon: GrxIcons.person_add_right,
                        onPressed: () {
                          setState(() {
                            person = Person(
                              id: 22,
                              name: 'Pâmela Gabriel',
                              birthDate: DateTime.now(),
                              createUser: true,
                              single: true,
                              leadership: _leaders.last,
                            );
                          });
                        },
                      ),
                      GrxTertiaryButton(
                        text: 'Whatsapp',
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        icon: GrxIcons.whatsapp,
                        iconAlign: GrxAlign.right,
                        foregroundColor: GrxColors.cff1eb35e,
                        onPressed: () {
                          setState(() {
                            _leaders.add(
                              Person(id: 8, name: '8th Person'),
                            );
                          });
                        },
                      ),
                      GrxRoundedButton(
                        textSpan: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Confirmar',
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                width: 5,
                              ),
                            ),
                            TextSpan(
                              text: 'Desligamento',
                              style: GrxHeadlineSmallTextStyle(
                                color: GrxColors.cffef6969,
                              ),
                            )
                          ],
                        ),
                        foregroundColor: GrxColors.cffffffff,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        backgroundColor: GrxColors.cff365278,
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GrxBottomButton(
            text: 'save'.translate,
            icon: GrxIcons.check,
            onPressed: _validateForm,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateForm,
        tooltip: 'Increment',
        child: const Icon(GrxIcons.save_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

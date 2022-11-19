import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:grex_ds/utils/grx_utils.util.dart';
import 'package:sample/extensions/string_extension.dart';

import 'localization/app_localizations.dart';
import 'models/person.model.dart';

final _leaders = [
  Person(id: 1, name: '1st Person'),
  Person(id: 2, name: '2nd Person'),
  Person(id: 3, name: '3rd Person'),
  Person(id: 4, name: '4th Person'),
  Person(id: 5, name: '5th Person'),
  Person(id: 6, name: '6th Person'),
  Person(id: 7, name: '7th Person'),
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

  @override
  void initState() {
    person = Person(
      id: 22,
      name: 'Leonardo Gabriel',
      birthDate: DateTime.now(),
      leadership: _leaders.first,
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
                        hintText: 'fields.datetime.hint'.translate,
                        dialogConfirmText: 'confirm'.translate,
                        dialogCancelText: 'cancel'.translate,
                        dialogErrorFormatText:
                            'fields.datetime.error-format'.translate,
                        dialogErrorInvalidText:
                            'fields.datetime.error-invalid'.translate,
                        isDateTime: true,
                        onSaved: (value) => person.birthDate = value,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Insira a data de nascimento'
                            : null,
                      ),
                      GrxSwitchFormField(
                        initialValue: person.createUser,
                        labelText: 'Criar usuário',
                        onSaved: (value) => person.createUser = value,
                      ),
                      GrxDropdownFormField<Person>(
                        initialValue: person.leadership,
                        labelText: 'Liderança Direta',
                        onSelectItem: (value) =>
                            print('Selected Value: ${value?.name}'),
                        data: _leaders,
                        itemBuilder: (context, index, value) => SizedBox(
                          height: 50,
                          child: GrxHeadlineMediumText(value.name),
                        ),
                        displayText: (value) => value.name,
                        onSaved: (value) => person.leadership = value,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'O líder deve ser informado'
                            : null,
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
                            icon: const Icon(GrxIcons.whatsapp),
                            margin:
                                const EdgeInsets.only(bottom: 16, right: 10),
                            onPressed: () {},
                          ),
                          GrxIconButton(
                            icon: const Icon(GrxIcons.phone),
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
            onPressed: () {},
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

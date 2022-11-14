import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grex_ds/grex_ds.dart';
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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: GrxFontFamilies.montserrat,
        textTheme: const GrxTextTheme(),
      ),
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

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  late Person person;

  @override
  void initState() {
    person = Person(
      id: 22,
      name: 'Leonardo Gabriel',
      birthDate: DateTime.now(),
      leadership: _leaders.first,
    );

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
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const GrxCaptionText(
                        'Alterar Valores',
                        color: GrxColors.cffffffff,
                      ),
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
                    ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(GrxIcons.whatsapp),
                          SizedBox(
                            width: 5,
                          ),
                          GrxCaptionText(
                            'Adicionar Líder',
                            color: GrxColors.cffffffff,
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _leaders.add(
                            Person(id: 8, name: '8th Person'),
                          );
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateForm,
        tooltip: 'Increment',
        child: const Icon(GrxIcons.save_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

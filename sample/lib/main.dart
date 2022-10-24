import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:sample/extensions/string_extension.dart';

import 'localization/app_localizations.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final String title;

  MyHomePage({super.key, required this.title});

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
        title: Text(title),
      ),
      body: Center(
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
            GrxHeadlineLargeText('Healine Large Text'),
            GrxHeadlineText('Headline Text'),
            GrxHeadlineMediumText('Headline Medium Text'),
            GrxHeadlineSmallText('Headline Small Text'),
            GrxBodyText('Body Text'),
            GrxCaptionLargeText('Caption Large Text'),
            GrxCaptionText('Caption Text'),
            GrxCaptionSmallText('Caption Small Text'),
            GrxOverlineText('Overline Text'),
            Form(
              key: formKey,
              child: Column(
                children: [
                  GrxTextFormField(
                    controller: TextEditingController(text: 'Leonardo Gabriel'),
                    labelText: 'pages.people.name'.translate,
                    hintText: 'José Algusto',
                    onSaved: (value) => print('Text Form Field Value: $value'),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Insira o nome da pessoa'
                        : null,
                  ),
                  GrxDateTimePicker(
                    controller: TextEditingController(
                        text: DateTime.now().toIso8601String()),
                    labelText: 'pages.people.birth-date'.translate,
                    hintText: 'fields.datetime.hint'.translate,
                    dialogConfirmText: 'confirm'.translate,
                    dialogCancelText: 'cancel'.translate,
                    dialogErrorFormatText:
                        'fields.datetime.error-format'.translate,
                    dialogErrorInvalidText:
                        'fields.datetime.error-invalid'.translate,
                    isDateTime: true,
                    onSaved: (value) =>
                        print('Is Datetime Value: ${value is DateTime}'),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Insira a data de nascimento'
                        : null,
                  ),
                  GrxSwitchFormField(
                    labelText: 'Alberta Fleming',
                    onSaved: (value) =>
                        print('Switch Form Field Value: $value'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateForm,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../../extensions/string_extension.dart';
import '../../models/person.model.dart';
import '../../models/role.model.dart';
import '../../buttons_sample.widget.dart';
import '../widgets/fields_sample.app.widget.dart';
import '../../typo_sample.widget.dart';

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

class DashboardAppPage extends StatefulWidget {
  const DashboardAppPage({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<StatefulWidget> createState() => _DashboardAppPageState();
}

class _DashboardAppPageState extends State<DashboardAppPage>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late Person person;
  late AnimationController iconAnimationController;
  late final AnimationController animationController;
  File? selectedImage;

  @override
  void initState() {
    person = Person(
      id: 22,
      name: 'Leonardo Gabriel',
      phone: '54992099544',
      birthDate: DateTime.now(),
      leadership: _leaders.first,
      roles: [_roles.first],
    );

    iconAnimationController = AnimationController(
      vsync: this,
      duration: GrxUtils.defaultAnimationDuration,
    );
    iconAnimationController.forward();

    animationController = AnimationController(
      vsync: this,
      duration: GrxUtils.defaultAnimationDuration,
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
      backgroundColor: Colors.white,
      appBar: GrxHeader(
        // Here we take the value from the DashboardAppPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: 'Dashboard Page',
        backgroundColor: GrxColors.primary.shade800,
        foregroundColor: GrxColors.neutrals,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 120,
        ),
        child: Column(
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
                  Icon(GrxIcons.undo),
                  const TypoSample(),
                  ButtonsSample(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        FieldsSampleApp(
                          person: person,
                          leaders: _leaders,
                          roles: _roles,
                        ),
                        GrxCircleButton(
                          isLoading: false,
                          size: 48.0,
                          child: Center(
                            child: AnimatedIcon(
                              icon: AnimatedIcons.close_menu,
                              progress: iconAnimationController,
                              color: GrxColors.neutrals,
                              size: 30,
                            ),
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
                              margin: const EdgeInsets.only(
                                bottom: 16,
                                right: 10,
                              ),
                              size: 30,
                              onPressed: () {},
                            ),
                            GrxIconButton(
                              icon: GrxIcons.phone,
                              margin: const EdgeInsets.only(bottom: 16),
                              size: 30,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        GrxCircleButton(
                          size: 96.0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: GrxColors.primary.shade900,
                          margin: const EdgeInsets.only(bottom: 16),
                          onPressed: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: GrxSpacing.xxs,
                            children: [
                              Icon(
                                GrxIcons.whatsapp,
                                size: 50.0,
                                color: GrxColors.secondary.shade400,
                              ),
                              GrxLabelSmallText('WhatsApp'),
                            ],
                          ),
                        ),
                        GrxUserAvatar(
                          radius: 40,
                          uri: Uri.parse(
                            'https://firebasestorage.googleapis.com/v0/b/appgrexdb.appspot.com/o/Images%2FPeople%2FWK242KO734Q9nPKThs9B?alt=media&token=e8906f71-58d5-42cb-9184-6f77a6c15694',
                          ),
                          heroTag: 4,
                          // openPreview: false,
                          // editable: true,
                          // isLoading: true,
                        ),
                        const SizedBox(height: 16),
                        GrxUserAvatar(
                          radius: 70,
                          imageFile: selectedImage,
                          uri: Uri.parse(
                            'https://firebasestorage.googleapis.com/v0/b/appgrexdb.appspot.com/o/Images%2FPeople%2FWK242KO734Q9nPKThs9B?alt=media&token=e8906f71-58d5-42cb-9184-6f77a6c15694',
                          ),
                          heroTag: 5,
                          // openPreview: false,
                          editable: true,
                          // isLoading: true,
                          onPickAvatar: (file) async {
                            selectedImage = file;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        GrxSecondaryButton(
                          text: 'Cadastrar',
                          margin: const EdgeInsets.symmetric(horizontal: 16),
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

                            GrxToastService.showSuccess(
                              title: 'Nova pessoa criada',
                              message: 'Cadastro realizado com sucesso',
                              context: context,
                            );
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
                          foregroundColor: GrxColors.success.shade300,
                          onPressed: () {
                            setState(() {
                              _leaders.add(Person(id: 8, name: '8th Person'));
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 16.0,
                          children: [
                            GrxSecondaryButton(
                              text: 'Show Error',
                              onPressed:
                                  () => GrxToastService.showError(
                                    title: 'Error message inside error toast',
                                    context: context,
                                  ),
                            ),
                            GrxSecondaryButton(
                              text: 'Show Warning',
                              onPressed:
                                  () => GrxToastService.showWarning(
                                    title:
                                        'Warning message inside warning toast',
                                    context: context,
                                  ),
                            ),
                            GrxSecondaryButton(
                              text: 'Show Success',
                              onPressed:
                                  () => GrxToastService.showSuccess(
                                    title:
                                        'Success message inside success toast',
                                    context: context,
                                  ),
                            ),
                            GrxSecondaryButton(
                              text: 'Show Permanent Warning',
                              onPressed:
                                  () => GrxToastService.showWarning(
                                    title: 'Showing permanent warning toast',
                                    message:
                                        'Adding a subtitle to show how it works',
                                    context: context,
                                    permanent: true,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GrxHeader(
                          title: 'Preview Header',
                          showCloseButton: true,
                        ),
                        GrxHeader(
                          title: 'Preview Header With Back Button',
                          showBackButton: true,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        GrxHeader(
                          title: 'Preview Header With Actions a bit long',
                          height: 70.0,
                          actions: [
                            GrxFilterButton(text: 'Filtros', onPressed: () {}),
                            GrxCircleButton(
                              onPressed: () {},
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(GrxIcons.add, size: 24.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        const GrxSvg('assets/images/sheep.svg'),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(GrxIcons.save_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

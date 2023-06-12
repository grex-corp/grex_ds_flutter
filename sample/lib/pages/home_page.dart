import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:sample/extensions/string_extension.dart';

import '../models/tab_icon_data.model.dart';
import '../widgets/bottom_bar.widget.dart';
import 'cellules_list.page.dart';
import 'dashboard.page.dart';
import 'people_list.page.dart';
import 'settings.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController animationController;

  List<TabIconData> tabIconsList = [
    TabIconData(
      imagePath: 'assets/images/tab_1.png',
      index: 0,
      selectedImagePath: 'assets/images/tab_1s.png',
      isSelected: true,
      name: 'home.tab.dashboard'.translate,
    ),
    TabIconData(
      imagePath: 'assets/images/tab_2.png',
      index: 1,
      selectedImagePath: 'assets/images/tab_2s.png',
      isSelected: false,
      name: 'home.tab.cellules'.translate,
    ),
    TabIconData(
      imagePath: 'assets/images/tab_3.png',
      index: 2,
      selectedImagePath: 'assets/images/tab_3s.png',
      isSelected: false,
      name: 'home.tab.people'.translate,
    ),
    TabIconData(
      imagePath: 'assets/images/tab_4.png',
      index: 3,
      selectedImagePath: 'assets/images/tab_4s.png',
      isSelected: false,
      name: 'home.tab.settings'.translate,
    ),
  ];

  Widget tabBody = Container(
    color: GrxColors.cfff2f7fd,
  );

  @override
  void initState() {
    super.initState();

    for (final tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    tabBody = DashboardPage(
      key: widget.key,
      animationController: animationController,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BottomBarView(
          tabIconsList: tabIconsList,
          onChangeIndex: (int index) {
            try {
              if (index == 0) {
                animationController.reverse().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        DashboardPage(animationController: animationController);
                  });
                });
              } else if (index == 1) {
                animationController.reverse().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody = CellulesListPage(
                        animationController: animationController);
                  });
                });
              } else if (index == 2) {
                animationController.reverse().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody = PeopleListPage(
                        animationController: animationController);
                  });
                });
              } else if (index == 3) {
                animationController.reverse().then((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        SettingsPage(animationController: animationController);
                  });
                });
              }
            } catch (e) {
              rethrow;
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GrxColors.cfff2f7fd,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
  }
}

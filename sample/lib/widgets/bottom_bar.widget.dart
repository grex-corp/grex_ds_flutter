import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../models/tab_icon_data.model.dart';
import 'tab_clipper.widget.dart';
import 'tab_icon.widget.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({
    super.key,
    required this.tabIconsList,
    required this.onChangeIndex,
  });

  final Function(int index) onChangeIndex;
  final List<TabIconData> tabIconsList;

  @override
  createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final AnimationController iconAnimationController;
  bool showMenuDialog = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animationController.forward();

    iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    iconAnimationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    iconAnimationController.dispose();
    super.dispose();
  }

  Widget _roundedButton({
    required String label,
    required String assetImage,
    EdgeInsets? margin,
    Color? bgColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      margin: margin,
      padding: EdgeInsets.all(showMenuDialog ? 20.0 : 0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child:
            showMenuDialog
                ? SizedBox(
                  height: 65,
                  width: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset(assetImage, height: 45),
                      const SizedBox(height: 13),
                      Text(
                        label,
                        // style: menuIconContextText,
                      ),
                    ],
                  ),
                )
                : const SizedBox(height: 0, width: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItem(TabIconData data, int index) => Expanded(
      child: TabIcon(
        tabIconData: data,
        removeAllSelect: () {
          setRemoveAllSelection(data);
          widget.onChangeIndex(index);
        },
      ),
    );

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        // Background color para quando o menu estiver aberto
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showMenuDialog ? 1 : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1),
                end: Alignment(0.0, 0.5),
                colors: <Color>[Colors.transparent, GrxColors.primary.shade300],
              ),
            ),
            height:
                showMenuDialog ? MediaQuery.of(context).size.height / 2 : 10,
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                clipBehavior: Clip.hardEdge,
                color: GrxColors.neutrals,
                elevation: 20.0,
                clipper: TabClipper(
                  radius:
                      Tween<double>(begin: 0.0, end: 1.0)
                          .animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Curves.fastOutSlowIn,
                            ),
                          )
                          .value *
                      40.0,
                ),
                child: SafeArea(
                  top: false,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 75.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                buildItem(widget.tabIconsList[0], 0),
                                buildItem(widget.tabIconsList[1], 1),
                                SizedBox(
                                  width:
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Curves.fastOutSlowIn,
                                            ),
                                          )
                                          .value *
                                      65.0,
                                ),
                                buildItem(widget.tabIconsList[2], 2),
                                buildItem(widget.tabIconsList[3], 3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // AnimatedPositioned(
        //   curve: Curves.easeInOutBack,
        //   duration: const Duration(milliseconds: 300),
        //   bottom: showMenuDialog ? 110 : 50,
        //   left: MediaQuery.of(context).size.width / 2 -
        //       (showMenuDialog ? 125 : 35),
        //   child: SafeArea(
        //     child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           if (showMenuDialog) {
        //             iconAnimationController.forward();
        //           } else {
        //             iconAnimationController.reverse();
        //           }

        //           showMenuDialog = false;
        //         });
        //         Navigator.pushNamed(
        //           context,
        //           '/weekly-reviews-list',
        //         ).then((value) => Get.delete<WeeklyReviewsFilterController>());
        //       },
        //       child: _roundedButton(
        //         buttonLabel: 'weekly-review-short.text'.i18n(),
        //         margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        //         bgColor: white,
        //         assetImage: 'assets/images/semanal.png',
        //       ),
        //     ),
        //   ),
        // ),
        // AnimatedPositioned(
        //   curve: Curves.easeInOutBack,
        //   duration: const Duration(milliseconds: 300),
        //   bottom: showMenuDialog ? 110 : 50,
        //   left: MediaQuery.of(context).size.width / 2 +
        //       (showMenuDialog ? 25 : -35),
        //   child: SafeArea(
        //     child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           if (showMenuDialog) {
        //             iconAnimationController.forward();
        //           } else {
        //             iconAnimationController.reverse();
        //           }

        //           showMenuDialog = false;
        //         });

        //         Navigator.pushNamed(
        //           context,
        //           '/monthly-reviews-list',
        //         ).then((value) => Get.delete<MonthlyReviewsFilterController>());
        //       },
        //       child: _roundedButton(
        //         buttonLabel: 'monthly-review-short.text'.i18n(),
        //         margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        //         bgColor: white,
        //         assetImage: 'assets/images/mensal.png',
        //       ),
        //     ),
        //   ),
        // ),
        // Botão do menu
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 45,
          ),
          child: ScaleTransition(
            alignment: Alignment.center,
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: GrxFloatingActionButton(
              isLoading: false,
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: iconAnimationController,
                color: GrxColors.neutrals,
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
          ),
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      for (final tab in widget.tabIconsList) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      }
    });
  }
}

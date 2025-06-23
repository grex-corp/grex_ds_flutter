import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../models/tab_icon_data.model.dart';

class TabIcon extends StatefulWidget {
  const TabIcon({
    super.key,
    required this.tabIconData,
    required this.removeAllSelect,
  });

  final TabIconData tabIconData;
  final void Function() removeAllSelect;

  @override
  createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcon> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        widget.removeAllSelect();
        widget.tabIconData.animationController!.reverse();
      }
    });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.8, end: 0.9).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData.animationController!,
                        curve: const Interval(
                          0.1,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Image.asset(
                      widget.tabIconData.isSelected
                          ? widget.tabIconData.selectedImagePath
                          : widget.tabIconData.imagePath,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.tabIconData.nameBuilder != null
                            ? widget.tabIconData.nameBuilder!()
                            : widget.tabIconData.name!,
                        // style: menuIconText,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData.animationController!,
                        curve: const Interval(
                          0.2,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: GrxColors.success.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData.animationController!,
                        curve: const Interval(
                          0.5,
                          0.8,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: GrxColors.success.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData.animationController!,
                        curve: const Interval(
                          0.5,
                          0.6,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: GrxColors.success.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

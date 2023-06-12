import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../animations/grx_fade_transition.animation.dart';
import 'headers/grx_searchable_sliver_header.widget.dart';

class GrxSliverAnimatedList<T> extends StatelessWidget {
  const GrxSliverAnimatedList({
    super.key,
    required this.animationController,
    required this.itemBuilder,
    required this.title,
    required this.list,
    this.padding,
  });

  final AnimationController animationController;
  final Widget Function(T item, int index) itemBuilder;
  final String title;
  final Iterable<T> list;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return CustomScrollView(
      slivers: [
        GrxSearchableSliverHeader(
          animationController: animationController,
          title: title,
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            left: this.padding?.left ?? 0,
            top: this.padding?.top ?? 0,
            right: this.padding?.right ?? 0,
            bottom: (this.padding?.bottom ?? 0) + padding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final begin =
                    clampDouble((1 / (list.length / index * 12)) * index, 0, 1);

                final contentAnimation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Interval(
                      begin,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                );

                final item = list.toList()[index];

                return AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return GrxFadeTransition(
                      animation: contentAnimation,
                      child: itemBuilder(item, index),
                    );
                  },
                );
              },
              childCount: list.length,
            ),
          ),
        ),
      ],
    );
  }
}

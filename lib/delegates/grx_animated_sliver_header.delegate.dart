import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../animations/grx_fade_transition.animation.dart';

const double _kToolbarExtent = 60.0;

class GrxAnimatedSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  GrxAnimatedSliverHeaderDelegate({
    required this.animationController,
    required this.builder,
    this.topSafePadding = 0.0,
    this.toolbarExtent,
  });

  final AnimationController animationController;
  final Widget Function(double progress) builder;
  final double topSafePadding;
  final double? toolbarExtent;

  late final Animation<double> topBarAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
    ),
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = clampDouble(shrinkOffset / maxExtent, 0.0, 1.0);

    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
      toolbarOpacity: progress,
      isScrolledUnder: shrinkOffset > maxExtent - minExtent,
      child: AnimatedBuilder(
        animation: animationController,
        child: builder(progress),
        builder: (context, child) {
          return GrxFadeTransition(
            animation: topBarAnimation,
            child: child!,
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => (toolbarExtent ?? _kToolbarExtent) + topSafePadding;

  @override
  double get minExtent => (toolbarExtent ?? _kToolbarExtent) + topSafePadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

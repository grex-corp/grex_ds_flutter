import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/grx_button.util.dart';
import '../widgets/buttons/grx_add_button.widget.dart';
import '../widgets/buttons/grx_filter_button.widget.dart';
import '../widgets/headers/grx_searchable_header.widget.dart';

const double _kToolbarExtent = 60.0;
const double _kFilterFieldExtent = 70.0;
const double _kTotalWidgetExtent = 35.0;

class GrxSearchableSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  const GrxSearchableSliverHeaderDelegate({
    required this.animationController,
    required this.title,
    required this.filterButtonText,
    this.topSafePadding = 0.0,
    this.onFilter,
    this.onAdd,
    this.onQuickSearchHandler,
    this.onTotalWidgetBuilder,
    this.hintText,
    this.canPop = false,
  });

  final AnimationController animationController;
  final String title;
  final String filterButtonText;
  final double topSafePadding;
  final void Function()? onFilter;
  final void Function()? onAdd;
  final void Function(String)? onQuickSearchHandler;
  final Widget Function(double progress)? onTotalWidgetBuilder;
  final String? hintText;
  final bool canPop;

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
      child: GrxSearchableHeader(
        animationController: animationController,
        title: title,
        animationProgress: progress,
        hintText: hintText,
        canPop: canPop,
        actions: [
          if (onFilter != null)
            GrxFilterButton(
              text: filterButtonText,
              height: GrxButtonUtils.buttonAnimationProgressCalc(progress),
              onPressed: onFilter!,
            ),
          if (onAdd != null)
            GrxAddButton(
              margin: const EdgeInsets.only(right: 10.0),
              size: GrxButtonUtils.buttonAnimationProgressCalc(progress),
              onPressed: onAdd!,
            ),
        ],
        onQuickSearchHandler: onQuickSearchHandler,
        extraWidget: onTotalWidgetBuilder?.call(progress),
      ),
    );
  }

  @override
  double get maxExtent =>
      _kToolbarExtent +
      topSafePadding +
      (onQuickSearchHandler != null ? _kFilterFieldExtent : 0) +
      (onTotalWidgetBuilder != null ? _kTotalWidgetExtent : 0);

  @override
  double get minExtent =>
      _kToolbarExtent +
      topSafePadding +
      (onQuickSearchHandler != null ? _kFilterFieldExtent : 0) +
      (onTotalWidgetBuilder != null ? _kTotalWidgetExtent : 0);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

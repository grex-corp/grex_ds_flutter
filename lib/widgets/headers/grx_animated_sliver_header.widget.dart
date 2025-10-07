import 'package:flutter/material.dart';

import '../../delegates/grx_animated_sliver_header.delegate.dart';

class GrxAnimatedSliverHeader extends StatelessWidget {
  const GrxAnimatedSliverHeader({
    super.key,
    required this.animationController,
    required this.builder,
    this.topOffset = 0.0,
  });

  final AnimationController animationController;
  final Widget Function(double progress) builder;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return SliverPersistentHeader(
      delegate: GrxAnimatedSliverHeaderDelegate(
        animationController: animationController,
        builder: builder,
        topSafePadding: padding.top + topOffset,
      ),
      pinned: true,
    );
  }
}

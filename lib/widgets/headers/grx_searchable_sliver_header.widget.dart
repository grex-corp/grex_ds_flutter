import 'package:flutter/material.dart';

import '../../delegates/grx_searchable_sliver_header.delegate.dart';

class GrxSearchableSliverHeader extends StatelessWidget {
  const GrxSearchableSliverHeader({
    super.key,
    required this.animationController,
    required this.title,
    this.onFilter,
    this.onAdd,
    this.onQuickSearchHandler,
    this.totalWidget,
    this.filterButtonText = 'Filtros',
    this.hintText,
    this.canPop = false,
  });

  final AnimationController animationController;
  final String title;
  final void Function()? onFilter;
  final void Function()? onAdd;
  final void Function(String)? onQuickSearchHandler;
  final Widget? totalWidget;
  final String filterButtonText;
  final String? hintText;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return SliverPersistentHeader(
      delegate: GrxSearchableSliverHeaderDelegate(
        animationController: animationController,
        title: title,
        onFilter: onFilter,
        topSafePadding: padding.top,
        onAdd: onAdd,
        onQuickSearchHandler: onQuickSearchHandler,
        filterButtonText: filterButtonText,
        hintText: hintText,
        canPop: canPop,
        onTotalWidgetBuilder: totalWidget != null
            ? (progress) {
                return Opacity(
                  opacity: (1 - progress * 1.5).clamp(0.0, 1.0),
                  child: SizedBox(
                    height: (42.0 - (42.0 * progress * 1.5)).clamp(0.0, 42.0),
                    child: Center(
                      child: totalWidget!,
                    ),
                  ),
                );
              }
            : null,
      ),
      pinned: true,
    );
  }
}

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
    this.filterButtonText = 'Filtros',
    this.hintText,
    this.canPop = false,
  });

  final AnimationController animationController;
  final String title;
  final void Function()? onFilter;
  final void Function()? onAdd;
  final void Function(String)? onQuickSearchHandler;
  final String filterButtonText;
  final String? hintText;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: GrxSearchableSliverHeaderDelegate(
        animationController: animationController,
        title: title,
        onFilter: onFilter,
        onAdd: onAdd,
        onQuickSearchHandler: onQuickSearchHandler,
        filterButtonText: filterButtonText,
        hintText: hintText,
        canPop: canPop,
      ),
      pinned: true,
    );
  }
}

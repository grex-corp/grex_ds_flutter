import 'package:flutter/material.dart';

import '../themes/colors/grx_colors.dart';

class GrxCard extends Card {
  GrxCard({
    super.key,
    super.borderOnForeground,
    super.child,
    super.clipBehavior,
    super.color = GrxColors.neutrals,
    super.elevation = 0.0,
    super.margin,
    super.semanticContainer,
    super.shadowColor,
    super.surfaceTintColor = Colors.transparent,
  }) : super(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8.0),
         ),
       );
}

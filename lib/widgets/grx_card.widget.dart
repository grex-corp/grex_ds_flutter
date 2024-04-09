import 'package:flutter/material.dart';

class GrxCard extends Card {
  GrxCard({
    super.key,
    super.borderOnForeground,
    super.child,
    super.clipBehavior,
    super.color,
    super.elevation,
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

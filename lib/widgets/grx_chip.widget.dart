import 'package:flutter/material.dart';

import '../enums/grx_chip_type.enum.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/spacing/grx_spacing.dart';
import 'typography/grx_label_text.widget.dart';

class GrxChip extends StatelessWidget {
  const GrxChip({super.key, required this.type, this.label, this.builder})
    : assert(
        (type != GrxChipType.custom && label != null) ||
            (type == GrxChipType.custom && builder != null),
      );

  final GrxChipType type;
  final String? label;
  final Widget Function(BuildContext context)? builder;

  Color get backgroundColor => switch (type) {
    GrxChipType.primary => GrxColors.primary,
    GrxChipType.secondary => GrxColors.secondary,
    GrxChipType.success => GrxColors.success,
    GrxChipType.error => GrxColors.error,
    GrxChipType.warning => GrxColors.warning,
    GrxChipType.info => GrxColors.primary.shade50,
    _ => Colors.transparent,
  };

  Color get foregroundColor => switch (type) {
    GrxChipType.primary || GrxChipType.secondary => GrxColors.neutrals,
    GrxChipType.success => GrxColors.success.shade900,
    GrxChipType.error => GrxColors.error.shade300,
    GrxChipType.warning => GrxColors.warning.shade300,
    GrxChipType.info => GrxColors.primary.shade900,
    _ => GrxColors.primary.shade900,
  };

  Color get borderColor => switch (type) {
    GrxChipType.outline => GrxColors.primary,
    GrxChipType.neutral => GrxColors.neutrals.shade1000,
    _ => Colors.transparent,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      color: backgroundColor,
      child:
          type == GrxChipType.custom && builder != null
              ? builder!(context)
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GrxSpacing.sm,
                  vertical: GrxSpacing.xxs,
                ),
                child: GrxLabelText(label, color: foregroundColor),
              ),
    );
  }
}

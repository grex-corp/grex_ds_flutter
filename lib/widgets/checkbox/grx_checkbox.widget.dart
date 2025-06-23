import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../utils/grx_utils.util.dart';

class GrxCheckbox extends StatelessWidget {
  const GrxCheckbox({
    super.key,
    this.value = false,
    this.enabled = true,
    this.isLoading = false,
  });

  final bool value;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final double opacity = enabled && !isLoading ? 255 : 102;

    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: GrxColors.primary.shade50.withValues(alpha: opacity),
        border: Border.all(
          color: GrxColors.neutrals.shade100.withValues(alpha: opacity),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: GrxUtils.defaultAnimationDuration,
          decoration: BoxDecoration(
            color: value ? GrxColors.primary.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }
}

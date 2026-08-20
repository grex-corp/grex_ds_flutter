import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/radius/grx_radius.dart';
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
    return Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        border: Border.all(color: GrxColors.primary, width: 1.0),
        borderRadius: BorderRadius.circular(GrxRadius.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: GrxUtils.defaultAnimationDuration,
          decoration: BoxDecoration(
            color: value ? GrxColors.primary.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(GrxRadius.xs),
          ),
        ),
      ),
    );
  }
}

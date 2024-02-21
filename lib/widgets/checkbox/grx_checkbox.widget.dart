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
    final opacity = enabled && !isLoading ? 1.0 : .4;

    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: GrxColors.cfff9fbfd.withOpacity(opacity),
        border: Border.all(
          color: GrxColors.cffdce2e8.withOpacity(opacity),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: GrxUtils.defaultAnimationDuration,
          decoration: BoxDecoration(
            color: value ? GrxColors.cff289fff : Colors.transparent,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }
}

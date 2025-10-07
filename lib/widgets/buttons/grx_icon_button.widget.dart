import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
import 'grx_circle_button.widget.dart';

class GrxIconButton extends GrxCircleButton {
  GrxIconButton({
    super.key,
    required final IconData icon,
    super.onPressed,
    super.backgroundColor = Colors.transparent,
    super.size = 24.0,
    super.isLoading,
    super.enabled,
    super.margin,
    final Color? foregroundColor,
  }) : super(
         child: Icon(icon, size: size - GrxSpacing.xxs),
         foregroundColor: foregroundColor ?? GrxColors.primary.shade900,
       );
}

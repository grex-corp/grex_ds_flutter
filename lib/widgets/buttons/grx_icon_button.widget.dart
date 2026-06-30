import 'package:flutter/material.dart';

import '../../enums/grx_shape.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
import 'grx_sized_button.widget.dart';

class GrxIconButton extends GrxSizedButton {
  GrxIconButton({
    super.key,
    required final IconData icon,
    super.onPressed,
    super.backgroundColor = Colors.transparent,
    super.size = 24.0,
    super.shape = GrxShape.circle,
    super.isLoading,
    super.enabled,
    super.margin,
    final Color? foregroundColor,
  }) : super(
         child: Icon(icon, size: size - GrxSpacing.xxs),
         foregroundColor: foregroundColor ?? GrxColors.primary.shade900,
       );
}

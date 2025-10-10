import 'package:flutter/painting.dart';

import '../../themes/colors/grx_colors.dart';
import 'grx_rounded_button.widget.dart';

class GrxTertiaryButton extends GrxRoundedButton {
  GrxTertiaryButton({
    super.key,
    required super.text,
    super.transform,
    super.onPressed,
    super.margin,
    super.icon,
    super.iconAlign,
    super.iconSize,
    super.iconColor,
    super.iconPadding,
    super.shape,
    super.isLoading,
    super.textStyle,
    super.mainAxisSize,
    super.enabled,
    super.padding,
    final Color? foregroundColor,
  }) : super(foregroundColor: foregroundColor ?? GrxColors.primary.shade800);
}

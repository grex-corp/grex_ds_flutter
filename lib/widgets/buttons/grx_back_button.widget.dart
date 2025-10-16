import 'package:flutter/painting.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_icon_button.widget.dart';

class GrxBackButton extends GrxIconButton {
  GrxBackButton({
    super.key,
    required super.onPressed,
    super.size,
    super.margin,
    final Color? color,
  }) : super(
         icon: GrxIcons.chevron_left_l,
         foregroundColor: color ?? GrxColors.primary.shade800,
       );
}

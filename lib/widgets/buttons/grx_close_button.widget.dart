import 'package:flutter/painting.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_icon_button.widget.dart';

class GrxCloseButton extends GrxIconButton {
  GrxCloseButton({
    super.key,
    required super.onPressed,
    super.size = 18.0,
    super.margin,
    final Color? color,
  }) : super(
         icon: GrxIcons.close_l,
         foregroundColor: color ?? GrxColors.primary.shade900,
       );
}

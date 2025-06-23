import 'package:flutter/widgets.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_circle_button.widget.dart';

class GrxAddButton extends GrxCircleButton {
  GrxAddButton({
    super.key,
    required super.onPressed,
    super.margin,
    super.size = 48.0,
  }) : super(
         child: Icon(GrxIcons.add, color: GrxColors.secondary.shade500),
         backgroundColor: GrxColors.neutrals,
         foregroundColor: GrxColors.primary.shade800,
         elevation: 5,
         showShadows: true,
       );
}

import 'package:material_ui/material_ui.dart';

import '../themes/colors/grx_colors.dart';

class GrxDivider extends Divider {
  GrxDivider({super.key, super.height, super.thickness = 1, Color? color})
    : super(color: color ?? GrxColors.neutrals.shade200);
}

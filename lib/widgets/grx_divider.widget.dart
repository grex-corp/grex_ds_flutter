import 'package:flutter/material.dart';

import '../themes/colors/grx_colors.dart';

class GrxDivider extends Divider {
  GrxDivider({super.key, super.height, super.thickness = 1, final Color? color})
    : super(color: color ?? GrxColors.neutrals.shade200);
}

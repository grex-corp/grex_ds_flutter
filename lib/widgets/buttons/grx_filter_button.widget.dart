import 'package:flutter/material.dart';

import '../../enums/grx_shape.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_body_text.style.dart';
import 'grx_secondary_button.widget.dart';

class GrxFilterButton extends GrxSecondaryButton {
  GrxFilterButton({
    super.key,
    required super.text,
    super.onPressed,
    super.height = 44.0,
    super.margin,
  }) : super(
         icon: GrxIcons.filter_list,
         mainAxisSize: MainAxisSize.min,
         shape: GrxShape.circle,
         borderColor: GrxColors.neutrals.shade50,
         iconColor: GrxColors.primary,
         foregroundColor: GrxColors.neutrals.shade1000,
         textStyle: GrxBodyTextStyle(),
       );
}

import 'package:flutter/material.dart';

import '../../enums/grx_shape.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_body_text.style.dart';
import '../../themes/typography/styles/grx_title_small_text.style.dart';
import 'grx_rounded_button.widget.dart';

class GrxFilterButton extends GrxRoundedButton {
  GrxFilterButton({
    super.key,
    required super.text,
    super.onPressed,
    super.margin,
    super.enabled,
    super.padding,
    bool hasFiltersApplied = false,
  }) : super(
         icon: GrxIcons.filter_list,
         mainAxisSize: MainAxisSize.min,
         shape: GrxShape.circle,
         borderColor:
             hasFiltersApplied ? GrxColors.primary : GrxColors.neutrals.shade50,
         iconColor: hasFiltersApplied ? GrxColors.neutrals : GrxColors.primary,
         foregroundColor:
             hasFiltersApplied
                 ? GrxColors.neutrals
                 : GrxColors.neutrals.shade1000,
         backgroundColor: hasFiltersApplied ? GrxColors.primary : null,
         textStyle:
             hasFiltersApplied ? GrxTitleSmallTextStyle() : GrxBodyTextStyle(),
       );
}

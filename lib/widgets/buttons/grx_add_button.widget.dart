import 'package:flutter/widgets.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_circle_button.widget.dart';

class GrxAddButton extends GrxCircleButton {
  const GrxAddButton({
    super.key,
    required super.onPressed,
    super.margin,
  }) : super(
          child: const Icon(
            GrxIcons.add,
            color: GrxColors.cff75f3ab,
          ),
          backgroundColor: GrxColors.cffffffff,
          foregroundColor: GrxColors.cff7593b5,
          elevation: 5,
          showShadows: true,
          size: 48.0,
        );
}

import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_circle_button.widget.dart';

class GrxClearInputButton extends GrxCircleButton {
  GrxClearInputButton({super.key, final VoidCallback? onClear})
    : super(
        onPressed: onClear,
        backgroundColor: GrxColors.neutrals.shade50,
        foregroundColor: GrxColors.neutrals.shade900,
        size: 24.0,
        child: Icon(GrxIcons.close_l, size: 10.0),
      );
}

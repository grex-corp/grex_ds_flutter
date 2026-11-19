import 'package:material_ui/material_ui.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_sized_button.widget.dart';

class GrxClearInputButton extends GrxSizedButton {
  GrxClearInputButton({super.key, VoidCallback? onClear})
    : super(
        onPressed: onClear,
        backgroundColor: GrxColors.transparent,
        foregroundColor: GrxColors.neutrals.shade900,
        size: 18.0,
        child: Icon(GrxIcons.close_l, size: 8.0),
      );
}

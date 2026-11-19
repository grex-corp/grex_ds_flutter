import 'package:material_ui/material_ui.dart';

import '../../enums/grx_shape.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
import 'grx_sized_button.widget.dart';

class GrxIconButton extends GrxSizedButton {
  GrxIconButton({
    super.key,
    required IconData icon,
    super.onPressed,
    super.backgroundColor = Colors.transparent,
    super.size = 24.0,
    super.shape = GrxShape.circle,
    super.isLoading,
    super.enabled,
    super.margin,
    double? iconSize,
    Color? foregroundColor,
  }) : super(
         child: Icon(icon, size: iconSize ?? size - GrxSpacing.s),
         foregroundColor: foregroundColor ?? GrxColors.primary.shade900,
       );
}

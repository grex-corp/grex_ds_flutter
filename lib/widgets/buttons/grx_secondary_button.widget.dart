import '../../themes/colors/grx_colors.dart';
import 'grx_rounded_button.widget.dart';

class GrxSecondaryButton extends GrxRoundedButton {
  GrxSecondaryButton({
    super.key,
    required super.text,
    super.transform,
    super.onPressed,
    super.height,
    super.margin,
    super.mainAxisSize,
    super.icon,
    super.iconAlign,
    super.iconSize,
    super.iconColor,
    super.iconPadding,
    super.borderRadius,
  }) : super(
         backgroundColor: GrxColors.neutrals,
         foregroundColor: GrxColors.primary.shade800,
       );
}

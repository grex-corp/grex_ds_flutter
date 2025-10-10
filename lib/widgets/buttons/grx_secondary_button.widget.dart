import '../../themes/colors/grx_colors.dart';
import 'grx_rounded_button.widget.dart';

class GrxSecondaryButton extends GrxRoundedButton {
  const GrxSecondaryButton({
    super.key,
    required super.text,
    super.transform,
    super.onPressed,
    super.margin,
    super.mainAxisSize,
    super.icon,
    super.iconAlign,
    super.iconSize,
    super.iconColor,
    super.iconPadding,
    super.shape,
    super.isLoading,
    super.borderColor = GrxColors.primary,
    super.foregroundColor = GrxColors.primary,
    super.textStyle,
    super.enabled,
    super.padding,
  });
}

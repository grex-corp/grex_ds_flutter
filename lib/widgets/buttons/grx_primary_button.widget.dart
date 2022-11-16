import '../../themes/colors/grx_colors.dart';
import 'grx_rounded_button.widget.dart';

class GrxPrimaryButton extends GrxRoundedButton {
  const GrxPrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.height,
    super.margin,
    super.mainAxisSize,
    super.icon,
    super.iconAlign,
    super.iconSize,
    super.iconColor,
    super.iconPadding,
  }) : super(
          backgroundColor: GrxColors.cff69efa3,
          foregroundColor: GrxColors.cffffffff,
        );
}

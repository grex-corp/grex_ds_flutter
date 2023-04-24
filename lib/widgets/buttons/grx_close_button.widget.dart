import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_icon_button.widget.dart';

class GrxCloseButton extends GrxIconButton {
  const GrxCloseButton({
    super.key,
    required super.onPressed,
    super.color = GrxColors.cff7593b5,
    super.iconSize,
    super.margin,
  }) : super(
          icon: GrxIcons.close,
        );
}

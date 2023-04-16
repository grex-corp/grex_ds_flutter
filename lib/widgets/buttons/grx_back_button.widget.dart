import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import 'grx_icon_button.widget.dart';

class GrxBackButton extends GrxIconButton {
  const GrxBackButton({
    super.key,
    required super.onPressed,
    super.color = GrxColors.cff7593b5,
    super.iconSize,
    super.margin,
  }) : super(
          icon: GrxIcons.arrow_back_ios,
        );
}

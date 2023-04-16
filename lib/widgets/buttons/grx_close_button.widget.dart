import 'package:grex_ds/grex_ds.dart';

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

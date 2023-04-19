import 'package:flutter/material.dart';

import '../../themes/icons/grx_icons.dart';
import 'grx_secondary_button.widget.dart';

class GrxFilterButton extends GrxSecondaryButton {
  const GrxFilterButton({
    super.key,
    required super.text,
    super.onPressed,
    super.height,
    super.margin,
  }) : super(
          icon: GrxIcons.filter_list,
          iconSize: 16.0,
          mainAxisSize: MainAxisSize.min,
        );
}

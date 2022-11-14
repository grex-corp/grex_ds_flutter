import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';

class GrxClearInputButton extends StatelessWidget {
  const GrxClearInputButton({
    super.key,
    required this.onClear,
  });

  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClear,
      child: const Icon(
        GrxIcons.close,
        size: 16,
        color: GrxColors.cff7892b7,
      ),
    );
  }
}

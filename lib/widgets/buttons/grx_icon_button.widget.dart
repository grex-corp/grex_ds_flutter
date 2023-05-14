import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';

class GrxIconButton extends StatelessWidget {
  const GrxIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    this.color = GrxColors.cff75f3ab,
    this.margin,
  });

  final IconData icon;
  final void Function() onPressed;
  final double? iconSize;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: IconButton(
        icon: Icon(
          icon,
          size: iconSize,
        ),
        onPressed: onPressed,
        iconSize: iconSize,
        color: color,
        splashRadius: 22.0,
      ),
    );
  }
}

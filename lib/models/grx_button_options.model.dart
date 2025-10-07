import 'package:flutter/widgets.dart';

import '../themes/colors/grx_colors.dart';

class GrxButtonOptions {
  const GrxButtonOptions({
    required this.title,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor = GrxColors.neutrals,
  });

  final String title;
  final Color foregroundColor;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
}

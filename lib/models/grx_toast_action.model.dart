import 'package:flutter/widgets.dart';

class GrxToastAction {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const GrxToastAction({
    required this.label,
    this.icon,
    required this.onPressed,
  });
}


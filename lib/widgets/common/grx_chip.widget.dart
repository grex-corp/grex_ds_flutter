import 'package:flutter/material.dart';

class GrxChip extends StatelessWidget {
  const GrxChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.contentPadding,
  });

  final Widget label;
  final Color backgroundColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      color: backgroundColor,
      child: Padding(
        padding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
        child: label,
      ),
    );
  }
}

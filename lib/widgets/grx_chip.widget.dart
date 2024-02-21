import 'package:flutter/material.dart';

class GrxChip extends StatelessWidget {
  const GrxChip({
    super.key,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
  }) : assert(
          backgroundColor != Colors.transparent ||
              borderColor != Colors.transparent,
        );

  final Widget label;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(
        side: BorderSide(
          color: borderColor,
        ),
      ),
      color: backgroundColor,
      child: Padding(
        padding: contentPadding,
        child: label,
      ),
    );
  }
}

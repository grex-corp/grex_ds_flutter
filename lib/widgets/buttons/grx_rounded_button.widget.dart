import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import 'grx_button.widget.dart';

class GrxRoundedButton extends StatelessWidget {
  const GrxRoundedButton({
    super.key,
    required this.foregroundColor,
    this.text,
    this.textSpan,
    this.backgroundColor,
    this.onPressed,
    this.margin,
    this.height = 48,
    this.mainAxisSize = MainAxisSize.max,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 20,
    this.iconColor,
    this.iconPadding = 5,
    this.elevation = 5,
  });

  final String? text;
  final InlineSpan? textSpan;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final double height;
  final MainAxisSize mainAxisSize;
  final Color? backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final GrxAlign iconAlign;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return GrxButton(
      text: text,
      textSpan: textSpan,
      onPressed: onPressed,
      margin: margin,
      height: height,
      mainAxisSize: mainAxisSize,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: icon,
      iconAlign: iconAlign,
      iconSize: iconSize,
      iconColor: iconColor,
      iconPadding: iconPadding,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          (height / 2),
        ),
      ),
    );
  }
}

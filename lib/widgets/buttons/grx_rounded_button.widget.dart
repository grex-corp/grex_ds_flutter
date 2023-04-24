import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import 'grx_button.widget.dart';

class GrxRoundedButton extends StatelessWidget {
  const GrxRoundedButton({
    super.key,
    this.text,
    this.textSpan,
    this.transform = GrxTextTransform.none,
    this.onPressed,
    this.margin,
    this.height = 48.0,
    this.mainAxisSize = MainAxisSize.max,
    required this.foregroundColor,
    this.backgroundColor,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 20.0,
    this.iconColor,
    this.iconPadding = 5.0,
    this.elevation = 5.0,
  });

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final double height;
  final MainAxisSize mainAxisSize;
  final Color foregroundColor;
  final Color? backgroundColor;
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
      transform: transform,
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

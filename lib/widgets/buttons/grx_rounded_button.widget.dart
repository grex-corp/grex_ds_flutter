import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_shape.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/spacing/grx_spacing.dart';
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
    this.mainAxisSize = MainAxisSize.min,
    required this.foregroundColor,
    this.backgroundColor,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 20.0,
    this.iconColor,
    this.iconPadding = GrxSpacing.xs,
    this.isLoading = false,
    this.shape = GrxShape.rounded,
    this.borderColor,
    this.textStyle,
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
  final bool isLoading;
  final GrxShape shape;
  final Color? borderColor;
  final TextStyle? textStyle;

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
      isLoading: isLoading,
      shape: shape,
      borderColor: borderColor,
      textStyle: textStyle,
    );
  }
}

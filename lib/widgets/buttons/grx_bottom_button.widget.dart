import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_medium_text.style.dart';
import 'grx_button.widget.dart';

class GrxBottomButton extends StatelessWidget {
  const GrxBottomButton({
    super.key,
    required this.text,
    this.transform = GrxTextTransform.none,
    this.onPressed,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 23,
    this.iconColor,
    this.iconPadding = 5,
  });

  final String text;
  final GrxTextTransform transform;
  final void Function()? onPressed;
  final IconData? icon;
  final GrxAlign iconAlign;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;

  @override
  Widget build(BuildContext context) {
    return GrxButton(
      text: text,
      transform: transform,
      elevation: 0,
      height: null,
      padding: EdgeInsets.only(
        left: 25,
        top: 22,
        right: 25,
        bottom: 22 + MediaQuery.of(context).viewPadding.bottom,
      ),
      backgroundColor: GrxColors.cff69efa3,
      foregroundColor: GrxColors.cffffffff,
      style: const GrxHeadlineMediumTextStyle(),
      icon: icon,
      iconAlign: iconAlign,
      iconSize: iconSize,
      iconColor: iconColor,
      iconPadding: iconPadding,
      onPressed: onPressed,
    );
  }
}

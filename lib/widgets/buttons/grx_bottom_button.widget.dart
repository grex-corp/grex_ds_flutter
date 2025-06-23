import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_text.style.dart';
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
    this.isLoading = false,
  });

  final String text;
  final GrxTextTransform transform;
  final void Function()? onPressed;
  final IconData? icon;
  final GrxAlign iconAlign;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;
  final bool isLoading;

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
        bottom: 22 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      backgroundColor: GrxColors.primary,
      foregroundColor: GrxColors.neutrals,
      style: const GrxHeadlineTextStyle(),
      icon: icon,
      iconAlign: iconAlign,
      iconSize: iconSize,
      iconColor: iconColor,
      iconPadding: iconPadding,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}

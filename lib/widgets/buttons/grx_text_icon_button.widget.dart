import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

class GrxTextIconButton extends StatelessWidget {
  const GrxTextIconButton({
    super.key,
    required this.text,
    required this.icon,
    this.textColor = GrxColors.cff8795a9,
    this.iconSize = 30,
    this.iconColor = GrxColors.cff70efa7,
    this.onPressed,
    this.margin,
  });

  final String text;
  final Color textColor;
  final IconData icon;
  final double? iconSize;
  final Color iconColor;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                GrxCaptionSmallText(
                  text,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

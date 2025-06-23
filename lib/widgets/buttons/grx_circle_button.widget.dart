import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';

class GrxCircleButton extends StatelessWidget {
  const GrxCircleButton({
    super.key,
    required this.child,
    this.size = 44,
    this.backgroundColor = GrxColors.primary,
    this.foregroundColor = GrxColors.neutrals,
    this.border = BorderSide.none,
    this.elevation = 0,
    this.onPressed,
    this.showShadows = false,
    this.isLoading = false,
    this.margin,
  });

  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide border;
  final double elevation;
  final Widget child;
  final void Function()? onPressed;
  final bool showShadows;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SizedBox.fromSize(
        size: Size(size, size),
        child:
            isLoading
                ? Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: border.color,
                      width: border.width,
                    ),
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: GrxColors.neutrals,
                  ),
                )
                : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shadowColor: showShadows ? null : Colors.transparent,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    elevation: elevation,
                    padding: EdgeInsets.zero,
                    disabledBackgroundColor: GrxColors.neutrals.shade500,
                    disabledForegroundColor: GrxColors.neutrals,
                    shape: RoundedRectangleBorder(
                      side: border,
                      borderRadius: BorderRadius.circular(size / 2),
                    ),
                  ),
                  child: child,
                ),
      ),
    );
  }
}

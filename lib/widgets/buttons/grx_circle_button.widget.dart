import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/grx_theme_data.theme.dart';
import '../../themes/typography/styles/grx_title_small_text.style.dart';

class GrxCircleButton extends StatelessWidget {
  const GrxCircleButton({
    super.key,
    required this.child,
    this.size = 44.0,
    this.backgroundColor = GrxColors.primary,
    this.foregroundColor = GrxColors.neutrals,
    this.borderColor,
    this.borderSize = 1.0,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.margin,
  });

  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderSize;
  final Widget child;
  final void Function()? onPressed;
  final bool isLoading;
  final bool enabled;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && !isLoading;
    final backgroundColor =
        enabled
            ? this.backgroundColor
            : this.backgroundColor.withValues(alpha: .6);
    final borderColor =
        enabled ? this.borderColor : this.borderColor?.withValues(alpha: .6);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: enabled && !isLoading ? onPressed : null,
        child: Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            border:
                borderColor != null
                    ? Border.all(color: borderColor, width: borderSize)
                    : null,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child:
              isLoading
                  ? Padding(
                    padding: EdgeInsets.all(clampDouble(8.0, 0.0, size / 2)),
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: GrxColors.neutrals,
                    ),
                  )
                  : IconTheme(
                    data: GrxThemeData.iconTheme.copyWith(
                      color: foregroundColor,
                    ),
                    child: DefaultTextStyle(
                      style: GrxTitleSmallTextStyle(color: foregroundColor),
                      child: child,
                    ),
                  ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../enums/grx_shape.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/grx_theme_data.theme.dart';
import '../../themes/radius/grx_radius.dart';
import '../../themes/typography/styles/grx_title_small_text.style.dart';

class GrxSizedButton extends StatelessWidget {
  const GrxSizedButton({
    super.key,
    required this.child,
    this.size = 44.0,
    this.shape = GrxShape.circle,
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
  final GrxShape shape;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderSize;
  final Widget child;
  final void Function()? onPressed;
  final bool isLoading;
  final bool enabled;
  final EdgeInsetsGeometry? margin;

  double _borderRadius() {
    switch (shape) {
      case GrxShape.circle:
        return size / 2;
      case GrxShape.rounded:
      case GrxShape.square:
        return GrxRadius.xs;
      case GrxShape.sharp:
        return GrxRadius.sharp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && !isLoading;
    final backgroundColor = enabled
        ? this.backgroundColor
        : _disabledColor(this.backgroundColor, alpha: 0.6);
    final foregroundColor = enabled
        ? this.foregroundColor
        : _disabledColor(this.foregroundColor, alpha: 0.4);
    final borderColor = enabled
        ? this.borderColor
        : this.borderColor == null
            ? null
            : _disabledColor(this.borderColor!, alpha: 0.6);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: enabled ? onPressed : null,
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
            borderRadius: BorderRadius.circular(_borderRadius()),
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

  /// Keeps fully transparent colors transparent. Applying alpha to
  /// [Colors.transparent] would otherwise paint a semi-opaque black fill.
  Color _disabledColor(Color color, {required double alpha}) {
    if (color.a == 0) return color;
    return color.withValues(alpha: alpha);
  }
}

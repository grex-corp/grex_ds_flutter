import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_shape.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/radius/grx_radius.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../../themes/typography/styles/grx_title_small_text.style.dart';
import '../typography/grx_text.widget.dart';

class GrxButton extends StatefulWidget {
  const GrxButton({
    super.key,
    required this.foregroundColor,
    this.text,
    this.textSpan,
    this.transform = GrxTextTransform.none,
    this.backgroundColor,
    this.onPressed,
    this.margin,
    this.height = 48.0,
    this.mainAxisSize = MainAxisSize.max,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 20.0,
    this.iconColor,
    this.iconPadding = GrxSpacing.xs,
    this.shape = GrxShape.rounded,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
    this.style,
    this.borderColor,
    this.textStyle,
    this.isLoading = false,
    this.enabled = true,
  }) : assert(text != null || textSpan != null);

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final double? height;
  final MainAxisSize mainAxisSize;
  final Color? backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final GrxAlign iconAlign;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;
  final GrxShape shape;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;
  final Color? borderColor;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool enabled;

  @override
  State<GrxButton> createState() => _GrxButtonState();
}

class _GrxButtonState extends State<GrxButton> {
  Size? childSize;

  Widget _getButton({required final Widget child}) {
    final onPressed =
        widget.enabled && !widget.isLoading ? widget.onPressed : null;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: child,
    );
  }

  double _getBorderRadius() {
    switch (widget.shape) {
      case GrxShape.rounded:
        return GrxRadius.xs;
      case GrxShape.circle:
        return GrxRadius.round;
      case GrxShape.square:
        return GrxRadius.xs;
      default:
        return GrxRadius.sharp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        widget.enabled && !widget.isLoading
            ? widget.foregroundColor
            : widget.foregroundColor.withValues(alpha: 0.70);

    final backgroundColor =
        widget.enabled && !widget.isLoading
            ? widget.backgroundColor
            : widget.backgroundColor?.withValues(alpha: 0.60);

    final borderColor =
        widget.enabled && !widget.isLoading
            ? widget.borderColor
            : widget.borderColor?.withValues(alpha: 0.60);

    final textStyle =
        widget.textStyle?.copyWith(color: foregroundColor) ??
        GrxTitleSmallTextStyle(color: foregroundColor);

    final children = <Widget>[
      if (widget.icon != null)
        Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.iconColor ?? widget.foregroundColor,
        ),
      Flexible(
        child:
            widget.textSpan != null
                ? GrxText.rich(
                  widget.textSpan,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  transform: widget.transform,
                )
                : GrxText(
                  widget.text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  transform: widget.transform,
                ),
      ),
    ];

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: _getButton(
        child: Container(
          padding: widget.padding,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: borderColor != null ? Border.all(color: borderColor) : null,
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          child: Row(
            mainAxisSize: widget.mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: widget.iconPadding,
            children: [
              if (widget.isLoading)
                SizedBox.square(
                  dimension: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

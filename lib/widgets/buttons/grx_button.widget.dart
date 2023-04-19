import 'package:flutter/material.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_small_text.style.dart';
import '../typography/grx_text.widget.dart';

class GrxButton extends StatelessWidget {
  const GrxButton({
    super.key,
    required this.foregroundColor,
    this.text,
    this.textSpan,
    this.transform = GrxTextTransform.none,
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
    this.shape,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    this.style,
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
  final double elevation;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;

  Widget _createWidgetIcon() {
    final iconAlignLeft = iconAlign == GrxAlign.left;

    return Visibility(
      visible: icon != null,
      child: Padding(
        padding: EdgeInsets.only(
            left: iconAlignLeft ? 0 : iconPadding,
            right: iconAlignLeft ? iconPadding : 0),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? foregroundColor,
        ),
      ),
    );
  }

  ButtonStyleButton _getButton({
    required final Widget child,
    required final ButtonStyle style,
  }) =>
      backgroundColor != null
          ? ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: child,
            )
          : TextButton(
              onPressed: onPressed,
              style: style,
              child: child,
            );

  @override
  Widget build(BuildContext context) {
    final isTextButton = backgroundColor == null;
    final children = <Widget>[
      _createWidgetIcon(),
      Flexible(
        child: textSpan != null
            ? GrxText.rich(
                textSpan,
                style: (style ?? const GrxHeadlineSmallTextStyle())
                    .copyWith(color: foregroundColor),
                textAlign: TextAlign.center,
                transform: transform,
              )
            : GrxText(
                text,
                style: (style ?? const GrxHeadlineSmallTextStyle())
                    .copyWith(color: foregroundColor),
                textAlign: TextAlign.center,
                transform: transform,
              ),
      ),
    ];

    return Container(
      margin: margin,
      height: height,
      child: _getButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: GrxColors.cff7593b5,
          elevation: isTextButton ? null : elevation,
          padding: padding,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: isTextButton
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.12)
              : null,
          shape: shape,
        ),
        child: Row(
          mainAxisSize: isTextButton ? MainAxisSize.min : mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconAlign == GrxAlign.left
              ? children
              : children.reversed.toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_display_small_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by Small titles
///
/// Sets [GrxDisplaySmallTextStyle] as [style] default value.
class GrxDisplaySmallText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxDisplaySmallText(
    this.text, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.shouldLinkify = false,
  }) : textSpan = null,
       style = null;

  const GrxDisplaySmallText.rich(
    this.textSpan, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.shouldLinkify = false,
  }) : text = null,
       style = null;

  GrxDisplaySmallText.lerp(
    this.text, {
    super.key,
    required final GrxDisplaySmallTextStyle style,
    required final double t,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.shouldLinkify = false,
  }) : textSpan = null,
       style =
           TextStyle.lerp(
             GrxDisplaySmallTextStyle(
               color: color,
               decoration: decoration,
               overflow: overflow,
               fontWeight: fontWeight,
             ),
             style,
             t,
           )!;

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final bool isLoading;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool shouldLinkify;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? GrxColors.neutrals.shade1000;

    final style =
        this.style ??
        GrxDisplaySmallTextStyle(
          color: color,
          decoration: decoration,
          overflow: overflow,
          fontWeight: fontWeight,
        );

    return textSpan != null
        ? GrxText.rich(
          textSpan,
          transform: transform,
          textAlign: textAlign,
          style: style,
          isLoading: isLoading,
          strutStyle: strutStyle,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
          shouldLinkify: shouldLinkify,
        )
        : GrxText(
          text,
          transform: transform,
          textAlign: textAlign,
          style: style,
          isLoading: isLoading,
          strutStyle: strutStyle,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
          shouldLinkify: shouldLinkify,
        );
  }
}

import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_large_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by large titles
///
/// Sets [GrxHeadlineLargeTextStyle] as [style] default value.
class GrxHeadlineLargeText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxHeadlineLargeText(
    this.text, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
  }) : textSpan = null,
       style = null;

  const GrxHeadlineLargeText.rich(
    this.textSpan, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
  }) : text = null,
       style = null;

  GrxHeadlineLargeText.lerp(
    this.text, {
    super.key,
    required final GrxHeadlineLargeTextStyle style,
    required final double t,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
  }) : textSpan = null,
       style =
           TextStyle.lerp(
             GrxHeadlineLargeTextStyle(
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

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? GrxColors.neutrals.shade1000;

    final style =
        this.style ??
        GrxHeadlineLargeTextStyle(
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
        )
        : GrxText(
          text,
          transform: transform,
          textAlign: textAlign,
          style: style,
          isLoading: isLoading,
        );
  }
}

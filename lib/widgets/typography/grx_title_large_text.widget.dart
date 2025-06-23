import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_title_large_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by normal titles
///
/// Sets [GrxTitleLargeTextStyle] as [style] default value.
class GrxTitleLargeText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxTitleLargeText(
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

  const GrxTitleLargeText.rich(
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

  GrxTitleLargeText.lerp(
    this.text, {
    super.key,
    required final GrxTitleLargeTextStyle style,
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
             GrxTitleLargeTextStyle(
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
        GrxTitleLargeTextStyle(
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

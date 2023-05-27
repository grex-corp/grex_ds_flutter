import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_small_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by small titles
///
/// Sets [GrxHeadlineSmallTextStyle] as [style] default value.
class GrxHeadlineSmallText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxHeadlineSmallText(
    this.text, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color = GrxColors.cff2e2e2e,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
  }) : textSpan = null;

  const GrxHeadlineSmallText.rich(
    this.textSpan, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color = GrxColors.cff2e2e2e,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.isLoading = false,
  }) : text = null;

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final TextAlign? textAlign;
  final Color color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final style = GrxHeadlineSmallTextStyle(
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

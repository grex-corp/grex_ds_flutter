import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by normal titles
///
/// Sets [GrxHeadlineStyle] as [style] default value.
class GrxHeadlineText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxHeadlineText(
    this.text, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color = GrxColors.cff2e2e2e,
    this.decoration,
    this.overflow,
  }) : textSpan = null;

  const GrxHeadlineText.rich(
    this.textSpan, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color = GrxColors.cff2e2e2e,
    this.decoration,
    this.overflow,
  }) : text = null;

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final TextAlign? textAlign;
  final Color color;
  final TextDecoration? decoration;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final style = GrxHeadlineStyle(
      color: color,
      decoration: decoration,
      overflow: overflow,
    );

    return textSpan != null
        ? GrxText.rich(
            textSpan,
            transform: transform,
            textAlign: textAlign,
            style: style,
          )
        : GrxText(
            text,
            transform: transform,
            textAlign: textAlign,
            style: style,
          );
  }
}

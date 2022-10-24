import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_large.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by large titles
///
/// Sets [GrxHeadlineLargeStyle] as [style] default value.
class GrxHeadlineLargeText extends GrxText {
  /// Creates a Design System's [Text].
  GrxHeadlineLargeText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxHeadlineLargeStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

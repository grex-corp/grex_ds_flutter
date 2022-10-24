import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by normal titles
///
/// Sets [GrxHeadlineStyle] as [style] default value.
class GrxHeadlineText extends GrxText {
  /// Creates a Design System's [Text].
  GrxHeadlineText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxHeadlineStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

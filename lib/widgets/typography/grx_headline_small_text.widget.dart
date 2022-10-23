import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_small.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by small titles
///
/// Sets [GrxHeadlineSmallStyle] as [style] default value.
class GrxHeadlineSmallText extends GrxText {
  /// Creates a Design System's [Text].
  GrxHeadlineSmallText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.c2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxHeadlineSmallStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

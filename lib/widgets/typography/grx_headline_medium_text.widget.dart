import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_medium.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by medium titles
///
/// Sets [GrxHeadlineMediumStyle] as [style] default value.
class GrxHeadlineMediumText extends GrxText {
  /// Creates a Design System's [Text].
  GrxHeadlineMediumText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxHeadlineMediumStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

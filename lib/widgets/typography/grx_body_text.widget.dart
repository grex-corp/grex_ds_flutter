import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_body_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by body texts
///
/// Sets [GrxBodyTextStyle] as [style] default value.
class GrxBodyText extends GrxText {
  /// Creates a Design System's [Text].
  GrxBodyText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.c2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxBodyTextStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

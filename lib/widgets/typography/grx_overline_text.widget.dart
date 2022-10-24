import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_overline_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by extra small texts
///
/// Sets [GrxOverlineTextStyle] as [style] default value.
class GrxOverlineText extends GrxText {
  /// Creates a Design System's [Text].
  GrxOverlineText(
    super.data, {
    super.key,
    super.textAlign,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
    final GrxTextTransform transform = GrxTextTransform.uppercase,
  }) : super(
          style: GrxOverlineTextStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
          transform: transform,
        );
}

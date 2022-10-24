import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by normal captions.
///
/// Sets [GrxCaptionTextStyle] as [style] default value.
class GrxCaptionText extends GrxText {
  /// Creates a Design System's [Text].
  GrxCaptionText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxCaptionTextStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

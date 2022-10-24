import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_small_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by small captions
///
/// Sets [GrxCaptionSmallTextStyle] as [style] default value.
class GrxCaptionSmallText extends GrxText {
  /// Creates a Design System's [Text].
  GrxCaptionSmallText(
    super.data, {
    super.key,
    super.textAlign,
    super.transform,
    final Color color = GrxColors.cff2e2e2e,
    final TextDecoration? decoration,
    final TextOverflow? overflow,
  }) : super(
          style: GrxCaptionSmallTextStyle(
            color: color,
            decoration: decoration,
            overflow: overflow,
          ),
        );
}

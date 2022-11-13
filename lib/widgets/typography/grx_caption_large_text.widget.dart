import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by large captions
///
/// Sets [GrxCaptionLargeTextStyle] as [style] default value.
class GrxCaptionLargeText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxCaptionLargeText(
    this.data, {
    super.key,
    this.textAlign,
    this.transform = GrxTextTransform.none,
    this.color = GrxColors.cff2e2e2e,
    this.decoration,
    this.overflow,
  });

  final String data;
  final GrxTextTransform transform;
  final TextAlign? textAlign;
  final Color color;
  final TextDecoration? decoration;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return GrxText(
      data,
      transform: transform,
      textAlign: textAlign,
      style: GrxCaptionLargeTextStyle(
        color: color,
        decoration: decoration,
        overflow: overflow,
      ),
    );
  }
}

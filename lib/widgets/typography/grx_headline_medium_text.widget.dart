import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_medium.style.dart';
import 'grx_text.widget.dart';

/// A Design System's [Text] primarily used by medium titles
///
/// Sets [GrxHeadlineMediumStyle] as [style] default value.
class GrxHeadlineMediumText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxHeadlineMediumText(
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
      style: GrxHeadlineMediumStyle(
        color: color,
        decoration: decoration,
        overflow: overflow,
      ),
    );
  }
}

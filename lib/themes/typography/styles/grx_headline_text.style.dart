import 'dart:ui';

import '../utils/grx_font_weights.dart';
import 'grx_text.style.dart';

/// A Design System's [TextStyle] primarily used by normal titles.
class GrxHeadlineTextStyle extends GrxTextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined font size and font weight
  const GrxHeadlineTextStyle({
    super.color,
    super.decoration,
    super.overflow,
    final FontWeight? fontWeight,
  }) : super(
          fontSize: 18,
          fontWeight: fontWeight ?? GrxFontWeights.semiBold,
        );
}

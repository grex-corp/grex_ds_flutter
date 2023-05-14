import 'dart:ui';

import '../utils/grx_font_weights.dart';
import 'grx_text.style.dart';

/// A Design System's [TextStyle] primarily used by body texts.
class GrxBodyTextStyle extends GrxTextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined font size and font weight
  const GrxBodyTextStyle({
    super.color,
    super.decoration,
    super.overflow,
    final FontWeight? fontWeight,
  }) : super(
          fontSize: 16,
          fontWeight: fontWeight ?? GrxFontWeights.regular,
        );
}

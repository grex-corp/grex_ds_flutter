import 'package:material_ui/material_ui.dart';

import '../utils/grx_font_weights.dart';
import 'grx_text.style.dart';

/// A Design System's [TextStyle] primarily used by normal captions.
class GrxLabelTextStyle extends GrxTextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined font size and font weight
  const GrxLabelTextStyle({
    super.color,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.overflow,
    FontWeight? fontWeight,
  }) : super(fontSize: 12, fontWeight: fontWeight ?? GrxFontWeights.regular);
}

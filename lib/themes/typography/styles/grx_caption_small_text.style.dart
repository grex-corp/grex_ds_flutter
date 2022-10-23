import 'package:grex_ds/themes/typography/styles/grx_text.style.dart';

import '../utils/grx_font_weights.dart';

/// A Design System's [TextStyle] primarily used by small captions.
class GrxCaptionSmallTextStyle extends GrxTextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined font size and font weight
  const GrxCaptionSmallTextStyle({
    super.color,
    super.decoration,
    super.overflow,
  }) : super(
          fontSize: 10,
          fontWeight: GrxFontWeights.medium,
        );
}
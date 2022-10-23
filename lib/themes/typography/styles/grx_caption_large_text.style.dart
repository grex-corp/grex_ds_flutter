import 'package:grex_ds/themes/typography/styles/grx_text.style.dart';

import '../utils/grx_font_weights.dart';

/// A Design System's [TextStyle] primarily used by large captions.
class GrxCaptionLargeTextStyle extends GrxTextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined font size and font weight
  const GrxCaptionLargeTextStyle({
    super.color,
    super.decoration,
    super.overflow,
  }) : super(
          fontSize: 14,
          fontWeight: GrxFontWeights.medium,
        );
}

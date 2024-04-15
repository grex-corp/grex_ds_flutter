import 'package:flutter/material.dart';

import '../../../utils/grx_utils.util.dart';
import '../utils/grx_font_families.dart';

/// A container that has some default properties which should be extended by others Design System's [TextStyle].
class GrxTextStyle extends TextStyle {
  /// Creates a Design System's [TextStyle] with pre-defined package and font family.
  const GrxTextStyle({
    super.fontSize,
    super.fontWeight,
    super.color,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    final TextOverflow? overflow,
  }) : super(
          package: GrxUtils.packageName,
          fontFamily: GrxFontFamilies.montserrat,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
}

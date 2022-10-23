import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';

/// A container that has some default properties which should be extended by others Design System's [Text].
class GrxText extends Text {
  /// Creates a Design System's [Text].
  GrxText(
    String data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
    final GrxTextTransform transform = GrxTextTransform.none,
  }) : super(
          transform == GrxTextTransform.uppercase
              ? data.toUpperCase()
              : transform == GrxTextTransform.lowercase
                  ? data.toLowerCase()
                  : data,
          overflow: TextOverflow.ellipsis,
        );
}

import 'package:flutter/material.dart';

import 'typography/styles/grx_body_text.style.dart';
import 'typography/styles/grx_caption_text.style.dart';
import 'typography/styles/grx_headline_large_text.style.dart';
import 'typography/styles/grx_headline_small_text.style.dart';

/// A [TextTheme] used by Material Design to automatically apply our Design System's [TextStyle].
class GrxTextTheme extends TextTheme {
  /// Creates a Design System's [TextTheme].
  const GrxTextTheme()
      : super(
          titleLarge: const GrxHeadlineLargeTextStyle(),
          titleSmall: const GrxHeadlineSmallTextStyle(),
          bodyLarge: const GrxBodyTextStyle(),
          bodySmall: const GrxCaptionTextStyle(),
          labelLarge: const GrxHeadlineSmallTextStyle(),
        );
}

import 'package:flutter/material.dart';

import 'typography/styles/grx_body_large_text.style.dart';
import 'typography/styles/grx_body_text.style.dart';
import 'typography/styles/grx_body_small_text.style.dart';
import 'typography/styles/grx_display_large_text.style.dart';
import 'typography/styles/grx_display_text.style.dart';
import 'typography/styles/grx_display_small_text.style.dart';
import 'typography/styles/grx_headline_large_text.style.dart';
import 'typography/styles/grx_headline_text.style.dart';
import 'typography/styles/grx_headline_small_text.style.dart';
import 'typography/styles/grx_label_large_text.style.dart';
import 'typography/styles/grx_label_small_text.style.dart';
import 'typography/styles/grx_label_text.style.dart';
import 'typography/styles/grx_title_large_text.style.dart';
import 'typography/styles/grx_title_text.style.dart';
import 'typography/styles/grx_title_small_text.style.dart';

/// A [TextTheme] used by Material Design to automatically apply our Design System's [TextStyle].
class GrxTextTheme extends TextTheme {
  /// Creates a Design System's [TextTheme].
  const GrxTextTheme()
    : super(
        displayLarge: const GrxDisplayLargeTextStyle(),
        displayMedium: const GrxDisplayTextStyle(),
        displaySmall: const GrxDisplaySmallTextStyle(),
        headlineLarge: const GrxHeadlineLargeTextStyle(),
        headlineMedium: const GrxHeadlineTextStyle(),
        headlineSmall: const GrxHeadlineSmallTextStyle(),
        titleLarge: const GrxTitleLargeTextStyle(),
        titleMedium: const GrxTitleTextStyle(),
        titleSmall: const GrxTitleSmallTextStyle(),
        bodyLarge: const GrxBodyLargeTextStyle(),
        bodyMedium: const GrxBodyTextStyle(),
        bodySmall: const GrxBodySmallTextStyle(),
        labelLarge: const GrxLabelLargeTextStyle(),
        labelMedium: const GrxLabelTextStyle(),
        labelSmall: const GrxLabelSmallTextStyle(),
      );
}

import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

/// A [TextTheme] used by Material Design to automatically apply our Design System's [TextStyle].
class GrxTextTheme extends TextTheme {
  /// Creates a Design System's [TextTheme].
  const GrxTextTheme()
      : super(
          headline6: const GrxHeadlineLargeStyle(),
          subtitle2: const GrxHeadlineSmallStyle(),
          bodyText1: const GrxBodyTextStyle(),
          caption: const GrxCaptionTextStyle(),
          button: const GrxHeadlineSmallStyle(),
        );
}

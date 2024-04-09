import 'package:flutter/material.dart';

import '../../widgets/typography/grx_caption_large_text.widget.dart';
import '../../widgets/typography/grx_headline_small_text.widget.dart';
import '../colors/grx_colors.dart';
import '../typography/styles/grx_caption_large_text.style.dart';
import '../typography/styles/grx_caption_text.style.dart';
import '../typography/styles/grx_headline_small_text.style.dart';

abstract class GrxFieldStyles {
  static const inputTextStyle =
      GrxCaptionLargeTextStyle(color: GrxColors.cff7892b7);

  static const inputHintTextStyle =
      GrxCaptionLargeTextStyle(color: GrxColors.cff7892b7);

  static const labelTextStyle =
      GrxHeadlineSmallTextStyle(color: GrxColors.cff2e2e2e);

  static const inputErrorTextStyle =
      GrxCaptionTextStyle(color: GrxColors.cfffc5858);

  static const underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: GrxColors.primarySwatch),
  );

  static const underlineInputFocusedBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: GrxColors.primarySwatch, width: 2),
  );

  static const underlineInputErrorBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: GrxColors.cfffc5858),
  );

  static const underlineInputFocusedErrorBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: GrxColors.cfffc5858, width: 2),
  );

  static Widget inputText(String text, bool isLoading) => GrxCaptionLargeText(
        text,
        color: GrxColors.cff7892b7,
        isLoading: isLoading,
      );

  static Widget labelText(String label, bool isLoading) => GrxHeadlineSmallText(
        label,
        color: GrxColors.cff2e2e2e,
        isLoading: isLoading,
      );
}

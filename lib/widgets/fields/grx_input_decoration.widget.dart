import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_title_text.style.dart';
import '../buttons/grx_clear_input_button.widget.dart';

class GrxInputDecoration extends InputDecoration {
  GrxInputDecoration({
    super.labelText,
    super.hintText,
    super.alignLabelWithHint = false,
    super.contentPadding,
    super.hintMaxLines,
    super.errorText,
    super.prefix,
    super.suffixIconConstraints,
    this.onClear,
    super.enabled = true,
    this.showClearButton = false,
    this.isClearButtonVisible = false,
    final Widget? suffix,
  }) : super(
         floatingLabelStyle: GrxTitleTextStyle(
           color: GrxColors.primary.shade900,
         ),
         suffix: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             if (suffix != null) suffix,
             if (showClearButton)
               Opacity(
                 opacity: isClearButtonVisible ? 1 : 0,
                 child: IgnorePointer(
                   ignoring: !isClearButtonVisible,
                   child: GrxClearInputButton(onClear: onClear!),
                 ),
               ),
           ],
         ),
         isDense: true,
       );

  final void Function()? onClear;

  /// When true, reserves suffix space for the clear button so toggling text
  /// empty/non-empty does not change [InputDecoration] structure (avoids focus loss).
  final bool showClearButton;

  /// Whether the clear button is visible and tappable.
  final bool isClearButtonVisible;
}

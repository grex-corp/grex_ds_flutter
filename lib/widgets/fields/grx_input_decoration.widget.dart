import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
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
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Container(
                   padding: const EdgeInsets.all(GrxSpacing.xxs),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(20)),
                     color: GrxColors.primary.shade200,
                   ),
                   child: GrxClearInputButton(onClear: onClear!),
                 ),
               ),
           ],
         ),
       );

  final void Function()? onClear;
  final bool showClearButton;
}

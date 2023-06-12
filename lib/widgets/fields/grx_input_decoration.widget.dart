import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/fields/grx_field_styles.theme.dart';
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
    this.onClear,
    super.enabled = true,
    this.showClearButton = false,
  }) : super(
          labelStyle: GrxFieldStyles.labelTextStyle,
          floatingLabelStyle: GrxFieldStyles.labelTextStyle,
          floatingLabelBehavior: (hintText?.isEmpty ?? true)
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.always,
          enabledBorder: GrxFieldStyles.underlineInputBorder,
          focusedBorder: GrxFieldStyles.underlineInputFocusedBorder,
          errorBorder: GrxFieldStyles.underlineInputErrorBorder,
          errorStyle: GrxFieldStyles.inputErrorTextStyle,
          focusedErrorBorder: GrxFieldStyles.underlineInputFocusedErrorBorder,
          hintStyle: GrxFieldStyles.inputHintTextStyle,
          suffix: showClearButton
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GrxColors.cffd6dfea,
                    ),
                    child: GrxClearInputButton(
                      onClear: onClear!,
                    ),
                  ),
                )
              : null,
        );

  final void Function()? onClear;
  final bool showClearButton;
}

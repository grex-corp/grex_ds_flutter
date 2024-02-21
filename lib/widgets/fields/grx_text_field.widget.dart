import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/fields/grx_field_styles.theme.dart';
import 'grx_input_decoration.widget.dart';

class GrxTextField extends TextField {
  GrxTextField({
    super.key,
    super.readOnly,
    super.keyboardType,
    super.obscureText,
    super.onSubmitted,
    super.focusNode,
    super.autofocus,
    super.inputFormatters,
    super.onTap,
    super.onChanged,
    required TextEditingController super.controller,
    final String? labelText,
    final bool enabled = true,
    super.autocorrect = false,
    final EdgeInsets? contentPadding,
    super.textCapitalization = TextCapitalization.sentences,
    TextAlignVertical super.textAlignVertical = TextAlignVertical.center,
    final int? maxLines = 1,
    final bool alignLabelWithHint = false,
    final String? hintText,
    final int? hintMaxLines,
    final String? errorText,
    TextInputAction super.textInputAction = TextInputAction.next,
    final void Function()? onClear,
    final bool showClearButton = true,
    final Widget? prefix,
    final Widget? suffix,
  }) : super(
          cursorColor: GrxColors.cff70efa7,
          style: GrxFieldStyles.inputTextStyle,
          maxLines: obscureText ? 1 : maxLines,
          decoration: GrxInputDecoration(
            labelText: labelText,
            alignLabelWithHint: alignLabelWithHint,
            contentPadding: contentPadding,
            hintText: hintText,
            hintMaxLines: hintMaxLines,
            errorText: errorText,
            enabled: enabled,
            onClear: onClear?.call ?? controller.clear,
            showClearButton: showClearButton && controller.text.isNotEmpty && enabled,
            prefix: prefix,
            suffix: suffix,
          ),
        );
}

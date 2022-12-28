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
    required final TextEditingController controller,
    final String? labelText,
    final bool enabled = true,
    final bool autocorrect = false,
    final EdgeInsets? contentPadding,
    final TextCapitalization textCapitalization = TextCapitalization.sentences,
    final TextAlignVertical textAlignVertical = TextAlignVertical.center,
    final int? maxLines = 1,
    final bool alignLabelWithHint = false,
    final String? hintText,
    final int? hintMaxLines,
    final String? errorText,
    final TextInputAction textInputAction = TextInputAction.done,
  }) : super(
          controller: controller,
          textCapitalization: textCapitalization,
          autocorrect: autocorrect,
          cursorColor: GrxColors.cff70efa7,
          style: GrxFieldStyles.inputTextStyle,
          textInputAction: textInputAction,
          maxLines: obscureText ? 1 : maxLines,
          textAlignVertical: textAlignVertical,
          decoration: GrxInputDecoration(
            labelText: labelText,
            alignLabelWithHint: alignLabelWithHint,
            contentPadding: contentPadding,
            hintText: hintText,
            hintMaxLines: hintMaxLines,
            errorText: errorText,
            enabled: enabled,
            onClear: controller.clear,
            showClearButton: controller.text.isNotEmpty && enabled,
          ),
        );
}

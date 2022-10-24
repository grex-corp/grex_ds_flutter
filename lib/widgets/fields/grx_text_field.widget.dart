import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import '../../themes/typography/styles/grx_headline_small.style.dart';

const _inputTextStyle = GrxCaptionLargeTextStyle(color: GrxColors.cff7892b7);
const _inputHintTextStyle = GrxCaptionLargeTextStyle(color: GrxColors.ccc7892b7);
const _labelTextStyle = GrxHeadlineSmallStyle(color: GrxColors.cff2e2e2e);

const _underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cff75f3ab),
);

const _underlineInputFocusedBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cff75f3ab, width: 2),
);

const _underlineInputErrorBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cfffc5858),
);

const _underlineInputFocusedErrorBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cfffc5858, width: 2),
);

class GrxTextField extends TextField {
  GrxTextField({
    super.key,
    super.readOnly,
    super.onChanged,
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
    final bool isValid = true,
  }) : super(
          controller: controller,
          textCapitalization: textCapitalization,
          autocorrect: autocorrect,
          cursorColor: GrxColors.cff70efa7,
          style: _inputTextStyle,
          textInputAction: textInputAction,
          maxLines: obscureText ? 1 : maxLines,
          textAlignVertical: textAlignVertical,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: _labelTextStyle,
            floatingLabelStyle: _labelTextStyle,
            floatingLabelBehavior: (hintText?.isEmpty ?? true)
                ? FloatingLabelBehavior.auto
                : FloatingLabelBehavior.always,
            alignLabelWithHint: alignLabelWithHint,
            enabledBorder: _underlineInputBorder,
            focusedBorder: _underlineInputFocusedBorder,
            errorBorder: _underlineInputErrorBorder,
            focusedErrorBorder: _underlineInputFocusedErrorBorder,
            contentPadding: contentPadding,
            hintText: hintText,
            hintMaxLines: hintMaxLines,
            hintStyle: _inputHintTextStyle,
            errorText: errorText,
            suffix: Container(
              padding: const EdgeInsets.only(right: 10),
              child: isValid
                  ? const Icon(
                      Icons.check,
                      color: GrxColors.cff75f3ab,
                    )
                  : const Icon(
                      Icons.close,
                      color: GrxColors.cfffc5858,
                    ),
            ),
            enabled: enabled,
          ),
        );
}
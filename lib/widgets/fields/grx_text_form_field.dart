import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import '../../themes/typography/styles/grx_headline_small.style.dart';

const _inputTextStyle = GrxCaptionLargeTextStyle(color: GrxColors.c7892b7);
const _labelTextStyle = GrxHeadlineSmallStyle(color: GrxColors.c2e2e2e);

const _underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.c75f3ab),
);

const _underlineInputFocusedBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.c75f3ab, width: 2),
);

const _underlineInputErrorBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cfc5858),
);

const _underlineInputFocusedErrorBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: GrxColors.cfc5858, width: 2),
);

/// A Design System's [FormField] used like text fields.
class GrxTextFormField extends FormField<String> {
  GrxTextFormField({
    final Key? key,
    required final TextEditingController controller,
    final String? labelText,
    final TextInputType? keyboardType,
    final bool obscureText = false,
    final void Function(String?)? onChanged,
    FormFieldSetter<String?>? onSaved,
    FormFieldValidator<String?>? validator,
    final bool enabled = true,
    final EdgeInsets? contentPadding,
    final TextCapitalization textCapitalization = TextCapitalization.sentences,
    final TextAlignVertical textAlignVertical = TextAlignVertical.center,
    final int? maxLines = 1,
    final bool alignLabelWithHint = false,
    final String? hintText,
    final int? hintMaxLines,
    final AutovalidateMode autovalidateMode = AutovalidateMode.always,
    final TextInputAction textInputAction = TextInputAction.done,
    final void Function(String?)? onFieldSubmitted,
    final FocusNode? focusNode,
    final bool autoFocus = false,
    final List<TextInputFormatter>? inputFormatters,
  }) : super(
          key: key,
          autovalidateMode: autovalidateMode,
          initialValue: controller.text,
          builder: (FormFieldState<String> field) {
            void onChangedHandler(String value) {
              if (field.mounted && field.value != value) {
                if (onChanged != null) {
                  onChanged(value);
                }

                field.didChange(value);
              }
            }

            void listener() => onChangedHandler(controller.text);

            controller.removeListener(listener);
            controller.addListener(listener);

            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autoFocus,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              autocorrect: false,
              onChanged: onChangedHandler,
              cursorColor: GrxColors.c70efa7,
              style: _inputTextStyle,
              textInputAction: textInputAction,
              maxLines: obscureText ? 1 : maxLines,
              textAlignVertical: textAlignVertical,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
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
                hintStyle: _inputTextStyle,
                errorText: field.errorText,
                suffix: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: (validator != null &&
                              (validator(controller.text)?.isEmpty ?? true)) ||
                          validator == null
                      ? const Icon(
                          Icons.check,
                          color: GrxColors.c75f3ab,
                        )
                      : const Icon(
                          Icons.close,
                          color: GrxColors.cfc5858,
                        ),
                ),
                enabled: enabled,
              ),
            );
          },
          validator:
              validator != null ? (_) => validator(controller.text) : null,
          onSaved: onSaved,
          enabled: enabled,
        );
}

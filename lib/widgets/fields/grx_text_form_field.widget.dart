import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'grx_text_field.widget.dart';

/// A Design System's [FormField] used like text fields.
class GrxTextFormField extends FormField<String> {
  GrxTextFormField({
    super.key,
    super.onSaved,
    super.enabled,
    required final TextEditingController controller,
    final String? labelText,
    final TextInputType? keyboardType,
    final bool obscureText = false,
    final void Function(String?)? onChanged,
    FormFieldValidator<String?>? validator,
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
          autovalidateMode: autovalidateMode,
          initialValue: controller.text,
          validator:
              validator != null ? (_) => validator(controller.text) : null,
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

            return GrxTextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autoFocus,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              autocorrect: false,
              onChanged: onChangedHandler,
              textInputAction: textInputAction,
              maxLines: obscureText ? 1 : maxLines,
              textAlignVertical: textAlignVertical,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
              labelText: labelText,
              alignLabelWithHint: alignLabelWithHint,
              contentPadding: contentPadding,
              hintText: hintText,
              hintMaxLines: hintMaxLines,
              errorText: field.errorText,
              isValid: (validator != null &&
                      (validator(controller.text)?.isEmpty ?? true)) ||
                  validator == null,
              enabled: enabled,
            );
          },
        );
}

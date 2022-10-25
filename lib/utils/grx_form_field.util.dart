import 'package:flutter/material.dart';

abstract class GrxFormFieldUtils {
  static onValueChange(
    FormFieldState<String> field,
    TextEditingController controller, {
    void Function(String)? onChanged,
  }) {
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
  }
}

import 'package:flutter/material.dart';

import '../widgets/fields/controllers/grx_form_field.controller.dart';

abstract class GrxFormFieldUtils {
  static void onValueChange(
    FormFieldState<String> field,
    GrxFormFieldController controller, {
    void Function(String)? onChanged,
  }) {
    if (controller.hasListeners) return;

    void onChangedHandler(String value) {
      if (field.mounted && field.value != value) {
        field.didChange(value);

        if (onChanged != null) {
          onChanged(value);
        }
      }
    }

    void listener() => onChangedHandler(controller.text);

    controller.removeListener(listener);
    controller.addListener(listener);
  }
}

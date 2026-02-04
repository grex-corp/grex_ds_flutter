import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
        if (onChanged != null) {
          onChanged(value);
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (field.mounted) {
            field.didChange(value);
          }
        });
      }
    }

    void listener() => onChangedHandler(controller.text);

    controller.removeListener(listener);
    controller.addListener(listener);
  }
}

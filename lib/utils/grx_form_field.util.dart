import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/fields/controllers/grx_form_field.controller.dart';

abstract class GrxFormFieldUtils {
  static final Expando<VoidCallback> _listeners = Expando();

  static void onValueChange(
    FormFieldState<String> field,
    GrxFormFieldController controller, {
    void Function(String)? onChanged,
  }) {
    final previous = _listeners[controller];
    if (previous != null) {
      controller.removeListener(previous);
    }

    void listener() {
      final value = controller.text;

      if (!field.mounted || field.value == value) {
        return;
      }

      onChanged?.call(value);
      _scheduleFieldDidChange(field, value);
    }

    _listeners[controller] = listener;
    controller.addListener(listener);

    _syncFieldWithController(field, controller);
  }

  /// Reconciles [FormField] value after rebuild (e.g. shimmer → field).
  /// Does not call [onChanged] — store state is already up to date.
  static void _syncFieldWithController(
    FormFieldState<String> field,
    GrxFormFieldController controller,
  ) {
    final value = controller.text;

    if (!field.mounted || field.value == value) {
      return;
    }

    _scheduleFieldDidChange(field, value);
  }

  static void _scheduleFieldDidChange(
    FormFieldState<String> field,
    String value,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!field.mounted || field.value == value) {
        return;
      }

      field.didChange(value);
    });
  }

  static void detachListener(GrxFormFieldController controller) {
    final previous = _listeners[controller];
    if (previous != null) {
      controller.removeListener(previous);
    }
  }
}

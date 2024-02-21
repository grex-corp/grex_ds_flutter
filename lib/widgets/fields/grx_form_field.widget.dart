import 'package:flutter/material.dart';

class GrxFormField<T> extends StatelessWidget {
  const GrxFormField({
    super.key,
    required this.builder,
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.always,
    this.validator,
    this.onSaved,
    this.enabled = true,
    this.flexible = false,
  });

  final Widget Function(FormFieldState<T>) builder;
  final T? initialValue;
  final AutovalidateMode? autovalidateMode;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;
  final bool enabled;
  final bool flexible;

  @override
  Widget build(BuildContext context) {
    final formField = FormField<T>(
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onSaved: onSaved,
      enabled: enabled,
      builder: builder,
    );

    return flexible
        ? Flexible(
            child: formField,
          )
        : formField;
  }
}

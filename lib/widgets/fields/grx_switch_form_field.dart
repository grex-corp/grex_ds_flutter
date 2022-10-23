import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_small.style.dart';
import '../cupertino/cupertino_switch_list_tile.dart';

const _defaultInputLabel = GrxHeadlineSmallStyle(color: GrxColors.c2e2e2e);

/// A Design System's [FormField] used like a switch
class GrxSwitchFormField extends FormField<bool> {
  final String labelText;
  final void Function(bool?)? onChanged;
  final bool changeOnInitialValue;

  GrxSwitchFormField({
    required this.labelText,
    this.onChanged,
    this.changeOnInitialValue = false,
    Key? key,
    FormFieldSetter<bool?>? onSaved,
    FormFieldValidator<bool?>? validator,
    bool? initialValue,
    bool enabled = true,
    TextStyle? style,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.always,
          enabled: enabled,
          builder: (FormFieldState<bool> state) {
            if (changeOnInitialValue) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (state.value != initialValue) {
                  state.didChange(initialValue);
                }
              });
            }

            return Platform.isIOS
                ? CupertinoSwitchListTile(
                    title: Text(labelText, style: style ?? _defaultInputLabel),
                    value: state.value ?? false,
                    activeColor: GrxColors.c6bbaf0,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (data) {
                      state.didChange(data);

                      if (onChanged != null) onChanged(data);
                    },
                  )
                : SwitchListTile(
                    title: Text(labelText, style: style ?? _defaultInputLabel),
                    value: state.value ?? false,
                    activeColor: GrxColors.c6bbaf0,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (data) {
                      state.didChange(data);

                      if (onChanged != null) onChanged(data);
                    },
                  );
          },
        );
}
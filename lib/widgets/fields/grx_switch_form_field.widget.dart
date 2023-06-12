import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_headline_small_text.style.dart';
import '../cupertino/cupertino_switch_list_tile.dart';
import 'grx_form_field.widget.dart';

/// A Design System's [FormField] used like a switch
class GrxSwitchFormField extends GrxFormField<bool> {
  GrxSwitchFormField({
    final Key? key,
    required this.labelText,
    this.onChanged,
    this.overflow,
    this.changeOnInitialValue = false,
    this.isLoading = false,
    final void Function(bool)? onSaved,
    final TextStyle? style,
    final bool? initialValue,
    final bool enabled = true,
    final bool flexible = false,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
          initialValue: initialValue,
          onSaved: onSaved != null ? (value) => onSaved(value ?? false) : null,
          autovalidateMode: AutovalidateMode.always,
          enabled: enabled,
          flexible: flexible,
          builder: (FormFieldState<bool> state) {
            if (changeOnInitialValue) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (state.value != initialValue) {
                  state.didChange(initialValue);
                }
              });
            }

            void onFieldChanged(data) {
              state.didChange(data);

              if (onChanged != null) onChanged(data);
            }

            final opacity = enabled && !isLoading ? 1.0 : .5;
            final defaultInputLabel = GrxHeadlineSmallTextStyle(
              color: GrxColors.cff2e2e2e.withOpacity(opacity),
            );

            return Platform.isIOS
                ? CupertinoSwitchListTile(
                    title: Text(
                      labelText,
                      style: style ?? defaultInputLabel,
                      overflow: overflow,
                    ),
                    value: state.value ?? false,
                    activeColor: GrxColors.cff6bbaf0,
                    contentPadding: EdgeInsets.zero,
                    onChanged: enabled && !isLoading ? onFieldChanged : null,
                  )
                : SwitchListTile(
                    title: Text(
                      labelText,
                      style: style ?? defaultInputLabel,
                      overflow: overflow,
                    ),
                    value: state.value ?? false,
                    activeColor: GrxColors.cff6bbaf0,
                    contentPadding: EdgeInsets.zero,
                    onChanged: enabled && !isLoading ? onFieldChanged : null,
                  );
          },
        );

  final String labelText;
  final void Function(bool)? onChanged;
  final TextOverflow? overflow;
  final bool changeOnInitialValue;
  final bool isLoading;
}

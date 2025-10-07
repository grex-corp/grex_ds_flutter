import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_title_small_text.style.dart';
import '../cupertino/cupertino_switch_list_tile.dart';
import '../typography/grx_text.widget.dart';
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
    final bool? value,
    super.enabled,
    super.flexible,
  }) : super(
         key: key ?? ValueKey<int>(labelText.hashCode),
         initialValue: value,
         onSaved: onSaved != null ? (value) => onSaved(value ?? false) : null,
         autovalidateMode: AutovalidateMode.always,
         builder: (FormFieldState<bool> state) {
           if (changeOnInitialValue) {
             SchedulerBinding.instance.addPostFrameCallback((_) {
               if (state.value != value) {
                 state.didChange(value);
               }
             });
           }

           void onFieldChanged(data) {
             state.didChange(data);

             if (onChanged != null) onChanged(data);
           }

           final double opacity = enabled ? 1.0 : .5;

           final defaultInputLabel = GrxTitleSmallTextStyle(
             color: GrxColors.primary.shade900.withValues(alpha: opacity),
           );

           final labelWidget = GrxText(
             labelText,
             style: style ?? defaultInputLabel,
             isLoading: isLoading,
           );

           return CupertinoSwitchListTile(
             title: labelWidget,
             value: state.value ?? false,
             activeColor: GrxColors.primary,
             contentPadding: EdgeInsetsGeometry.zero,
             enabled: enabled && !isLoading,
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'grx_text_field.widget.dart';

class GrxDateTimePickerFormField extends GrxStatefulWidget {
  GrxDateTimePickerFormField({
    super.key,
    this.initialValue,
    this.labelText,
    this.hintText = '02/10/1997',
    this.dialogConfirmText = 'Confirmar',
    this.dialogCancelText = 'Cancelar',
    this.dialogErrorFormatText = 'Formato inválido',
    this.dialogErrorInvalidText = 'A data informada não é válida',
    this.onChanged,
    this.onSaved,
    this.validator,
    this.isDateTime = false,
    this.enabled = true,
    this.futureDate = false,
    this.controller,
  });

  final DateTime? initialValue;
  final String? labelText;
  final String? hintText;
  final String dialogConfirmText;
  final String dialogCancelText;
  final String dialogErrorFormatText;
  final String dialogErrorInvalidText;
  final void Function(String?)? onChanged;
  final FormFieldSetter<DateTime?>? onSaved;
  final FormFieldValidator<String?>? validator;
  final bool isDateTime;
  final bool enabled;
  final bool futureDate;
  final TextEditingController? controller;

  @override
  State<StatefulWidget> createState() => _GrxDateTimePickerFormFieldState();
}

class _GrxDateTimePickerFormFieldState
    extends State<GrxDateTimePickerFormField> {
  late final String locale;
  late final TextEditingController controller;

  DateTime? value;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();

    if (widget.initialValue != null && value == null) {
      value = widget.initialValue;
      controller.text = _formatValue(value!);
      if (widget.onChanged != null) {
        widget.onChanged!(controller.text);
      }
    }

    super.initState();
  }

  String _formatValue(DateTime value) {
    return '${DateFormat.yMd().format(value)}${widget.isDateTime ? ' ${DateFormat.Hm().format(value)}' : ''}';
  }

  @override
  Widget build(_) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.always,
      initialValue: widget.initialValue?.toIso8601String(),
      validator: widget.validator,
      onSaved: (_) => widget.onSaved != null ? widget.onSaved!(value) : null,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: widget.onChanged,
        );

        return GrxTextField(
          controller: controller,
          readOnly: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          errorText: field.errorText,
          onTap: () async {
            final today = DateTime.now();
            late final DateTime? selectedDate;
            TimeOfDay? selectedTime;

            selectedDate = await showDatePicker(
              context: context,
              initialDate: value ?? today,
              firstDate:
                  widget.futureDate ? today : DateTime.parse("0001-01-01"),
              lastDate:
                  widget.futureDate ? DateTime.parse('2099-12-31') : today,
              confirmText: widget.dialogConfirmText,
              cancelText: widget.dialogCancelText,
              errorFormatText: widget.dialogErrorFormatText,
              errorInvalidText: widget.dialogErrorInvalidText,
              fieldHintText: widget.hintText,
              fieldLabelText: widget.labelText,
              helpText: widget.labelText,
              keyboardType: TextInputType.datetime,
            );

            if (selectedDate != null && widget.isDateTime) {
              selectedTime = await showTimePicker(
                context: context,
                confirmText: widget.dialogConfirmText,
                cancelText: widget.dialogCancelText,
                initialTime: value != null
                    ? TimeOfDay(hour: value!.hour, minute: value!.minute)
                    : TimeOfDay.now(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
            }

            DateTime? date;

            if (selectedTime != null) {
              date = DateTime(selectedDate!.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedTime.minute);
            } else if (selectedDate != null) {
              date = DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day);
            }

            if (date != null) {
              setState(
                () {
                  value = date;
                  controller.text = _formatValue(value!);
                },
              );
            }
          },
          enabled: widget.enabled,
        );
      },
    );
  }
}

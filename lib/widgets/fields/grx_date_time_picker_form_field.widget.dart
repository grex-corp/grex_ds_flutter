import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_form_field.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxDateTimePickerFormField extends GrxStatefulWidget {
  GrxDateTimePickerFormField({
    final Key? key,
    required this.labelText,
    this.controller,
    this.value,
    this.hintText,
    this.dialogConfirmText = 'Confirm',
    this.dialogCancelText = 'Cancel',
    this.dialogErrorFormatText = 'Invalid Format',
    this.dialogErrorInvalidText = 'Provided date is not valid',
    this.onSelectItem,
    this.onSaved,
    this.validator,
    this.isDateTime = false,
    this.enabled = true,
    this.flexible = false,
    this.futureDate = false,
    this.isLoading = false,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final GrxFormFieldController<DateTime>? controller;
  final DateTime? value;
  final String labelText;
  final String? hintText;
  final String dialogConfirmText;
  final String dialogCancelText;
  final String dialogErrorFormatText;
  final String dialogErrorInvalidText;
  final void Function(DateTime?)? onSelectItem;
  final FormFieldSetter<DateTime?>? onSaved;
  final FormFieldValidator<DateTime?>? validator;
  final bool isDateTime;
  final bool enabled;
  final bool flexible;
  final bool futureDate;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxDateTimePickerFormFieldState();
}

class _GrxDateTimePickerFormFieldState
    extends State<GrxDateTimePickerFormField> {
  late final String locale;
  late final GrxFormFieldController<DateTime> controller;

  DateTime? value;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? GrxFormFieldController<DateTime>();

    if (widget.value != null && value == null) {
      value = widget.value;
      controller.text = _formatValue(value!);
      if (widget.onSelectItem != null) {
        widget.onSelectItem!(value);
      }
    }

    _subscribeStreams();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    super.dispose();
  }

  String _formatValue(DateTime value) {
    return '${DateFormat.yMd().format(value)}${widget.isDateTime ? ' ${DateFormat.Hm().format(value)}' : ''}';
  }

  void _subscribeStreams() {
    controller.onClearStream.stream.listen((_) {
      value = null;
    });

    controller.onDidUpdateValue.stream.listen((value) {
      if (value == null) {
        controller.clear();
        return;
      }

      this.value = value;
      controller.text = _formatValue(value);
    });
  }

  @override
  Widget build(_) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(
        labelText: widget.labelText,
      );
    }

    return GrxFormField<String>(
      initialValue: widget.value?.toIso8601String(),
      validator: (_) => widget.validator?.call(value),
      onSaved: (_) => widget.onSaved?.call(value),
      enabled: widget.enabled,
      flexible: widget.flexible,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: (value) {
            if (value.isEmpty) {
              widget.onSelectItem?.call(null);
              this.value = null;
            }
          },
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

            if (mounted && selectedDate != null && widget.isDateTime) {
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

                  if (widget.onSelectItem != null) {
                    widget.onSelectItem!(value);
                  }
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

import 'package:flutter/material.dart';

import '../../services/grx_bottom_sheet.service.dart';
import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_form_field.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxCustomDropdownFormField<T> extends GrxStatefulWidget {
  GrxCustomDropdownFormField({
    final Key? key,
    required this.labelText,
    required this.builder,
    required this.displayText,
    this.controller,
    this.onSaved,
    this.hintText,
    this.selectBottomSheetTitle,
    this.value,
    this.defaultValue,
    this.autovalidateMode = AutovalidateMode.always,
    this.onSelectItem,
    this.validator,
    this.enabled = true,
    this.flexible = false,
    this.isLoading = false,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final GrxFormFieldController<T>? controller;
  final String labelText;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final Widget Function(ScrollController? scrollController, T? selectedValue)
      builder;
  final String Function(T data) displayText;
  final T? value;
  final T? defaultValue;
  final AutovalidateMode autovalidateMode;
  final void Function(T?)? onSelectItem;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final bool flexible;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxDropdownStateFormField<T>();
}

class _GrxDropdownStateFormField<T>
    extends State<GrxCustomDropdownFormField<T>> {
  T? value;
  late final GrxFormFieldController<T> controller;
  final TextEditingController quickSearchFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? GrxFormFieldController<T>();

    if (widget.value != null && value == null) {
      value = widget.value;
      controller.text = widget.displayText(value as T);
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

  void _subscribeStreams() {
    controller.onClearStream.stream.listen((_) {
      value = null;
    });

    controller.onDidUpdateValue.stream.listen((data) {
      final (value, _) = data;

      if (value == null) {
        controller.clear();
        return;
      }

      this.value = value;
      controller.text = widget.displayText(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(
        labelText: widget.labelText,
      );
    }

    return GrxFormField<String>(
      initialValue: controller.text,
      autovalidateMode: widget.autovalidateMode,
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
          enabled: widget.enabled,
          onClear: () {
            setState(
              () {
                value = widget.defaultValue;

                if (widget.defaultValue != null) {
                  controller.text =
                      widget.displayText(widget.defaultValue as T);
                } else {
                  controller.clear();
                }
              },
            );
          },
          onTap: () async {
            final bottomSheet = GrxBottomSheetService(
              context: context,
              title: widget.selectBottomSheetTitle,
              builder: (controller) => widget.builder(
                controller,
                value,
              ),
            );

            final result = await bottomSheet.show<T>();

            if (result != null) {
              if (widget.onSelectItem != null) {
                widget.onSelectItem!(result);
              }
              setState(() {
                value = result;
                controller.text = widget.displayText(result);
              });
            }
          },
        );
      },
    );
  }
}

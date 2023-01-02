import 'package:flutter/material.dart';
import 'package:grex_ds/services/grx_bottom_sheet.service.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxCustomDropdownFormField<T> extends GrxStatefulWidget {
  GrxCustomDropdownFormField({
    super.key,
    required this.labelText,
    required this.builder,
    required this.displayText,
    this.controller,
    this.onSaved,
    this.hintText,
    this.initialValue,
    this.onSelectItem,
    this.validator,
    this.enabled = true,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Widget Function(ScrollController? scrollController, T? selectedValue)
      builder;
  final String Function(T data) displayText;
  final T? initialValue;
  final void Function(T?)? onSelectItem;
  final void Function(T?)? onSaved;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxDropdownStateFormField<T>();
}

class _GrxDropdownStateFormField<T>
    extends State<GrxCustomDropdownFormField<T>> {
  T? value;
  late final TextEditingController controller;
  final TextEditingController quickSearchFieldController =
      TextEditingController();

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();

    if (widget.initialValue != null && value == null) {
      value = widget.initialValue;
      controller.text = widget.displayText(value as T);
      if (widget.onSelectItem != null) {
        widget.onSelectItem!(value);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(
        labelText: widget.labelText,
      );
    }
    
    return FormField<String>(
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.always,
      validator: widget.validator,
      onSaved: (_) => widget.onSaved != null ? widget.onSaved!(value) : null,
      enabled: widget.enabled,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: (value) {
            if (value.isEmpty && widget.onSelectItem != null) {
              widget.onSelectItem!(null);
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
          onTap: () async {
            final bottomSheet = GrxBottomSheetService(
              context: context,
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

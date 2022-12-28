import 'package:flutter/material.dart';
import 'package:grex_ds/services/grx_bottom_sheet.service.dart';
import 'package:grex_ds/widgets/common/grx_dropdown_body.widget.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'grx_text_field.widget.dart';

class GrxDropdownFormField<T> extends GrxStatefulWidget {
  GrxDropdownFormField({
    super.key,
    required this.labelText,
    required this.onSaved,
    required this.data,
    required this.itemBuilder,
    required this.displayText,
    this.hintText,
    this.initialValue,
    this.onSelectItem,
    this.validator,
    this.enabled = true,
    this.controller,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Iterable<T> data;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final String Function(T data) displayText;
  final T? initialValue;
  final void Function(T?)? onSelectItem;
  final void Function(T?) onSaved;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _GrxDropdownStateFormField<T>();
}

class _GrxDropdownStateFormField<T> extends State<GrxDropdownFormField<T>> {
  T? value;
  final List<T> _list = [];
  StateSetter? _setModalState;
  late final TextEditingController controller;
  final TextEditingController quickSearchFieldController =
      TextEditingController();

  @override
  void initState() {
    _list.clear();
    _list.addAll(widget.data);

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

  void _filterData(String val) {
    void filter() {
      _list.clear();
      _list.addAll(
        widget.data.where(
          (x) =>
              val.isEmpty ||
              widget.displayText(x).toString().toLowerCase().contains(
                    val.toLowerCase(),
                  ),
        ),
      );
    }

    _setModalState != null
        ? _setModalState!(
            () {
              filter();
            },
          )
        : filter();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.always,
      validator: widget.validator,
      onSaved: (_) => widget.onSaved(value),
      enabled: widget.enabled,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: (value) {
            if (value.isEmpty && widget.onSelectItem != null) {
              widget.onSelectItem!(null);
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
              builder: (controller) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    _setModalState = setModalState;

                    return GrxDropdownBody<T>(
                      controller: controller,
                      filterData: _filterData,
                      quickSearchFieldController: quickSearchFieldController,
                      onSelectItem: widget.onSelectItem,
                      itemBuilder: (context, index, item, _, __) =>
                          widget.itemBuilder(context, index, item),
                      items: _list,
                      onChangeState: (item) {
                        setState(() {
                          value = item;
                          this.controller.text = widget.displayText(item);
                        });
                      },
                    );
                  },
                );
              },
            );

            await bottomSheet.show<bool>();
          },
        );
      },
    );
  }
}

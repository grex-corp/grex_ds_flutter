import 'package:flutter/material.dart';
import 'package:grex_ds/services/grx_bottom_sheet.service.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import '../grx_chip.widget.dart';
import '../bottomsheet/grx_bottom_sheet_form_field_body.widget.dart';
import '../grx_stateful.widget.dart';
import '../typography/grx_caption_text.widget.dart';
import 'grx_input_decoration.widget.dart';

class GrxMultiSelectFormField<T> extends GrxStatefulWidget {
  GrxMultiSelectFormField({
    super.key,
    required this.labelText,
    required this.data,
    required this.itemBuilder,
    required this.displayText,
    required this.valueKey,
    this.onSaved,
    this.controller,
    this.hintText,
    this.initialValue,
    this.onSelectItems,
    this.validator,
    this.enabled = true,
    this.searchable = false,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Iterable<T> data;
  final Widget Function(BuildContext context, int index, T value,
      void Function()? onChanged, bool isSelected) itemBuilder;
  final String Function(T data) displayText;
  final int Function(T data) valueKey;
  final Iterable<T>? initialValue;
  final void Function(Iterable<T>?)? onSelectItems;
  final FormFieldSetter<Iterable<T>>? onSaved;
  final FormFieldValidator<Iterable<T>>? validator;
  final bool enabled;
  final bool searchable;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;

  @override
  State<StatefulWidget> createState() => _GrxMultiSelectStateFormField<T>();
}

class _GrxMultiSelectStateFormField<T>
    extends State<GrxMultiSelectFormField<T>> {
  Iterable<T>? values;
  final List<T> _list = [];
  late final TextEditingController controller;
  final TextEditingController quickSearchFieldController =
      TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    _list.clear();
    _list.addAll(widget.data);

    controller = widget.controller ?? TextEditingController();

    if (widget.initialValue != null && values == null) {
      values = widget.initialValue;
      if (widget.onSelectItems != null) {
        widget.onSelectItems!(values);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Iterable<T>>(
      initialValue: widget.initialValue,
      autovalidateMode: AutovalidateMode.always,
      validator: widget.validator,
      onSaved: (_) => widget.onSaved != null ? widget.onSaved!(values) : null,
      enabled: widget.enabled,
      builder: (FormFieldState<Iterable<T>> field) {
        List<Widget> buildSelectedOptions(state) {
          List<Widget> selectedOptions = [];

          if (values != null) {
            for (final item in values!) {
              final existingItem = widget.data.singleWhere(
                (itm) => widget.valueKey(itm!) == widget.valueKey(item),
              );

              selectedOptions.add(
                GrxChip(
                  backgroundColor: GrxColors.cff1eb35e,
                  label: GrxCaptionText(
                    widget.displayText(existingItem),
                    color: GrxColors.cffffffff,
                  ),
                ),
              );
            }
          }

          return selectedOptions;
        }

        bool isEmpty() =>
            (field.value == null || (field.value?.isEmpty ?? true)) &&
            (values == null || values!.isEmpty);

        return GestureDetector(
          onTap: () async {
            field.setState(() {
              inputFocusNode.requestFocus();
            });

            final bottomSheet = GrxBottomSheetService(
              context: field.context,
              builder: (controller) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return GrxBottomSheetFormFieldBody<T>(
                      initialSelectedValues: values,
                      items: _list,
                      itemBuilder: widget.itemBuilder,
                      onFilterSetState: setModalState,
                      displayText: widget.displayText,
                      valueKey: widget.valueKey,
                      shrinkWrap: !widget.searchable,
                      searchable: widget.searchable,
                      quickSearchFieldController: quickSearchFieldController,
                      multiSelect: true,
                      confirmButtonLabel: widget.confirmButtonLabel,
                      cancelButtonLabel: widget.cancelButtonLabel,
                    );
                  },
                );
              },
            );

            final selectedValues = await bottomSheet.show<Iterable<T>>();

            if (selectedValues != null) {
              field.didChange(selectedValues);

              if (widget.onSelectItems != null) {
                widget.onSelectItems!(selectedValues);
              }

              setState(() {
                values = selectedValues;
              });
            }
          },
          child: Focus(
            focusNode: inputFocusNode,
            child: InputDecorator(
              baseStyle: const GrxCaptionLargeTextStyle(),
              decoration: GrxInputDecoration(
                errorText: field.errorText,
                labelText: widget.labelText,
                hintText: widget.hintText,
                enabled: widget.enabled,
                onClear: () {
                  values = [];
                  field.didChange(values);
                },
                showClearButton: !isEmpty(),
              ),
              isEmpty: isEmpty(),
              isFocused: inputFocusNode.hasFocus,
              child: (values?.isNotEmpty ?? false)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 2.0,
                        children: buildSelectedOptions(field),
                      ),
                    )
                  : const SizedBox(
                      height: 14,
                    ),
            ),
          ),
        );
      },
    );
  }
}

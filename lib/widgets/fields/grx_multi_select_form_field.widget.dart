import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:grex_ds/services/grx_bottom_sheet.service.dart';

import '../../models/grx_multi_select_body_item.model.dart';
import '../common/grx_chip.widget.dart';
import '../common/grx_multi_select_body.widget.dart';
import '../grx_stateful.widget.dart';
import 'grx_input_decoration.widget.dart';

class GrxMultiSelectFormField<T> extends GrxStatefulWidget {
  GrxMultiSelectFormField({
    super.key,
    required this.labelText,
    required this.onSaved,
    required this.data,
    required this.itemBuilder,
    required this.displayText,
    required this.valueKey,
    this.controller,
    this.hintText,
    this.initialValue,
    this.onSelectItems,
    this.validator,
    this.enabled = true,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Iterable<T> data;
  final Widget Function(BuildContext context, int index, T value,
      void Function() onChanged, bool isSelected) itemBuilder;
  final String Function(T data) displayText;
  final int Function(T data) valueKey;
  final Iterable<T>? initialValue;
  final void Function(Iterable<T>?)? onSelectItems;
  final FormFieldSetter<Iterable<T>> onSaved;
  final FormFieldValidator<Iterable<T>>? validator;
  final bool enabled;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;

  @override
  State<StatefulWidget> createState() => _GrxMultiSelectStateFormField<T>();
}

class _GrxMultiSelectStateFormField<T>
    extends State<GrxMultiSelectFormField<T>> {
  Iterable<T>? values;
  final List<T> _list = [];
  StateSetter? _setModalState;
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
      onSaved: (_) => widget.onSaved(values),
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

            final Iterable<T> initialSelected = values ?? <T>[];

            final list = <GrxMultiSelectBodyItem<T>>[];
            for (final item in widget.data) {
              final selectedItem = initialSelected.singleWhere(
                (x) => widget.valueKey(x) == widget.valueKey(item),
                orElse: () => item,
              );
              list.add(
                GrxMultiSelectBodyItem<T>(
                  selectedItem,
                  widget.displayText(item),
                ),
              );
            }

            final bottomSheet = GrxBottomSheetService(
              context: field.context,
              builder: (controller) {
                return GrxMultiSelectBody<T>(
                  initialSelectedValues: initialSelected,
                  items: list,
                  itemBuilder: widget.itemBuilder,
                  valueKey: widget.valueKey,
                  shrinkWrap: true,
                  confirmButtonLabel: widget.confirmButtonLabel,
                  cancelButtonLabel: widget.cancelButtonLabel,
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

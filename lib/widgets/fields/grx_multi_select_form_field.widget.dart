import 'package:flutter/material.dart';

import '../../extensions/list.extension.dart';
import '../../services/grx_bottom_sheet.service.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_label_large_text.style.dart';
import '../bottom_sheet/grx_bottom_sheet_form_field_body.widget.dart';
import '../grx_chip.widget.dart';
import '../grx_stateful.widget.dart';
import '../typography/grx_label_text.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_form_field.widget.dart';
import 'grx_input_decoration.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxMultiSelectFormField<T> extends GrxStatefulWidget {
  GrxMultiSelectFormField({
    final Key? key,
    required this.labelText,
    required this.data,
    required this.itemBuilder,
    required this.displayText,
    required this.valueKey,
    this.onSaved,
    this.controller,
    this.hintText,
    this.selectBottomSheetTitle,
    this.value,
    this.autovalidateMode = AutovalidateMode.always,
    this.onSelectItems,
    this.validator,
    this.enabled = true,
    this.flexible = false,
    this.searchable = false,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
    this.isLoading = false,
  }) : super(key: key ?? ValueKey<int>(labelText.hashCode));

  final GrxFormFieldController<T>? controller;
  final String labelText;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final Iterable<T> data;
  final Widget Function(
    BuildContext context,
    int index,
    T value,
    void Function()? onChanged,
    bool isSelected,
  )
  itemBuilder;
  final String Function(T data) displayText;
  final int Function(T data) valueKey;
  final Iterable<T>? value;
  final AutovalidateMode autovalidateMode;
  final void Function(Iterable<T>?)? onSelectItems;
  final FormFieldSetter<Iterable<T>>? onSaved;
  final FormFieldValidator<Iterable<T>>? validator;
  final bool enabled;
  final bool flexible;
  final bool searchable;
  final bool isLoading;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;

  @override
  State<StatefulWidget> createState() => _GrxMultiSelectStateFormField<T>();
}

class _GrxMultiSelectStateFormField<T>
    extends State<GrxMultiSelectFormField<T>> {
  Iterable<T>? values;
  final List<T> _list = [];
  late final GrxFormFieldController<T> controller;
  final TextEditingController quickSearchFieldController =
      TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _list.clear();
    _list.addAll(widget.data);

    controller = widget.controller ?? GrxFormFieldController<T>();

    if (widget.value != null && values == null) {
      values = widget.value;
      if (widget.onSelectItems != null) {
        widget.onSelectItems!(values);
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
      values = null;
    });

    controller.onDidUpdateData.stream.listen((data) {
      _list.assignAll(data);
    });

    controller.onDidUpdateValue.stream.listen((data) {
      final (value, _) = data;

      if (value == null) {
        controller.clear();
        return;
      }

      values = [...(values?.toList() ?? []), value];
      controller.text = widget.displayText(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(labelText: widget.labelText);
    }

    return GrxFormField<Iterable<T>>(
      initialValue: widget.value,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      onSaved: (_) => widget.onSaved != null ? widget.onSaved!(values) : null,
      enabled: widget.enabled,
      flexible: widget.flexible,
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
                  backgroundColor: GrxColors.success.shade300,
                  label: GrxLabelText(
                    widget.displayText(existingItem),
                    color: GrxColors.neutrals,
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
              title: widget.selectBottomSheetTitle,
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
              baseStyle: GrxLabelLargeTextStyle(),
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
              child:
                  (values?.isNotEmpty ?? false)
                      ? Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Wrap(
                          spacing: 4.0,
                          runSpacing: 2.0,
                          children: buildSelectedOptions(field),
                        ),
                      )
                      : const SizedBox(height: 14),
            ),
          ),
        );
      },
    );
  }
}

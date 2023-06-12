import 'package:flutter/material.dart';

import '../../services/grx_bottom_sheet.service.dart';
import '../../utils/grx_form_field.util.dart';
import '../bottom_sheet/grx_bottom_sheet_form_field_body.widget.dart';
import '../checkbox/grx_rounded_checkbox.widget.dart';
import '../grx_card.widget.dart';
import '../grx_stateful.widget.dart';
import '../typography/grx_headline_small_text.widget.dart';
import 'grx_form_field.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxDropdownFormField<T> extends GrxStatefulWidget {
  GrxDropdownFormField({
    final Key? key,
    required this.labelText,
    required this.data,
    required this.displayText,
    this.controller,
    this.itemBuilder,
    this.onSaved,
    this.hintText,
    this.selectBottomSheetTitle,
    this.initialValue,
    this.defaultValue,
    this.onSelectItem,
    this.validator,
    this.searchable = false,
    this.enabled = true,
    this.flexible = false,
    this.isLoading = false,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final Iterable<T> data;
  final Widget Function(BuildContext, int, T)? itemBuilder;
  final String Function(T data) displayText;
  final T? initialValue;
  final T? defaultValue;
  final void Function(T?)? onSelectItem;
  final void Function(T?)? onSaved;
  final String? Function(String?)? validator;
  final bool searchable;
  final bool enabled;
  final bool flexible;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxDropdownStateFormField<T>();
}

class _GrxDropdownStateFormField<T> extends State<GrxDropdownFormField<T>> {
  T? value;
  final List<T> _list = [];
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

  Widget _defaultItemBuild(BuildContext context, int index, T value) {
    return GrxCard(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GrxHeadlineSmallText(
              widget.displayText(value),
            ),
            GrxRoundedCheckbox(
              radius: 8.0,
              isTappable: false,
              initialValue: this.value == value,
            ),
          ],
        ),
      ),
    );
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
      validator: widget.validator,
      onSaved: (_) => widget.onSaved != null ? widget.onSaved!(value) : null,
      enabled: widget.enabled,
      flexible: widget.flexible,
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
              builder: (controller) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return GrxBottomSheetFormFieldBody<T>(
                      controller: controller,
                      onFilterSetState: setModalState,
                      displayText: widget.displayText,
                      quickSearchFieldController: quickSearchFieldController,
                      onSelectItem: widget.onSelectItem,
                      itemBuilder: (context, index, item, _, __) =>
                          (widget.itemBuilder ?? _defaultItemBuild)(
                              context, index, item),
                      items: _list,
                      searchable: widget.searchable,
                      shrinkWrap: !widget.searchable,
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

import 'dart:async';

import 'package:flutter/material.dart';

import '../../extensions/list.extension.dart';
import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import '../typography/grx_label_text.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_form_field.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

class GrxAutocompleteDropdownFormField<T> extends GrxStatefulWidget {
  GrxAutocompleteDropdownFormField({
    final Key? key,
    required this.labelText,
    required this.displayText,
    this.controller,
    this.itemBuilder,
    this.onSaved,
    this.hintText,
    this.selectBottomSheetTitle,
    this.value,
    this.defaultValue,
    this.autovalidateMode = AutovalidateMode.always,
    this.onSelectItem,
    this.onSearch,
    this.validator,
    this.searchable = false,
    this.enabled = true,
    this.flexible = false,
    this.isLoading = false,
    this.setValueOnSelectItem = true,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final GrxFormFieldController<String>? controller;
  final String labelText;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final Widget Function(BuildContext context, int index, T item,
      void Function(T) onSelectItem)? itemBuilder;
  final String Function(T data) displayText;
  final String? value;
  final String? defaultValue;
  final AutovalidateMode autovalidateMode;
  final void Function(T?)? onSelectItem;
  final Future<Iterable<T>?> Function(String?)? onSearch;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool searchable;
  final bool enabled;
  final bool flexible;
  final bool isLoading;
  final bool setValueOnSelectItem;

  @override
  State<StatefulWidget> createState() => _GrxDropdownStateFormField<T>();
}

class _GrxDropdownStateFormField<T>
    extends State<GrxAutocompleteDropdownFormField<T>> {
  final List<T> _list = [];

  late final GrxFormFieldController<String> controller;
  final MenuController menuController = MenuController();
  final TextEditingController quickSearchFieldController =
      TextEditingController();

  Timer? _timer;
  bool _isSearching = false;
  var _notifyListeners = true;

  @override
  void initState() {
    super.initState();

    _list.clear();

    controller = widget.controller ?? GrxFormFieldController<String>();

    if (widget.value != null) {
      controller.text = widget.value!;
    }

    _subscribeStreams();
  }

  @override
  void didUpdateWidget(GrxAutocompleteDropdownFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update value if the value prop changed
    if (widget.value != oldWidget.value) {
      if (widget.value != null) {
        controller.text = widget.value!;
      } else {
        controller.clear();
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    _cancelTimer();

    super.dispose();
  }

  void _subscribeStreams() {
    controller.onClearStream.stream.listen((_) {
      _list.clear();
    });

    controller.onDidUpdateValue.stream.listen((data) {
      final (value, notifyListeners) = data;

      _notifyListeners = notifyListeners;

      if (value?.isEmpty ?? true) {
        controller.clear();
        return;
      }

      controller.text = value!;
    });
  }

  void _cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _onSelectItem(T item) {
    if (widget.setValueOnSelectItem) {
      _notifyListeners = false;

      controller.text = widget.displayText(item);
    }

    widget.onSelectItem?.call(item);
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
      validator: (value) => widget.validator?.call(value),
      onSaved: (value) => widget.onSaved?.call(value),
      enabled: widget.enabled,
      flexible: widget.flexible,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: (value) {
            if (!_notifyListeners) {
              _notifyListeners = true;
              return;
            }

            _cancelTimer();

            _timer = Timer(
              const Duration(milliseconds: 500),
              () async {
                try {
                  setState(() {
                    _isSearching = true;
                  });
                  final result = await widget.onSearch?.call(value);

                  if (result != null) {
                    setState(() {
                      _list.clear();
                      _list.assignAll(result);
                    });

                    if (result.isNotEmpty) {
                      menuController.open();
                    } else {
                      menuController.close();
                    }
                  }
                } finally {
                  setState(() {
                    _isSearching = false;
                  });
                }
              },
            );
          },
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              controller: menuController,
              menuChildren: _list
                  .map<Widget>(
                    (item) =>
                        widget.itemBuilder?.call(context, _list.indexOf(item),
                            item, _onSelectItem) ??
                        MenuItemButton(
                          onPressed: () => _onSelectItem(item),
                          child: SizedBox(
                            width: constraints.constrainWidth() - 24,
                            child: GrxLabelText(
                              widget.displayText(item),
                            ),
                          ),
                        ),
                  )
                  .toList(),
              child: GrxTextField(
                controller: controller,
                hintText: widget.hintText,
                labelText: widget.labelText,
                errorText: field.errorText,
                enabled: widget.enabled,
                suffix: _isSearching
                    ? const CircularProgressIndicator.adaptive(
                        strokeWidth: 2.0,
                      )
                    : const SizedBox.shrink(),
                onClear: () {
                  menuController.close();

                  if (widget.defaultValue?.isNotEmpty ?? false) {
                    controller.text = widget.defaultValue!;
                  } else {
                    controller.clear();
                  }
                },
                onTap: () async {
                  if (menuController.isOpen) {
                    menuController.close();
                  } else if (_list.isNotEmpty) {
                    menuController.open();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

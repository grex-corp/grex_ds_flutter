import 'dart:async';

import 'package:flutter/material.dart';

import '../../enums/grx_autocomplete_loading_style.enum.dart';
import '../../extensions/list.extension.dart';
import '../../themes/spacing/grx_spacing.dart';
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
    this.debounceDuration = const Duration(milliseconds: 500),
    this.minChars = 0,
    this.emptyText,
    this.disableSearchOnSelect = true,
    this.loadingStyle = GrxAutocompleteLoadingStyle.shimmer,
  }) : super(key: key ?? ValueKey<int>(labelText.hashCode));

  final GrxFormFieldController<String>? controller;
  final String labelText;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final Widget Function(
    BuildContext context,
    int index,
    T item,
    void Function(T) onSelectItem,
  )?
  itemBuilder;
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
  final Duration debounceDuration;
  final int minChars;
  final String? emptyText;
  final bool disableSearchOnSelect;
  final GrxAutocompleteLoadingStyle loadingStyle;

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
  bool _ignoreNextSearch = false;

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
    // Close dropdown when item is selected
    menuController.close();

    if (widget.setValueOnSelectItem) {
      _notifyListeners = false;

      // Set flag to ignore the next search triggered by programmatic text update
      if (widget.disableSearchOnSelect) {
        _ignoreNextSearch = true;
      }

      controller.text = widget.displayText(item);
    }

    widget.onSelectItem?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    // Show shimmer if loading and loadingStyle is shimmer
    if (widget.isLoading &&
        widget.loadingStyle == GrxAutocompleteLoadingStyle.shimmer) {
      return GrxFormFieldShimmer(labelText: widget.labelText);
    }

    return GrxFormField<String>(
      initialValue: controller.text,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) => widget.validator?.call(value),
      onSaved: (value) => widget.onSaved?.call(value),
      enabled:
          widget.isLoading &&
                  widget.loadingStyle ==
                      GrxAutocompleteLoadingStyle.suffixSpinner
              ? false
              : widget.enabled,
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

            // Check if we should ignore this search (e.g., after item selection)
            if (_ignoreNextSearch) {
              _ignoreNextSearch = false;
              _cancelTimer();
              return;
            }

            _cancelTimer();

            // Check minChars requirement
            if (value.isEmpty || value.length < widget.minChars) {
              // Close dropdown if query is empty or doesn't meet minChars requirement
              menuController.close();
              setState(() {
                _list.clear();
              });
              return;
            }

            _timer = Timer(widget.debounceDuration, () async {
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
                    // Handle empty state
                    if (widget.emptyText != null) {
                      // Keep dropdown open with empty state message
                      menuController.open();
                    } else {
                      // Close dropdown if no emptyText provided (preserve current behavior)
                      menuController.close();
                    }
                  }
                }
              } finally {
                setState(() {
                  _isSearching = false;
                });
              }
            });
          },
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            // Build menu children: items or empty state
            final List<Widget> menuChildren = [];

            if (_list.isEmpty && widget.emptyText != null) {
              // Show empty state message (non-selectable)
              menuChildren.add(
                MenuItemButton(
                  onPressed: null, // Disabled
                  child: SizedBox(
                    width: constraints.constrainWidth() - 24,
                    child: GrxLabelText(widget.emptyText!),
                  ),
                ),
              );
            } else {
              // Show regular items
              menuChildren.addAll(
                _list.map<Widget>(
                  (item) =>
                      widget.itemBuilder?.call(
                        context,
                        _list.indexOf(item),
                        item,
                        _onSelectItem,
                      ) ??
                      MenuItemButton(
                        onPressed: () => _onSelectItem(item),
                        child: SizedBox(
                          width: constraints.constrainWidth() - 24,
                          child: GrxLabelText(widget.displayText(item)),
                        ),
                      ),
                ),
              );
            }

            return MenuAnchor(
              controller: menuController,
              menuChildren: menuChildren,
              child: GrxTextField(
                controller: controller,
                hintText: widget.hintText,
                labelText: widget.labelText,
                errorText: field.errorText,
                enabled:
                    widget.isLoading &&
                            widget.loadingStyle ==
                                GrxAutocompleteLoadingStyle.suffixSpinner
                        ? false
                        : widget.enabled,
                suffix:
                    (_isSearching ||
                            (widget.isLoading &&
                                widget.loadingStyle ==
                                    GrxAutocompleteLoadingStyle.suffixSpinner))
                        ? Padding(
                          padding: EdgeInsets.only(
                            right: _isSearching ? GrxSpacing.xs : 0,
                          ),
                          child: const CircularProgressIndicator.adaptive(
                            strokeWidth: 2.0,
                          ),
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

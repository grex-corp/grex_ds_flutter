import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../buttons/grx_primary_button.widget.dart';
import '../buttons/grx_secondary_button.widget.dart';
import '../fields/grx_filter_field.widget.dart';
import '../typography/grx_caption_large_text.widget.dart';

class GrxBottomSheetFormFieldBody<T> extends StatefulWidget {
  const GrxBottomSheetFormFieldBody({
    super.key,
    this.controller,
    this.onFilterSetState,
    this.displayText,
    this.quickSearchFieldController,
    this.onSelectItem,
    required this.itemBuilder,
    required this.items,
    this.onChangeState,
    this.initialSelectedValues,
    this.valueKey,
    this.shrinkWrap = false,
    this.searchable = true,
    this.multiSelect = false,
    this.searchHintText,
    this.emptyListText,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
  })  : assert((!multiSelect && onChangeState != null) ||
            (multiSelect && valueKey != null)),
        assert(!searchable ||
            (searchable &&
                quickSearchFieldController != null &&
                onFilterSetState != null &&
                displayText != null));

  final ScrollController? controller;
  final StateSetter? onFilterSetState;
  final String Function(T data)? displayText;
  final TextEditingController? quickSearchFieldController;
  final void Function(T?)? onSelectItem;
  final Widget Function(BuildContext context, int index, T value,
      void Function()? onChanged, bool isSelected) itemBuilder;
  final Iterable<T> items;
  final void Function(T)? onChangeState;
  final Iterable<T>? initialSelectedValues;
  final int Function(T data)? valueKey;
  final bool shrinkWrap;
  final bool searchable;
  final bool multiSelect;
  final String? searchHintText;
  final String? emptyListText;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;

  @override
  State<StatefulWidget> createState() => _GrxBottomSheetFormFieldBodyState<T>();
}

class _GrxBottomSheetFormFieldBodyState<T> extends State<GrxBottomSheetFormFieldBody<T>> {
  final _list = <T>[];
  final _selectedValues = <T>[];

  @override
  void initState() {
    super.initState();

    _list.clear();
    _list.addAll(widget.items);

    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }

  void _onItemCheckedChange(T itemValue) {
    final checked = _selectedValues.contains(itemValue);

    setState(() {
      if (!checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _filterData(String val) {
    void filter() {
      _list.clear();
      _list.addAll(
        widget.items.where(
          (x) =>
              val.isEmpty ||
              widget.displayText!(x).toString().toLowerCase().contains(
                    val.toLowerCase(),
                  ),
        ),
      );
    }

    widget.onFilterSetState != null
        ? widget.onFilterSetState!(
            () {
              filter();
            },
          )
        : filter();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomScrollView(
            controller: widget.controller,
            shrinkWrap: widget.shrinkWrap,
            slivers: [
              if (widget.searchable)
                SliverAppBar(
                  titleSpacing: 0.0,
                  toolbarHeight: 65,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Container(
                    color: GrxColors.cfff2f7fd,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: GrxFilterField(
                      searchFieldController: widget.quickSearchFieldController!,
                      onChanged: _filterData,
                      hintText: widget.searchHintText ?? 'Search',
                    ),
                  ),
                ),
              _list.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: GrxCaptionLargeText(
                              widget.emptyListText ?? 'No results found'),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.only(
                        left: 8,
                        top: 8,
                        right: 8,
                        bottom: !widget.multiSelect
                            ? MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.of(context).padding.bottom +
                                8
                            : 0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: _list.length,
                          (context, index) {
                            final item = _list.toList()[index];

                            if (widget.multiSelect) {
                              return widget.itemBuilder(
                                context,
                                index,
                                item,
                                () => _onItemCheckedChange(item),
                                _selectedValues.any(
                                  (element) =>
                                      widget.valueKey!(element) ==
                                      widget.valueKey!(item),
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);

                                  if (widget.onSelectItem != null) {
                                    widget.onSelectItem!(item);
                                  }
                                  widget.onChangeState!(item);
                                },
                                child: widget.itemBuilder(
                                  context,
                                  index,
                                  item,
                                  null,
                                  false,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
        if (widget.multiSelect)
          Container(
            decoration: const BoxDecoration(
              color: GrxColors.cfff2f7fd,
              border: Border(
                top: BorderSide(
                  color: GrxColors.cffe0efff,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              top: 12.0,
              right: 16.0,
              left: 16.0,
              bottom: mediaQuery.viewInsets.bottom +
                  mediaQuery.padding.bottom +
                  12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GrxSecondaryButton(
                    text: widget.cancelButtonLabel ?? 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: GrxPrimaryButton(
                    text: widget.confirmButtonLabel ?? 'Confirm',
                    onPressed: () {
                      Navigator.pop(context, _selectedValues);
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

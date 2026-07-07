import 'dart:async';

import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../../utils/grx_text_sanitizer.util.dart';
import '../buttons/grx_primary_button.widget.dart';
import '../buttons/grx_secondary_button.widget.dart';
import '../fields/grx_search_field.widget.dart';
import '../typography/grx_label_large_text.widget.dart';

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
    this.includeListBottomSafeAreaPadding = true,
  }) : assert((!multiSelect && onChangeState != null) || (multiSelect && valueKey != null)),
       assert(
         !searchable ||
             (searchable && quickSearchFieldController != null && onFilterSetState != null && displayText != null),
       );

  final ScrollController? controller;
  final StateSetter? onFilterSetState;
  final String Function(T data)? displayText;
  final TextEditingController? quickSearchFieldController;
  final void Function(T?)? onSelectItem;
  final Widget Function(BuildContext context, int index, T value, void Function()? onChanged, bool isSelected)
  itemBuilder;
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
  final bool includeListBottomSafeAreaPadding;

  @override
  State<StatefulWidget> createState() => _GrxBottomSheetFormFieldBodyState<T>();
}

class _GrxBottomSheetFormFieldBodyState<T> extends State<GrxBottomSheetFormFieldBody<T>> {
  static const _kSearchFieldHeight = 48.0;
  static const _kSearchDebounceDuration = Duration(milliseconds: 500);

  final _list = <T>[];
  final _selectedValues = <T>[];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _list.clear();
    _list.addAll(widget.items);

    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
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

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_kSearchDebounceDuration, () => _filterData(value));
  }

  void _filterData(String val) {
    void filter() {
      _list.clear();
      _list.addAll(
        widget.items.where(
          (x) => val.isEmpty || GrxTextSanitizer.matchesSearch(val, widget.displayText!(x).toString()),
        ),
      );
    }

    widget.onFilterSetState != null
        ? widget.onFilterSetState!(() {
          filter();
        })
        : filter();
  }

  Widget _buildFloatingSearchSliver() {
    return SliverAppBar(
      primary: false,
      floating: true,
      snap: true,
      pinned: false,
      toolbarHeight: 0,
      automaticallyImplyLeading: false,
      backgroundColor: GrxColors.background,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(GrxSpacing.xs + _kSearchFieldHeight + GrxSpacing.s),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(GrxSpacing.s, GrxSpacing.xs, GrxSpacing.s, GrxSpacing.s),
          child: GrxSearchField(
            searchFieldController: widget.quickSearchFieldController!,
            onChanged: _onSearchChanged,
            hintText: widget.searchHintText ?? 'Search',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final listBottomPadding =
        widget.multiSelect
            ? 0.0
            : widget.includeListBottomSafeAreaPadding
            ? mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom + GrxSpacing.s
            : 0.0;

    final listContent = ColoredBox(
      color: GrxColors.background,
      child: CustomScrollView(
        controller: widget.controller,
        shrinkWrap: widget.shrinkWrap,
        slivers: [
          if (widget.searchable) ...[_buildFloatingSearchSliver()],
          _list.isEmpty
              ? SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GrxLabelLargeText(widget.emptyListText ?? 'No results found'),
                    ),
                  ),
                ),
              )
              : SliverPadding(
                padding: EdgeInsets.only(
                  left: GrxSpacing.s,
                  top: GrxSpacing.s,
                  right: GrxSpacing.s,
                  bottom: listBottomPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: _list.length, (context, index) {
                    final item = _list[index];

                    if (widget.multiSelect) {
                      return widget.itemBuilder(
                        context,
                        index,
                        item,
                        () => _onItemCheckedChange(item),
                        _selectedValues.any((element) => widget.valueKey!(element) == widget.valueKey!(item)),
                      );
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, true);

                        if (widget.onSelectItem != null) {
                          widget.onSelectItem!(item);
                        }
                        widget.onChangeState!(item);
                      },
                      child: widget.itemBuilder(context, index, item, null, false),
                    );
                  }),
                ),
              ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: listContent),
        if (widget.multiSelect)
          Container(
            decoration: BoxDecoration(
              color: GrxColors.neutrals,
              border: Border(top: BorderSide(color: GrxColors.primary.shade50, width: 1)),
            ),
            padding: EdgeInsets.only(
              top: 12.0,
              right: 16.0,
              left: 16.0,
              bottom: mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom + 12.0,
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
                const SizedBox(width: 12),
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

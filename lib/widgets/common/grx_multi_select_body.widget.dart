import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../../models/grx_multi_select_body_item.model.dart';

class GrxMultiSelectBody<T> extends StatefulWidget {
  const GrxMultiSelectBody({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.valueKey,
    this.initialSelectedValues,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
    this.shrinkWrap = false,
  });

  final Iterable<GrxMultiSelectBodyItem<T>> items;
  final Iterable<T>? initialSelectedValues;
  final Widget Function(BuildContext context, int index, T value,
      void Function() onChanged, bool isSelected) itemBuilder;
  final int Function(T data) valueKey;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;
  final bool shrinkWrap;

  @override
  State<StatefulWidget> createState() => _GrxMultiSelectBodyState<T>();
}

class _GrxMultiSelectBodyState<T> extends State<GrxMultiSelectBody<T>> {
  final _selectedValues = <T>[];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: widget.items.length,
            shrinkWrap: widget.shrinkWrap,
            itemBuilder: (context, index) {
              final item = widget.items.toList()[index];

              return widget.itemBuilder(
                context,
                index,
                item.value,
                () => _onItemCheckedChange(item.value),
                _selectedValues.any(
                  (element) =>
                      widget.valueKey(element) == widget.valueKey(item.value),
                ),
              );
            },
          ),
        ),
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
            bottom:
                mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom + 12.0,
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

import 'package:flutter/material.dart';
import 'package:grex_ds/widgets/typography/grx_caption_large_text.widget.dart';

import '../../themes/colors/grx_colors.dart';
import '../fields/grx_filter_field.widget.dart';

class GrxDropdownBody<T> extends StatelessWidget {
  const GrxDropdownBody({
    super.key,
    this.controller,
    required this.filterData,
    required this.quickSearchFieldController,
    this.onSelectItem,
    required this.itemBuilder,
    required this.list,
    required this.changeState,
    this.shrinkWrap = false,
    this.searchHintText,
    this.emptyListText,
  });

  final ScrollController? controller;
  final void Function(String val) filterData;
  final TextEditingController quickSearchFieldController;
  final void Function(T?)? onSelectItem;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final List<T> list;
  final void Function(T) changeState;
  final bool shrinkWrap;
  final String? searchHintText;
  final String? emptyListText;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      slivers: [
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
              searchFieldController: quickSearchFieldController,
              onChanged: filterData,
              hintText: searchHintText ?? 'Search',
            ),
          ),
        ),
        list.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GrxCaptionLargeText(
                        emptyListText ?? 'No results found'),
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.only(
                  left: 8,
                  top: 15,
                  right: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      MediaQuery.of(context).padding.bottom +
                      8,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: list.length,
                    (context, index) {
                      final item = list[index];

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, true);

                          if (onSelectItem != null) {
                            onSelectItem!(item);
                          }
                          changeState(item);
                        },
                        child: itemBuilder(context, index, item),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}

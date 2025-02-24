import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../animations/grx_fade_transition.animation.dart';
import 'grx_spinner_loading.widget.dart';
import 'headers/grx_searchable_sliver_header.widget.dart';
import 'list/grx_list_empty.widget.dart';
import 'list/grx_list_error.widget.dart';
import 'list/grx_list_infinite_loading.widget.dart';
import 'list/grx_list_infinite_loading_error.widget.dart';
import 'list/grx_list_loading.widget.dart';

class GrxSliverAnimatedList<T> extends StatelessWidget {
  const GrxSliverAnimatedList({
    super.key,
    required this.animationController,
    required this.itemBuilder,
    this.separatorBuilder,
    this.loadingItemBuilder,
    this.onRefresh,
    this.list,
    this.pagingController,
    this.title,
    this.header,
    this.padding,
    this.canPop = false,
  }) : assert(title != null || header != null),
       assert(list != null || pagingController != null);

  final AnimationController animationController;
  final Widget Function(T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function()? loadingItemBuilder;
  final Future<void> Function()? onRefresh;
  final Iterable<T>? list;
  final PagingController<int, T>? pagingController;
  final String? title;
  final Widget? header;
  final EdgeInsets? padding;
  final bool canPop;

  Widget _buildItem(Widget child, int length, int index) {
    final begin = clampDouble((1 / (length / index * 12)) * index, 0, 1);

    final contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(begin, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (context, child) {
        return GrxFadeTransition(animation: contentAnimation, child: child!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return CustomScrollView(
      physics:
          [
                TargetPlatform.iOS,
                TargetPlatform.macOS,
              ].any((platform) => platform == defaultTargetPlatform)
              ? null
              : const BouncingScrollPhysics(),
      slivers: [
        header ??
            GrxSearchableSliverHeader(
              animationController: animationController,
              canPop: canPop,
              title: title!,
            ),
        if (onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh!,
            builder:
                (_, __, ___, ____, _____) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GrxSpinnerLoading(),
                  ),
                ),
          ),
        SliverPadding(
          padding: EdgeInsets.only(
            left: this.padding?.left ?? 0.0,
            top: this.padding?.top ?? 0.0,
            right: this.padding?.right ?? 0.0,
            bottom: (this.padding?.bottom ?? 16.0) + padding.bottom,
          ),
          sliver:
              pagingController != null
                  ? PagingListener(
                    controller: pagingController!,

                    builder: (context, state, fetchNextPage) {
                      return PagedSliverList<int, T>.separated(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        separatorBuilder:
                            separatorBuilder ??
                            (context, index) => const SizedBox.shrink(),
                        builderDelegate: PagedChildBuilderDelegate<T>(
                          firstPageProgressIndicatorBuilder: (context) {
                            const loadingListSize = 10;

                            return GrxListLoading(
                              itemBuilder:
                                  (index) => _buildItem(
                                    loadingItemBuilder!(),
                                    loadingListSize,
                                    index,
                                  ),
                              separatorBuilder: separatorBuilder,
                              animationController: animationController,
                            );
                          },
                          firstPageErrorIndicatorBuilder:
                              (context) => GrxListError(
                                title: 'Algo deu errado!',
                                subTitle:
                                    'Encontramos um erro desconhecido ao tentar processar seus dados, por gentileza, tente novamente!',
                                animationController: animationController,
                              ),
                          noItemsFoundIndicatorBuilder:
                              (context) => GrxListEmpty(
                                title: 'Nenhum item encontrado!',
                                subTitle:
                                    'Não encontramos nenhum item para exibir.',
                                animationController: animationController,
                              ),
                          newPageErrorIndicatorBuilder:
                              (context) => GrxListInfiniteLoadingError(
                                text:
                                    'Algo deu errado, por favor, tente novamente!',
                                onTap: pagingController!.refresh,
                              ),
                          newPageProgressIndicatorBuilder:
                              (context) => const GrxListInfiniteLoading(),
                          itemBuilder:
                              (context, item, index) => _buildItem(
                                itemBuilder(item, index),
                                pagingController!.items!.length,
                                index,
                              ),
                        ),
                      );
                    },
                  )
                  : SuperSliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildItem(
                        itemBuilder(list!.elementAt(index), index),
                        list!.length,
                        index,
                      ),
                      childCount: list!.length,
                    ),
                  ),
        ),
      ],
    );
  }
}

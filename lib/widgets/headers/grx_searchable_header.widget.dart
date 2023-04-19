import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../animations/grx_fade_transition.animation.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/system_overlay/grx_system_overlay.style.dart';
import '../fields/grx_search_field.widget.dart';
import 'grx_header.widget.dart';

class GrxSearchableHeader extends StatefulWidget {
  const GrxSearchableHeader({
    super.key,
    required this.title,
    this.animationProgress = 0,
    this.animationController,
    this.hintText,
    this.actions,
    this.onQuickSearchHandler,
    this.searchFieldController,
    this.canPop = false,
  });

  final String title;
  final double animationProgress;
  final AnimationController? animationController;
  final String? hintText;
  final List<Widget>? actions;
  final void Function(String)? onQuickSearchHandler;
  final TextEditingController? searchFieldController;
  final bool canPop;

  @override
  State<StatefulWidget> createState() {
    return _GrxSearchableHeaderState();
  }
}

class _GrxSearchableHeaderState extends State<GrxSearchableHeader> {
  late final animationController = widget.animationController!;

  late final Animation<double> topBarAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
    ),
  );

  late final Animation<double> searchBarAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.8, curve: Curves.fastOutSlowIn),
    ),
  );

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return GrxFadeTransition(
              animation: topBarAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: GrxColors.cfff2f7fd.withOpacity(
                    widget.animationProgress,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: GrxColors.cff8795a9
                          .withOpacity(0.4 * widget.animationProgress),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.lerp(
                        EdgeInsets.only(
                          bottom: widget.onQuickSearchHandler == null ? 0 : 15,
                        ),
                        EdgeInsets.only(
                          bottom: widget.onQuickSearchHandler == null ? 0 : 0,
                        ),
                        widget.animationProgress,
                      )!,
                      child: GrxHeader(
                        title: widget.title,
                        actions: widget.actions ?? [],
                        showBackButton: widget.canPop,
                        animationProgress: widget.animationProgress,
                        systemOverlayStyle: GrxSystemOverlayStyle.dark,
                      ),
                    ),
                    if (widget.onQuickSearchHandler != null)
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return GrxFadeTransition(
                            animation: searchBarAnimation,
                            child: Padding(
                              padding: EdgeInsets.lerp(
                                const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                EdgeInsets.zero,
                                widget.animationProgress,
                              )!,
                              child: Visibility(
                                visible: widget.animationProgress < 0.99,
                                child: Opacity(
                                  opacity: 1 - widget.animationProgress,
                                  child: SizedBox(
                                    height: 48 - 48 * widget.animationProgress,
                                    child: GrxSearchField(
                                      searchFieldController:
                                          widget.searchFieldController,
                                      onChanged: (String value) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(
                                              milliseconds: 500,
                                            ), () {
                                          if (widget.onQuickSearchHandler != null) {
                                            widget.onQuickSearchHandler!(
                                              value,
                                            );
                                          }
                                        });
                                      },
                                      hintText:
                                          widget.hintText ?? 'Pesquise Aqui',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

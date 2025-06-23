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
    required this.animationController,
    this.animationProgress = 0,
    this.hintText,
    this.actions,
    this.onQuickSearchHandler,
    this.searchFieldController,
    this.extraWidget,
    this.canPop = false,
  });

  final String title;
  final AnimationController animationController;
  final double animationProgress;
  final String? hintText;
  final List<Widget>? actions;
  final void Function(String)? onQuickSearchHandler;
  final TextEditingController? searchFieldController;
  final Widget? extraWidget;
  final bool canPop;

  @override
  State<StatefulWidget> createState() {
    return _GrxSearchableHeaderState();
  }
}

class _GrxSearchableHeaderState extends State<GrxSearchableHeader> {
  late final animationController = widget.animationController;

  late final Animation<double> topBarAnimation = Tween<double>(
    begin: .2,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.9, curve: Curves.fastOutSlowIn),
    ),
  );

  late final Animation<double> searchBarAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.8, curve: Curves.fastOutSlowIn),
    ),
  );

  late final Animation<double> extraWidgetAnimation = Tween<double>(
    begin: 0.2,
    end: 1,
  ).animate(
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: GrxColors.primary.shade600,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.lerp(
                          const Radius.circular(0),
                          const Radius.circular(32.0),
                          widget.animationProgress,
                        )!,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: GrxColors.neutrals.shade500.withValues(
                        alpha: 64 * widget.animationProgress,
                      ),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.lerp(
                            EdgeInsets.only(
                              bottom:
                                  widget.onQuickSearchHandler == null
                                      ? 0.0
                                      : 8.0,
                            ),
                            EdgeInsets.only(
                              bottom:
                                  widget.onQuickSearchHandler == null ? 0.0 : 0,
                            ),
                            widget.animationProgress,
                          )!,
                      child: GrxHeader(
                        title: widget.title,
                        actions: widget.actions ?? [],
                        showBackButton: widget.canPop,
                        animationProgress: widget.animationProgress,
                        foregroundColor: GrxColors.neutrals,
                        systemOverlayStyle: GrxSystemOverlayStyle.light,
                      ),
                    ),
                    if (widget.onQuickSearchHandler != null)
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return GrxFadeTransition(
                            animation: searchBarAnimation,
                            child: Padding(
                              padding:
                                  EdgeInsets.lerp(
                                    EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      bottom:
                                          widget.extraWidget != null
                                              ? 0.0
                                              : 8.0,
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
                                          const Duration(milliseconds: 500),
                                          () {
                                            if (widget.onQuickSearchHandler !=
                                                null) {
                                              widget.onQuickSearchHandler!(
                                                value,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      hintText:
                                          widget.hintText ?? 'Pesquise aqui',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    if (widget.extraWidget != null)
                      AnimatedBuilder(
                        animation: animationController,
                        child: widget.extraWidget!,
                        builder: (context, child) {
                          return GrxFadeTransition(
                            animation: extraWidgetAnimation,
                            child: child!,
                          );
                        },
                      ),
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

import 'package:flutter/material.dart';
import 'package:grex_ds/utils/grx_utils.util.dart';

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    super.fullscreenDialog,
    super.settings,
    required this.builder,
    this.duration = GrxUtils.defaultAnimationDuration,
  });

  final Widget Function(BuildContext) builder;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

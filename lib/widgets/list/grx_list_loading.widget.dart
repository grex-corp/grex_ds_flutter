import 'package:flutter/widgets.dart';

import '../../animations/grx_fade_transition.animation.dart';
import '../grx_spinner_loading.widget.dart';

class GrxListLoading extends StatelessWidget {
  GrxListLoading({
    super.key,
    this.listSize = 10,
    this.itemBuilder,
    this.separatorBuilder,
    this.animationController,
  }) : animation = animationController != null
            ? Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(
                    0.2,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
              )
            : null;

  final int listSize;
  final Widget Function(int index)? itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    const defaultLoadingWidget = Center(
      child: GrxSpinnerLoading(),
    );

    return itemBuilder != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < listSize; i++) ...[
                itemBuilder!(i),
                if (i < listSize && separatorBuilder != null)
                  separatorBuilder!(context, i),
              ],
            ],
          )
        : animationController != null
            ? AnimatedBuilder(
                animation: animationController!,
                child: defaultLoadingWidget,
                builder: (context, child) {
                  return GrxFadeTransition(
                    animation: animation!,
                    child: child!,
                  );
                },
              )
            : defaultLoadingWidget;
  }
}

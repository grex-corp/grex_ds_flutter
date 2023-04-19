import 'package:flutter/widgets.dart';

class GrxFadeTransition extends FadeTransition {
  GrxFadeTransition({
    super.key,
    required final Widget child,
    required final Animation<double> animation,
  }) : super(
          opacity: animation,
          child: Transform(
            transform:
                Matrix4.translationValues(0, 30 * (1 - animation.value), 0),
            child: child,
          ),
        );
}

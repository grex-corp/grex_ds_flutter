import 'package:flutter/rendering.dart';

abstract class GrxButtonUtils {
  static const double kButtonSize = 48.0;
  static const EdgeInsets kButtonPadding = EdgeInsets.all(8.0);

  static double buttonAnimationProgressCalc(
    double progress, {
    double? buttonSize,
  }) => (buttonSize ?? kButtonSize) - 8 * progress;

  static EdgeInsets buttonAnimationProgressPaddingCalc(
    double progress, {
    EdgeInsets? padding = kButtonPadding,
  }) {
    final reducedPadding = padding?.copyWith(
      bottom: (padding.bottom) * 0.8,
      left: (padding.left) * 0.8,
      right: (padding.right) * 0.8,
      top: (padding.top) * 0.8,
    );

    return EdgeInsets.lerp(padding, reducedPadding, progress)!;
  }
}

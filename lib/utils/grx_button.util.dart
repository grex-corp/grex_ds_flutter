abstract class GrxButtonUtils {
  static const double kButtonSize = 48.0;

  static double buttonAnimationProgressCalc(
    double progress, {
    double? buttonSize,
  }) =>
      (buttonSize ?? kButtonSize) - 8 * progress;
}

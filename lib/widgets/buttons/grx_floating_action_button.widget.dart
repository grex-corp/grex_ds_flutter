import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../utils/grx_utils.util.dart';

const _kSize = 70.0;
const _kBorder = _kSize / 2.0;
const _kBorderRadius = BorderRadius.all(Radius.circular(_kBorder));
final _kShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kBorder));

class GrxFloatingActionButton extends StatelessWidget {
  const GrxFloatingActionButton({
    super.key,
    this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  final Widget? icon;
  final void Function()? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
          shape: _kShape, padding: const EdgeInsets.all(0.0), elevation: 0),
      child: Material(
        elevation: 10,
        shape: _kShape,
        child: AnimatedContainer(
          duration: GrxUtils.defaultAnimationDuration,
          decoration: BoxDecoration(
            gradient: isLoading
                ? const LinearGradient(
                    begin: Alignment(-0.7, -2.5),
                    end: Alignment(0.1, 0.4),
                    colors: <Color>[
                      GrxColors.c7057de91,
                      GrxColors.c7075f3aa,
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment(-0.7, -2.5),
                    end: Alignment(0.1, 0.4),
                    colors: <Color>[
                      GrxColors.cff1eb35e,
                      GrxColors.cff75f3ab,
                    ],
                  ),
            borderRadius: _kBorderRadius,
          ),
          child: CustomPaint(
            painter: _GradientPainter(
              strokeWidth: 1.5,
              radius: _kBorder,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  GrxColors.cff93ffcf,
                  GrxColors.cff75f3ab,
                ],
              ),
            ),
            child: Container(
              height: _kSize,
              width: _kSize,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: GrxUtils.defaultAnimationDuration,
                child: isLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                      )
                    : icon ??
                        const Icon(
                          GrxIcons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

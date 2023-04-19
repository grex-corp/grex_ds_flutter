import 'dart:math' as math;

import 'package:flutter/material.dart';

class TabClipper extends CustomClipper<Path> {
  TabClipper({
    this.radius = 38.0,
  });

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2.0;

    path.lineTo(0.0, 0.0);
    path.arcTo(
      Rect.fromLTWH(0.0, 0.0, radius, radius),
      degreeToRadians(180.0),
      degreeToRadians(90.0),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        ((size.width / 2.0) - v / 2.0) - radius + v * 0.04,
        0.0,
        radius,
        radius,
      ),
      degreeToRadians(270.0),
      degreeToRadians(70.0),
      false,
    );

    path.arcTo(
      Rect.fromLTWH((size.width / 2.0) - v / 2.0, -v / 2.0, v, v),
      degreeToRadians(160.0),
      degreeToRadians(-140.0),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        (size.width - ((size.width / 2.0) - v / 2.0)) - v * 0.04,
        0.0,
        radius,
        radius,
      ),
      degreeToRadians(200.0),
      degreeToRadians(70.0),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        size.width - radius,
        0.0,
        radius,
        radius,
      ),
      degreeToRadians(270.0),
      degreeToRadians(90.0),
      false,
    );

    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180.0) * degree;
    return redian;
  }
}

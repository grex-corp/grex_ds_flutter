import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/radius/grx_radius.dart';

class GrxShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final BoxDecoration? decoration;

  GrxShimmer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = GrxRadius.round,
    this.decoration,
    final Color? baseColor,
    final Color? highlightColor,
  }) : baseColor = baseColor ?? GrxColors.primary.shade50,
       highlightColor = highlightColor ?? GrxColors.primary.shade200;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: height,
              maxWidth: width,
              minHeight: height,
              minWidth: width,
            ),
            decoration:
                decoration ??
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
          ),
        ),
      ],
    );
  }
}

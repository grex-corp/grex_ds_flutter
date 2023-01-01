import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/colors/grx_colors.dart';

class GrxShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final BoxDecoration? decoration;

  const GrxShimmer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 20,
    this.baseColor = GrxColors.cffeeeeee,
    this.highlightColor = GrxColors.cfffafafa,
    this.decoration,
  });

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
            decoration: decoration ??
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

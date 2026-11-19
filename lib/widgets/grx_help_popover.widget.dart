import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/radius/grx_radius.dart';
import '../themes/spacing/grx_spacing.dart';

class GrxHelpPopover extends StatelessWidget {
  const GrxHelpPopover({
    super.key,
    required this.anchor,
    required this.width,
    required this.child,
  });

  final Rect anchor;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final padding = media.padding;
    final gap = GrxSpacing.s;
    final cardWidth = math.min(width, screen.width - GrxSpacing.l);
    final left = (screen.width - cardWidth) / 2;
    final spaceAbove = anchor.top - padding.top - gap;
    final spaceBelow = screen.height - anchor.bottom - padding.bottom - gap;
    final above = spaceAbove >= spaceBelow;
    final maxHeight = math.max(0.0, above ? spaceAbove : spaceBelow);
    final arrowLeft = (anchor.center.dx - left - GrxSpacing.xs)
        .clamp(GrxSpacing.m, math.max(GrxSpacing.m, cardWidth - GrxSpacing.ml))
        .toDouble();

    return Stack(
      children: [
        Positioned(
          left: left,
          width: cardWidth,
          top: above ? null : anchor.bottom + gap,
          bottom: above ? screen.height - anchor.top + gap : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: GrxColors.neutrals,
                    borderRadius: BorderRadius.circular(GrxRadius.sm),
                  ),
                  child: SingleChildScrollView(child: child),
                ),
              ),
              Positioned(
                left: arrowLeft,
                top: above ? null : -GrxSpacing.xs,
                bottom: above ? -GrxSpacing.xs : null,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: const ColoredBox(
                    color: GrxColors.neutrals,
                    child: SizedBox.square(dimension: GrxSpacing.sm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

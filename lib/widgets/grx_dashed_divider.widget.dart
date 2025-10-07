import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../themes/colors/grx_colors.dart';
import '../themes/typography/styles/grx_label_small_text.style.dart';
import 'typography/grx_label_small_text.widget.dart';

class GrxDashedDivider extends StatelessWidget {
  GrxDashedDivider({
    super.key,
    this.title,
    this.padding = EdgeInsets.zero,
    this.stroke = 1.0,
    this.dashSize = 3.0,
    final Color? color,
  }) : color = color ?? GrxColors.primary.shade600;

  final String? title;
  final EdgeInsets padding;
  final double stroke;
  final double dashSize;
  final Color color;

  double _getTextWidth(BoxConstraints constraints) {
    const textStyle = GrxLabelSmallTextStyle();

    final renderParagraph = RenderParagraph(
      TextSpan(text: title, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    renderParagraph.layout(constraints);

    return renderParagraph
        .getMinIntrinsicWidth(textStyle.fontSize!)
        .ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = dashSize;
          final dashHeight = stroke;

          final textLen = _getTextWidth(constraints);

          final dashCount = ((boxWidth - textLen) / (2 * dashWidth)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              title?.isNotEmpty ?? false
                  ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GrxLabelSmallText(
                      title!,
                      color: GrxColors.primary.shade900,
                    ),
                  )
                  : const SizedBox.shrink(),
              ...List.generate(dashCount, (_) {
                return SizedBox(
                  width: dashWidth,
                  height: dashHeight,
                  child: DecoratedBox(decoration: BoxDecoration(color: color)),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

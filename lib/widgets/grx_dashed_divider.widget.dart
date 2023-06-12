import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_overline_text.style.dart';
import 'typography/grx_overline_text.widget.dart';

class GrxDashedDivider extends StatelessWidget {
  const GrxDashedDivider({
    super.key,
    this.title,
    this.padding = EdgeInsets.zero,
    this.stroke = 1.0,
    this.dashSize = 3.0,
    this.color = GrxColors.cffc8e2ff,
  });

  final String? title;
  final EdgeInsets padding;
  final double stroke;
  final double dashSize;
  final Color color;

  double _getTextWidth(BoxConstraints constraints) {
    const textStyle = GrxOverlineTextStyle();

    final renderParagraph = RenderParagraph(
      TextSpan(
        text: title,
        style: textStyle,
      ),
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
                      child: GrxOverlineText(
                        title!,
                        color: GrxColors.cff7892b7,
                      ),
                    )
                  : const SizedBox.shrink(),
              ...List.generate(
                dashCount,
                (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: dashHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: color),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}

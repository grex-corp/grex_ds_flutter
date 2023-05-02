import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../grx_shimmer.widget.dart';

/// A container that has some default properties which should be extended by others Design System's [Text].
class GrxText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxText(
    this.text, {
    super.key,
    required this.style,
    this.transform = GrxTextTransform.none,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isLoading = false,
  }) : textSpan = null;

  const GrxText.rich(
    this.textSpan, {
    super.key,
    required this.style,
    this.transform = GrxTextTransform.none,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isLoading = false,
  }) : text = null;

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final TextStyle style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final renderParagraph = RenderParagraph(
            textSpan ??
                TextSpan(
                  text: _capitalize(text),
                  style: style,
                ),
            textDirection: TextDirection.ltr,
            maxLines: maxLines ?? 1,
          );

          renderParagraph.layout(constraints);

          final height = renderParagraph.getMinIntrinsicHeight(style.fontSize!);
          final width = renderParagraph.getMinIntrinsicWidth(style.fontSize!);

          return GrxShimmer(
            height: height,
            width: width,
          );
        },
      );
    }

    final formattedText = <InlineSpan>[];

    if (textSpan != null) {
      textSpan?.visitChildren((span) {
        if (span is TextSpan) {
          final spanText = span.text;
          final spanStyle = span.style ?? style;

          formattedText.add(
            TextSpan(
              text: _capitalize(spanText),
              style: spanStyle,
            ),
          );
        } else {
          formattedText.add(span);
        }

        return true;
      });
    } else {
      formattedText.add(
        TextSpan(
          text: _capitalize(text),
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: formattedText,
      ),
      overflow: style.overflow,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  String? _capitalize(String? text) => transform == GrxTextTransform.uppercase
      ? text?.toUpperCase()
      : transform == GrxTextTransform.lowercase
          ? text?.toLowerCase()
          : text;
}

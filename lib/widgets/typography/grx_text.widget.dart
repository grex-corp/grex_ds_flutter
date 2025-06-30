import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../../utils/grx_linkify.util.dart';
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
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isLoading = false,
    this.shouldLinkify = false,
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
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isLoading = false,
    this.shouldLinkify = false,
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
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool isLoading;
  final bool shouldLinkify;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final renderParagraph = RenderParagraph(
        textSpan ?? TextSpan(text: _capitalize(text), style: style),
        textDirection: TextDirection.ltr,
        maxLines: maxLines ?? 1,
      );

      final size = MediaQuery.sizeOf(context);
      renderParagraph.layout(
        BoxConstraints(maxHeight: size.height, maxWidth: size.width),
      );

      final height = renderParagraph.getMinIntrinsicHeight(style.fontSize!);
      final width = renderParagraph.getMinIntrinsicWidth(style.fontSize!);

      return GrxShimmer(
        height: clampDouble(height, 0, size.height),
        width: clampDouble(width, 0, size.width),
      );
    }

    final formattedText = formatText();

    return Text.rich(
      TextSpan(children: formattedText),
      overflow: style.overflow,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior:
          textHeightBehavior ??
          const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
      selectionColor: selectionColor,
    );
  }

  String? _capitalize(String? text) =>
      transform == GrxTextTransform.uppercase
          ? text?.toUpperCase()
          : transform == GrxTextTransform.lowercase
          ? text?.toLowerCase()
          : text;

  List<InlineSpan> formatText() {
    InlineSpan? textSpan;

    if (shouldLinkify) {
      final linkfyText = <InlineSpan>[];

      if (text?.isNotEmpty ?? false) {
        linkfyText.addAll(
          GrxLinkify.plainText(
            text: text!,
            defaultStyle: style,
            linkColor: GrxColors.primary.shade600,
          ),
        );
      } else if (this.textSpan != null) {
        linkfyText.addAll(
          GrxLinkify.textSpan(
            textSpan: this.textSpan!,
            defaultStyle: style,
            linkColor: GrxColors.primary.shade600,
          ),
        );
      }

      textSpan = TextSpan(children: linkfyText);
    } else {
      textSpan = this.textSpan;
    }

    final formattedText = <InlineSpan>[];

    if (textSpan != null) {
      textSpan.visitChildren((span) {
        if (span is TextSpan) {
          final spanText = span.text;
          final spanStyle = span.style ?? style;

          formattedText.add(
            TextSpan(
              text: _capitalize(spanText),
              style: spanStyle,
              recognizer: span.recognizer,
              children: span.children,
              locale: span.locale,
              mouseCursor: span.mouseCursor,
              onEnter: span.onEnter,
              onExit: span.onExit,
              semanticsLabel: span.semanticsLabel,
              spellOut: span.spellOut,
            ),
          );
        } else {
          formattedText.add(span);
        }

        return true;
      });
    } else {
      formattedText.add(TextSpan(text: _capitalize(text)));
    }

    return formattedText;
  }
}

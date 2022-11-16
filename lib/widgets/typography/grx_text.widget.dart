import 'package:flutter/material.dart';

import '../../enums/grx_text_transform.enum.dart';

/// A container that has some default properties which should be extended by others Design System's [Text].
class GrxText extends StatelessWidget {
  /// Creates a Design System's [Text].
  const GrxText(
    this.text, {
    super.key,
    this.transform = GrxTextTransform.none,
    this.style,
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
  }) : textSpan = null;

  const GrxText.rich(
    this.textSpan, {
    super.key,
    this.transform = GrxTextTransform.none,
    this.style,
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
  }) : text = null;

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final TextStyle? style;
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

  @override
  Widget build(BuildContext context) {
    final formattedText = [
      textSpan ??
          TextSpan(
            text: transform == GrxTextTransform.uppercase
                ? text!.toUpperCase()
                : transform == GrxTextTransform.lowercase
                    ? text!.toLowerCase()
                    : text!,
          ),
    ];

    return Text.rich(
      TextSpan(
        children: formattedText,
      ),
      overflow: TextOverflow.ellipsis,
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
}

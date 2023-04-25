import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class GrxSvg extends StatelessWidget {
  const GrxSvg(
    this.path, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.height,
    this.width,
    this.placeholderBuilder,
    this.bundle,
    this.allowDrawingOutsideViewBox = false,
    this.matchTextDirection = false,
    this.clipBehavior = Clip.hardEdge,
    this.package,
    this.semanticsLabel,
  });

  final String path;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ColorFilter? color;
  final double? height;
  final double? width;
  final Widget Function(BuildContext)? placeholderBuilder;
  final AssetBundle? bundle;
  final bool allowDrawingOutsideViewBox;
  final bool matchTextDirection;
  final Clip clipBehavior;
  final String? package;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      package: package,
      fit: fit,
      alignment: alignment,
      colorFilter: color,
      height: height,
      width: width,
      placeholderBuilder: placeholderBuilder,
      bundle: bundle,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      matchTextDirection: matchTextDirection,
      clipBehavior: clipBehavior,
      semanticsLabel: semanticsLabel,
    );
  }
}

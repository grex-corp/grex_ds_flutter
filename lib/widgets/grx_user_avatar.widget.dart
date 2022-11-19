import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../pages/image_preview.page.dart';
import '../routes/fade_page.route.dart';
import '../themes/colors/grx_colors.dart';
import '../utils/grx_utils.util.dart';
import 'typography/grx_body_text.widget.dart';

class GrxUserAvatar extends StatelessWidget {
  const GrxUserAvatar({
    Key? key,
    this.text,
    this.uri,
    this.radius = 25.0,
    this.backgroundColor = GrxColors.cff6bbaf0,
    this.textColor = GrxColors.cffffffff,
    this.heroTag,
    this.openPreview = true,
  }) : super(key: key);

  final String? text;
  final Uri? uri;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final Object? heroTag;
  final bool openPreview;

  @override
  Widget build(BuildContext context) {
    CircleAvatar buildAvatar(ImageProvider? image) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: image,
      );
    }

    return uri != null
        ? CachedNetworkImage(
            imageUrl: uri.toString(),
            imageBuilder: (context, image) => GestureDetector(
              onTap: openPreview
                  ? () {
                      Navigator.of(context).push(
                        FadePageRoute(
                          builder: (context) => ImagePreview(
                            image: image,
                            title: 'Preview',
                            heroTag: heroTag,
                          ),
                        ),
                      );
                    }
                  : null,
              child: heroTag != null
                  ? Hero(
                      tag: heroTag!,
                      transitionOnUserGestures: true,
                      child: buildAvatar(image),
                    )
                  : buildAvatar(image),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) {
              final size = radius * 2;

              return SizedBox(
                height: size,
                width: size,
                child: CircularProgressIndicator(
                    value: downloadProgress.progress, strokeWidth: 1),
              );
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : (text?.isNotEmpty ?? false)
            ? CircleAvatar(
                radius: radius,
                backgroundColor: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: GrxBodyText(
                    RegExp(text!.split(' ').length >= 2
                            ? r'\b[A-Za-z]'
                            : r'[A-Za-z]')
                        .allMatches(text!)
                        .map((m) => m.group(0))
                        .join()
                        .toUpperCase()
                        .substring(0, 2),
                    color: textColor,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : CircleAvatar(
                radius: radius,
                backgroundColor: backgroundColor,
                backgroundImage: const AssetImage(
                  'assets/images/default-avatar.png',
                  package: GrxUtils.packageName,
                ),
              );
  }
}

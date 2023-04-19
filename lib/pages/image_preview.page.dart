import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../themes/colors/grx_colors.dart';
import '../widgets/headers/grx_header.widget.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.image,
    required this.title,
    this.heroTag,
  });

  final ImageProvider image;
  final String title;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: GrxColors.cff1c1c1c,
        body: SafeArea(
          child: Stack(
            children: [
              PhotoView(
                imageProvider: image,
                backgroundDecoration: const BoxDecoration(
                  color: GrxColors.cff1c1c1c,
                ),
                heroAttributes: heroTag != null
                    ? PhotoViewHeroAttributes(
                        tag: heroTag!,
                        transitionOnUserGestures: true,
                      )
                    : null,
              ),
              GrxHeader(
                title: title,
                foregroundColor: GrxColors.cffffffff,
                showBackButton: false,
                showCloseButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

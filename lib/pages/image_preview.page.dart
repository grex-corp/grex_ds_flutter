import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:photo_view/photo_view.dart';

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
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GrxHeadlineText(
                      title,
                      color: GrxColors.cffffffff,
                    ),
                    GrxIconButton(
                      icon: const Icon(GrxIcons.close),
                      color: GrxColors.cffffffff,
                      iconSize: 24,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grex_ds/widgets/grx_shimmer.widget.dart';

import '../pages/image_preview.page.dart';
import '../routes/fade_page.route.dart';
import '../services/grx_image_picker.service.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../utils/grx_utils.util.dart';
import '../extensions/uint8_list.extension.dart';
import 'buttons/grx_circle_button.widget.dart';
import 'typography/grx_body_text.widget.dart';

class GrxUserAvatar extends StatefulWidget {
  const GrxUserAvatar({
    super.key,
    this.text,
    this.uri,
    this.imageFile,
    this.radius = 25.0,
    this.backgroundColor = GrxColors.cff6bbaf0,
    this.textColor = GrxColors.cffffffff,
    this.heroTag,
    this.openPreview = true,
    this.editable = false,
    this.avatarPickerButton,
    this.onPickAvatar,
    this.isLoading = false,
  });

  final String? text;
  final Uri? uri;
  final File? imageFile;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final Object? heroTag;
  final bool openPreview;
  final bool editable;
  final Widget? avatarPickerButton;
  final void Function(File?)? onPickAvatar;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxUserAvatarState();
}

class _GrxUserAvatarState extends State<GrxUserAvatar> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      final size = Size.fromRadius(widget.radius);
      return SizedBox.fromSize(
        size: size,
        child: GrxShimmer(
          height: size.height,
          width: size.width,
          borderRadius: widget.radius,
        ),
      );
    }

    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: [
        widget.imageFile != null
            ? _buildAvatar(
                context,
                FileImage(widget.imageFile!),
              )
            : widget.uri != null
                ? CachedNetworkImage(
                    imageUrl: widget.uri.toString(),
                    imageBuilder: (context, image) => GestureDetector(
                      onTap: widget.openPreview
                          ? () {
                              Navigator.of(context).push(
                                FadePageRoute(
                                  builder: (context) => ImagePreview(
                                    image: image,
                                    title: 'Preview',
                                    heroTag: widget.heroTag,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: widget.heroTag != null
                          ? Hero(
                              tag: widget.heroTag!,
                              transitionOnUserGestures: true,
                              child: _buildAvatar(context, image),
                            )
                          : _buildAvatar(context, image),
                    ),
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return SizedBox.fromSize(
                        size: Size.fromRadius(widget.radius),
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          strokeWidth: 1,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : (widget.text?.isNotEmpty ?? false)
                    ? CircleAvatar(
                        radius: widget.radius,
                        backgroundColor: widget.backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: GrxBodyText(
                            RegExp(widget.text!.split(' ').length >= 2
                                    ? r'\b[A-Za-z]'
                                    : r'[A-Za-z]')
                                .allMatches(widget.text!)
                                .map((m) => m.group(0))
                                .join()
                                .toUpperCase()
                                .substring(0, 2),
                            color: widget.textColor,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: widget.radius,
                        backgroundColor: widget.backgroundColor,
                        backgroundImage: const AssetImage(
                          'assets/images/default-avatar.png',
                          package: GrxUtils.packageName,
                        ),
                      ),
        _buildAvatarPickerIcon(context),
      ],
    );
  }

  CircleAvatar _buildAvatar(BuildContext context, ImageProvider? image) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      backgroundImage: image,
    );
  }

  Widget _buildAvatarPickerIcon(BuildContext context) {
    return Visibility(
      visible: widget.editable,
      child: Positioned(
        bottom: 0,
        right: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            widget.avatarPickerButton ??
                GrxCircleButton(
                  size: widget.radius / 1.7,
                  border:
                      const BorderSide(width: 4, color: GrxColors.cffffffff),
                  isLoading: isLoading,
                  child: Icon(
                    GrxIcons.camera_alt,
                    size: widget.radius / 4,
                  ),
                  onPressed: () async {
                    setLoading(true);

                    final file = await ImagePickerService.pickImage(context);

                    setLoading(false);

                    if (widget.onPickAvatar != null) {
                      final bytes = await file?.readAsBytes();
                      widget.onPickAvatar!(
                        await bytes?.toFile(),
                      );
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }

  setLoading(bool loading) => setState(() {
        isLoading = loading;
      });
}

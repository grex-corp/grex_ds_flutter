import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../extensions/uint8_list.extension.dart';
import '../pages/image_preview.page.dart';
import '../routes/fade_page.route.dart';
import '../services/grx_image_picker.service.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../themes/spacing/grx_spacing.dart';
import '../utils/grx_regex.util.dart';
import '../utils/grx_utils.util.dart';
import 'buttons/grx_circle_button.widget.dart';
import 'grx_shimmer.widget.dart';
import 'typography/grx_body_text.widget.dart';

class GrxUserAvatar extends StatefulWidget {
  GrxUserAvatar({
    super.key,
    this.text,
    this.uri,
    this.imageFile,
    this.radius = 25.0,
    this.textColor = GrxColors.neutrals,
    this.heroTag,
    this.openPreview = true,
    this.editable = false,
    this.avatarPickerButton,
    this.onPickAvatar,
    this.onRemoveAvatar,
    this.isLoading = false,
    this.showBorder = false,
    final Color? backgroundColor,
  }) : backgroundColor = backgroundColor ?? GrxColors.primary.shade400;

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
  final void Function()? onRemoveAvatar;
  final bool isLoading;
  final bool showBorder;

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

    return Container(
      padding: widget.showBorder ? const EdgeInsets.all(2.0) : EdgeInsets.zero,
      decoration:
          widget.showBorder
              ? BoxDecoration(
                border: Border.all(
                  color: GrxColors.primary.shade600,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(widget.radius + 2.0),
              )
              : null,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          widget.imageFile != null
              ? _buildAvatar(context, FileImage(widget.imageFile!))
              : widget.uri != null
              ? CachedNetworkImage(
                imageUrl: widget.uri.toString(),
                imageBuilder:
                    (context, image) => GestureDetector(
                      onTap:
                          widget.openPreview
                              ? () {
                                Navigator.of(context).push(
                                  FadePageRoute(
                                    builder:
                                        (context) => ImagePreview(
                                          image: image,
                                          title: 'Preview',
                                          heroTag: widget.heroTag,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child:
                          widget.heroTag != null
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
              : (widget.text?.isNotEmpty ?? false)
              ? CircleAvatar(
                radius: widget.radius,
                backgroundColor: widget.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: GrxBodyText(
                    RegExp(
                          widget.text!.split(' ').length >= 2
                              ? GrxRegexUtils.fullNameAvatarRgx
                              : GrxRegexUtils.singleNameAvatarRgx,
                        )
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
          if (widget.editable) ...[
            _buildAvatarPickerIcon(context),
            _buildClearButton(context),
          ],
        ],
      ),
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
    return Positioned(
      bottom: -5.0,
      right: -5.0,
      child:
          widget.avatarPickerButton ??
          GrxCircleButton(
            size: widget.radius / 1.4,
            borderColor: GrxColors.neutrals,
            borderSize: GrxSpacing.xxs,
            isLoading: isLoading,
            child: Icon(GrxIcons.camera, size: widget.radius / 3.2),
            onPressed: () async {
              setLoading(true);

              try {
                final file = await GrxImagePickerService.pickImage(context);

                if (widget.onPickAvatar != null) {
                  final bytes = await file?.readAsBytes();
                  widget.onPickAvatar!(await bytes?.toFile());
                }
              } finally {
                setLoading(false);
              }
            },
          ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    final hasImage = widget.imageFile != null || widget.uri != null;

    if (!hasImage || widget.onRemoveAvatar == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: -5,
      right: -5,
      child: GrxCircleButton(
        size: 32.0,
        backgroundColor: GrxColors.error,
        foregroundColor: GrxColors.neutrals,
        borderColor: GrxColors.neutrals,
        borderSize: GrxSpacing.xxs,
        onPressed: widget.onRemoveAvatar,
        child: Icon(GrxIcons.close_l, size: 12.0),
      ),
    );
  }

  void setLoading(bool loading) => setState(() {
    isLoading = loading;
  });
}

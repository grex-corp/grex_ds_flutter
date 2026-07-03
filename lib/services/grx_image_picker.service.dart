import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/grx_toast_action.model.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../widgets/typography/grx_body_text.widget.dart';
import 'grx_bottom_sheet.service.dart';
import 'grx_toast.service.dart';

abstract class GrxImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static const _cameraAccessDeniedCodes = {
    'camera_access_denied',
    'camera_access_restricted',
  };

  static const _photosAccessDeniedCodes = {
    'photo_access_denied',
    'photo_access_restricted',
  };

  static Future<CroppedFile?> openCamera() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;

      return cropImage(image.path);
    } on PlatformException catch (error) {
      if (_cameraAccessDeniedCodes.contains(error.code)) {
        _showAccessDeniedToast(
          message: 'Permissão de acesso à câmera negada.',
        );
      }
      return null;
    }
  }

  static Future<CroppedFile?> openGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (image == null) return null;

      return cropImage(image.path);
    } on PlatformException catch (error) {
      if (_photosAccessDeniedCodes.contains(error.code)) {
        _showAccessDeniedToast(
          message: 'Permissão de acesso à galeria negada.',
        );
      }
      return null;
    }
  }

  static void _showAccessDeniedToast({required String message}) {
    GrxToastService.showError(
      message: message,
      actions: [
        GrxToastAction(
          label: 'Abrir Configurações',
          icon: Icons.settings,
          onPressed: openAppSettings,
        ),
      ],
    );
  }

  static Future<CroppedFile?> cropImage(String path) async =>
      ImageCropper().cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.25, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar Foto',
            toolbarColor: GrxColors.primary.shade400,
            statusBarLight: true,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: GrxColors.secondary.shade400,
          ),
          IOSUiSettings(
            title: 'Cortar Foto',
            doneButtonTitle: 'Confimar',
            cancelButtonTitle: 'Cancelar',
          ),
        ],
      );

  static Future<CroppedFile?> pickImage(BuildContext context) {
    final completer = Completer<CroppedFile?>();

    final dialog = GrxBottomSheetService(
      context: context,
      builder:
          (controller) => Container(
            padding: const EdgeInsets.all(10),
            child: SafeArea(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(GrxIcons.camera),
                    title: const GrxBodyText('Camera'),
                    onTap: () {
                      Navigator.pop(context, false);
                      completer.complete(openCamera());
                    },
                  ),
                  ListTile(
                    leading: const Icon(GrxIcons.image),
                    title: const GrxBodyText('Galeria'),
                    onTap: () {
                      Navigator.pop(context, false);
                      completer.complete(openGallery());
                    },
                  ),
                ],
              ),
            ),
          ),
    );

    dialog.show<bool?>().then((value) {
      if (value ?? true) {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}

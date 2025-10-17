import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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

  static Future<CroppedFile?> openCamera() async {
    final status = await Permission.camera.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      GrxToastService.showError(
        message:
            status.isPermanentlyDenied
                ? 'Permissão de acesso à câmera negada permanentemente.'
                : 'Permissão de acesso à câmera negada.',
        actions: [
          GrxToastAction(
            label: 'Abrir Configurações',
            icon: Icons.settings,
            onPressed: () => openAppSettings(),
          ),
        ],
      );
      return null;
    }

    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    return cropImage(image.path);
  }

  static Future<CroppedFile?> openGallery() async {
    PermissionStatus status;
    String deniedMessage = '';
    String permanentlyDeniedMessage = '';

    if (Platform.isIOS) {
      // iOS: Always request photos permission
      status = await Permission.photos.request();
      deniedMessage = 'Permissão de acesso à galeria negada.';
      permanentlyDeniedMessage =
          'Permissão de acesso à galeria negada permanentemente.';
    } else if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // Android: Check version and request appropriate permission
      // var release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt <= 32) {
        // Android <= 12: Request storage permission
        status = await Permission.storage.request();
        deniedMessage = 'Permissão de acesso ao armazenamento negada.';
        permanentlyDeniedMessage =
            'Permissão de acesso ao armazenamento negada permanentemente.';
      } else {
        // Android > 12: No permission needed, proceed directly
        status = PermissionStatus.granted;
        deniedMessage = 'Permissão de acesso à galeria negada.';
        permanentlyDeniedMessage =
            'Permissão de acesso à galeria negada permanentemente.';
      }
    } else {
      // Other platforms: Default to photos permission
      status = await Permission.photos.request();
      deniedMessage = 'Permissão de acesso à galeria negada.';
      permanentlyDeniedMessage =
          'Permissão de acesso à galeria negada permanentemente.';
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      GrxToastService.showError(
        message:
            status.isPermanentlyDenied
                ? permanentlyDeniedMessage
                : deniedMessage,
        actions: [
          GrxToastAction(
            label: 'Abrir Configurações',
            icon: Icons.settings,
            onPressed: () => openAppSettings(),
          ),
        ],
      );
      return null;
    }

    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return cropImage(image.path);
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

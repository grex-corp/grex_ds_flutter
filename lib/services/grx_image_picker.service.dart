import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:grex_ds/services/grx_bottom_sheet.service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<CroppedFile?> openCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    return cropImage(image.path);
  }

  static Future<CroppedFile?> openGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return cropImage(image.path);
  }

  static Future<CroppedFile?> cropImage(String path) async =>
      ImageCropper().cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.35, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar Foto',
            toolbarColor: GrxColors.cff6bbaf0,
            statusBarColor: GrxColors.cff6bbaf0,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: GrxColors.cff75f3ab,
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
      builder: (controller) => Container(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              ListTile(
                leading: const Icon(GrxIcons.photo_camera),
                title: const GrxBodyText('Camera'),
                onTap: () {
                  Navigator.pop(context, false);
                  completer.complete(openCamera());
                },
              ),
              ListTile(
                leading: const Icon(GrxIcons.photo_library),
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

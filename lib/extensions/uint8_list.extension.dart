import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

extension Uint8ListExtension on Uint8List {
  Future<File> toFile() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg')
        .create();
    file.writeAsBytesSync(this);

    return file;
  }
}

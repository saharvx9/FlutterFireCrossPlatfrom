import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:firebasetut/extras/uploadanimaldialog/pickimage/base_pick_image.dart';

class PickImage extends BasePickImage {

  ///
  /// PickImage WEB
  /// return future of html.file (dynamic for supporting all platforms)
  ///
  @override
  Future<dynamic> pickImage() {
    final completer = Completer<dynamic>();

    InputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.addEventListener('change', (event) async {
      final files = uploadInput.files;
      final file = files[0];
      print("File is null: ${file == null}");
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoad.first.then((value) {
        completer.complete(file);
      });
    });
    return completer.future;
  }

  ///
  /// formatFile
  /// [file] html.file convert it to [Uint8List]
  /// for display it in image before upload
  ///
  @override
  Future<dynamic> formatFile(dynamic file) async {
    final completer = Completer<dynamic>();
    final reader = FileReader();
    File fileHtml = file;
    print("Show file path: ${fileHtml.relativePath}");
    reader.readAsDataUrl(file);
    reader.onLoadEnd.first.then((value) {
      final encoded = reader.result as String;
      // remove data:image/*;base64 preambule
      final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      final data = base64.decode(stripped);
      completer.complete(data);

    });
    return completer.future;
  }
}

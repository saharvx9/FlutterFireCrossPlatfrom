import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasetut/storage/base_fire_storage.dart';
import 'package:firebasetut/extras/api/states/upload_state.dart';
import 'package:path/path.dart' as Path;

///
/// ~~~~~~~~~ FireStorage MOBILE ~~~~~~~~~
///
class FireStorage extends BaseFireStorage {
  final storageRef = FirebaseStorage.instance.ref();

  ///Load image from firebase storage
  ///[path] path image at firebase storage
  @override
  Stream<String> loadImage(String path) => storageRef
      .child(path)
      .getDownloadURL()
      .asStream()
      .map((event) => event.toString());

  /// Upload image from firebase storage
  /// [path] path that should be save the image
  /// [name] image name
  /// [file] io.file image
  @override
  Stream<UploadState> uploadImage(String path, String name, dynamic file) async* {
    yield UploadState.LOADING;
    try {
      final imageType = Path.extension(file.path);
      await storageRef.child(path).putFile(file, StorageMetadata(contentType: "image/$imageType")).onComplete;
      yield UploadState.FINISH_UPLOAD_IMAGE;
    } catch (e) {
      print("Failed upload file");
      yield UploadState.ERROR;
    }
  }
}

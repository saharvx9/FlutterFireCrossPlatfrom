import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:firebasetut/extras/api/states/upload_state.dart';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'base_fire_storage.dart';

///
/// ~~~~~~~~~ FireStorage WEB ~~~~~~~~~
///
class FireStorage extends BaseFireStorage {
  final _ref = storage().ref();

  /// Load image from firebase storage
  /// [path] path image at firebase storage
  @override
  Stream<String> loadImage(String path) => _ref
      .child(path)
      .getDownloadURL()
      .asStream()
      .map((event) => event.toString());

  /// Upload image from firebase storage
  /// [path] path that should be save the image
  /// [name] image name
  /// [file] html.file image
  @override
  Stream<UploadState> uploadImage(
      String path, String name, dynamic uInt8list) async* {
    yield UploadState.LOADING;
    try {
      print("file path: ${(uInt8list as html.File).relativePath}");
      final task = await _ref
          .child(path)
          .put(uInt8list, UploadMetadata(contentType: "image"))
          .future;
      switch (task.state) {
        case TaskState.RUNNING:
          print("RUNNING");
          break;
        case TaskState.PAUSED:
          yield UploadState.ERROR;
          break;
        case TaskState.SUCCESS:
          yield UploadState.FINISH_UPLOAD_IMAGE;
          break;
        case TaskState.CANCELED:
          yield UploadState.ERROR;
          break;
        case TaskState.ERROR:
          print("TaskState.ERROR");
          yield UploadState.ERROR;
          break;
      }
    } catch (e) {
      print("Error while uploading image ${e.toString()}");
      yield UploadState.ERROR;
    }
  }
}

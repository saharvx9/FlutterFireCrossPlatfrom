import 'dart:async';

import 'package:firebasetut/extras/api/firebase_api.dart';
import 'package:firebasetut/extras/api/states/upload_state.dart';
import 'package:firebasetut/model/animal.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebasetut/extras/uploadanimaldialog/pickimage/pick_image_export.dart';

class UploadAnimalBloc {
  final _firebaseApi = FireBaseApi();
  final animal = Animal.empty();
  final nameStream = StreamController<String>.broadcast();
  final ageStream = StreamController<String>.broadcast();
  final imageStream = StreamController<dynamic>.broadcast();
  final uploadAnimalStream = StreamController<UploadState>.broadcast();
  var _imageFileCache;

  ///
  /// Observe both stream [nameStream] [ageStream] for each event that was emitted
  /// add it to current field of animal
  /// 
  UploadAnimalBloc() {
    Rx.combineLatest([nameStream.stream, ageStream.stream], (values) => values)
        .listen((event) {
      animal.name = event[0];
      animal.age = event[1];
      print("Animal name: ${animal.name}");
      print("Animal age: ${animal.age}");
    });
  }

  ///start upload new animal and emit events of [UploadState]
  uploadNewAnimal() {
    uploadAnimalStream.addStream(_firebaseApi.uploadNewAnimal(animal, _imageFileCache));
  }

  /// DisplayAndSaveFileImage
  /// [file] can be be file mobile(dart.io) of html file(html.file) 
  /// first save it in [_imageFileCache]
  /// than emit it
  /// **notice in case it kIsWeb platform convert it to [Uint8List]
  displayAndSaveFileImage(dynamic file) async {
    _imageFileCache = file;
    if (kIsWeb) {
      imageStream.add(await PickImage().formatFile(file));
    } else {
      imageStream.add(file);
    }
  }

  /// 
  /// For prevent leaks memory when process finish close all
  /// 
  dispose() {
    nameStream.close();
    ageStream.close();
    imageStream.close();
    uploadAnimalStream.close();
  }
}

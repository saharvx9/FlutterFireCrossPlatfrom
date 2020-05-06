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
  var _imageCache;

  UploadAnimalBloc() {
    Rx.combineLatest([nameStream.stream, ageStream.stream], (values) => values)
        .listen((event) {
      animal.name = event[0];
      animal.age = event[1];
      print("Animal name: ${animal.name}");
      print("Animal age: ${animal.age}");
    });
  }

  uploadNewAnimal() {
    uploadAnimalStream
        .addStream(_firebaseApi.uploadNewAnimal(animal, _imageCache));
  }

  displayAndSaveFileImage(dynamic file) async {
    _imageCache = file;
    if (kIsWeb) {
      imageStream.add(await PickImage().formatFile(file));
    } else {
      imageStream.add(file);
    }
  }

  dispose() {
    nameStream.close();
    ageStream.close();
    imageStream.close();
    uploadAnimalStream.close();
  }
}

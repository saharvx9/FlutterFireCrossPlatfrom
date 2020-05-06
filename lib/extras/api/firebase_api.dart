import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetut/extras/api/states/upload_state.dart';
import 'package:firebasetut/model/animal.dart';
import 'package:firebasetut/storage/export_fire_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class FireBaseApi {
  final MAIN_PATH = "tut_db/test";
  final ANIMAL_PATH = "/animals";
  final STORAGE_PATH = "/assets/animals";
  final _storage = FireStorage();
  final _fireStore = Firestore.instance;

  /// Load image
  /// In case platform its web it will use [web_fire_storage.dart]
  /// In case platform its mobile it will use [pick_image_mobile.dart]
  Stream<String> loadImage(String path) => _storage.loadImage(path);

  ///
  /// Load Animals data from FireStore
  /// return: Stream<List<Animal>>
  ///
  Stream<List<Animal>> loadAnimals() {
    return _fireStore.collection("$MAIN_PATH$ANIMAL_PATH").snapshots().asyncMap(
        (snapshots) => Stream.fromIterable(snapshots.documents)
            .map((doc) => Animal.fromData(doc.documentID, doc.data))
            .toList());
  }

  ///
  /// Upload new Animal
  /// [animal] value
  /// [file] type can be file dart.io(mobile) or dart.html(web)
  /// first trying to upload image file:
  /// In case platform its web it will use [web_fire_storage.dart]
  /// In case platform its mobile it will use [pick_image_mobile.dart]
  /// than upload animal data mapper
  /// in all this process emit(yield) [UploadState] that determine which upload state:
  ///  DEFAULT - first state
  ///  LOADING - uploading
  ///  FINISH_UPLOAD_IMAGE - finish upload only image
  ///  ERROR - error in case something went wrong
  ///  FINISH - finish all successfully!!!
  ///
  Stream<UploadState> uploadNewAnimal(Animal animal, dynamic file) async* {
    yield UploadState.LOADING;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var name = "";
      var pathImage = "";
      if (kIsWeb) {
        name = "$timestamp";
      } else {
        name = "$timestamp${path.basenameWithoutExtension((file).path)}";
      }
      pathImage = "$STORAGE_PATH/$name";
      yield* _storage.uploadImage(pathImage, name, file);
      animal.imagePath = pathImage;
      await _fireStore
          .collection("$MAIN_PATH$ANIMAL_PATH")
          .document()
          .setData(animal.mapper);
      yield UploadState.FINISH;
    } catch (e) {
      print("Error upload new ANIMAL");
      yield UploadState.ERROR;
    }
  }

  ///
  /// [id] id of current animal
  /// deleteAnimal by id
  /// return future void
  ///
  Future<void> deleteAnimal(String id) async {
    await _fireStore.document("$MAIN_PATH$ANIMAL_PATH/$id").delete();
  }
}

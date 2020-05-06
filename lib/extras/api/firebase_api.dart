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

  Stream<UploadState> uploadNewAnimal(Animal animal, dynamic file) async* {
    yield UploadState.LOADING;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var name = "";
      var pathImage = "";
      if (kIsWeb) {
        name = "$timestamp.jpeg";
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

  Future<void> deleteAnimal(String id) async{
    await _fireStore.document("$MAIN_PATH$ANIMAL_PATH/$id").delete();
  }
}

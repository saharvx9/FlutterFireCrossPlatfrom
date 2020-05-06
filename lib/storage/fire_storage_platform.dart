import 'package:firebasetut/storage/base_fire_storage.dart';
import 'package:firebasetut/extras/api/states/upload_state.dart';

class FireStorage extends BaseFireStorage {
  @override
  Stream<String> loadImage(String path) {}

  @override
  Stream<UploadState> uploadImage(String path,String name,dynamic file) {}

}

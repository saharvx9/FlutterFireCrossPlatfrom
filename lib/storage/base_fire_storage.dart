
import 'package:firebasetut/extras/api/states/upload_state.dart';

abstract class BaseFireStorage {

  Stream<String> loadImage(String path);

  Stream<UploadState> uploadImage(String path,String name,dynamic file);

}

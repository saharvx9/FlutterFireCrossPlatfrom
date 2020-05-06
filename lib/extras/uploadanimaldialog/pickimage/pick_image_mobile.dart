import 'package:firebasetut/extras/uploadanimaldialog/pickimage/base_pick_image.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends BasePickImage {

  @override
  Future<dynamic> pickImage() async => await ImagePicker.pickImage(source: ImageSource.gallery);

  @override
  Future<dynamic> formatFile(dynamic file) => null;


}

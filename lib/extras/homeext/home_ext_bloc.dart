import 'package:firebasetut/extras/api/firebase_api.dart';
import 'package:firebasetut/model/animal.dart';

class HomeExtBloc {
  final _firebaseApi = FireBaseApi();

  /// Load Animals data from FireStore
  /// return: Stream<List<Animal>>
  Stream<List<Animal>> loadAnimals() => _firebaseApi.loadAnimals();

  Stream<String> loadImage(String path) => _firebaseApi.loadImage(path);

  deleteAnimal(String id) async {
    await _firebaseApi.deleteAnimal(id);
  }
}

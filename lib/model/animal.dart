class Animal {
  final String _id;
  String _name;
  String _age;
  String _imagePath;

  Animal(this._id, this._name, this._age, this._imagePath);

  factory Animal.fromData(String id, Map<String, dynamic> data) {
    return Animal(id, data["name"], data["age"], data["image_path"]);
  }

  factory Animal.empty() => Animal("", "", "", "");

  String get imagePath => _imagePath;

  String get age => _age;

  String get name => _name;

  String get id => _id;

  set name(String value) {
    _name = value;
  }

  set age(String value) {
    _age = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  Map<String, dynamic> get mapper =>
      {"name": name, "age": age, "image_path": imagePath};
}

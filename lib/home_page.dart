import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetut/model/animal.dart';
import 'package:firebasetut/storage/export_fire_storage.dart';
import 'package:firebasetut/utils/size_config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final MAIN_PATH = "tut_db/test";
  final ANIMAL_PATH = "/animals";
  final _storage = FireStorage();
  final _fireStore = Firestore.instance;

  /// _loadAnimals stream
  /// query for loading all animals
  /// SNAPSHOT - REAL DEAL for support realtime data:
  /// when something change on the data base update/new/delete it will change automatically
  /// asyncmap convert snapshots to animals list
  Stream<List<Animal>> _loadAnimals() {
    return _fireStore.collection("$MAIN_PATH$ANIMAL_PATH")
        .snapshots()
        .asyncMap((snapshots) => Stream.fromIterable(snapshots.documents)
            .map((doc) => Animal.fromData(doc.documentID, doc.data))
            .toList());
  }

  ///
  /// _listStreamAnimals
  /// Listening for [_loadAnimals] until data will come
  /// until the data is loading display CircularProgressIndicator
  ///
  Widget _listStreamAnimals() {
    return StreamBuilder<List<Animal>>(
        stream: _loadAnimals(),
        builder: (context, snapshot) {
          var list = snapshot.data;
          return snapshot.hasData && list != null
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _animalItem(list[index]);
                  })
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                );
        });
  }

  ///
  /// Card animal item
  ///
  Widget _animalItem(Animal animal) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _animalImageProgress(animal.imagePath),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "name: ${animal.name}",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("age: ${animal.age}",
                    style: TextStyle(color: Colors.black, fontSize: 20))
              ],
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
//    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Flutter Fire",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child:
            Padding(padding: EdgeInsets.all(10), child: _listStreamAnimals()),
      ),
    );
  }

  ///
  /// _animalImageProgress widget
  ///
  ///
  Widget _animalImageProgress(String path) {
    return StreamBuilder<String>(
      stream: _storage.loadImage(path),
      builder: (context, snapshot) {
        return snapshot?.hasData == true
            ? Image.network(
          snapshot.data,
          height: 60,
          width: 60,
          loadingBuilder: (context, child, loadingProgress) {
            var percent = loadingProgress!= null ?loadingProgress.cumulativeBytesLoaded  / loadingProgress.expectedTotalBytes :0.0;
            print("Show percent: $percent");
            if (loadingProgress == null) return child;
            else return CircularProgressIndicator(
              backgroundColor: Colors.grey,
              value: loadingProgress.expectedTotalBytes != null ? percent : null,
            );
          },
        )
            : CircularProgressIndicator(
          backgroundColor: Colors.grey,
        );
      },
    );
  }

//  Future<List<Animal>> _loadAnimalsFuture() async {
//    try {
//      final query = await fireStore.collection("$MAIN_PATH$ANIMAL_PATH").getDocuments();
//      final animalsList = [];
//      query.documents.forEach((element) {
//        animalsList.add(Animal.fromData(element.data));
//      });
//      return animalsList;
//    } catch (e) {
//      print("Error while loading animal list: ${e.toString()}");
//      throw e;
//    }
//  }
//
//  Widget _listFutureAnimals() {
//    return FutureBuilder<List<Animal>>(
//        future: _loadAnimalsFuture(),
//        builder: (context, snapshot) {
//          var list = snapshot.data;
//          return list != null
//              ? ListView.builder(
//                  itemCount: list.length,
//                  itemBuilder: (context, index) {
//                    return _animalItem(list[index]);
//                  })
//              : Center(
//                  child: CircularProgressIndicator(
//                    backgroundColor: Colors.grey,
//                  ),
//                );
//        });
//  }
}

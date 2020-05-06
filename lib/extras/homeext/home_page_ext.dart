import 'package:firebasetut/extras/homeext/home_ext_bloc.dart';
import 'package:firebasetut/extras/uploadanimaldialog/upload_animal_dialog.dart';
import 'package:firebasetut/model/animal.dart';
import 'package:firebasetut/utils/size_config.dart';
import 'package:flutter/material.dart';

class HomePageExt extends StatelessWidget {
  final _bloc = HomeExtBloc();

  ///
  /// Animal Card item widget
  ///
  Widget _animalCardItem(Animal animal) {
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
              width: SizeConfig.spacing_normal_vertical,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "name: ${animal.name}",
                  style: TextStyle(color: Colors.black, fontSize: SizeConfig.font_large),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("age: ${animal.age}",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.font_large))
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Animal Image Widget + progress loading
  ///
  Widget _animalImageProgress(String path) {
    return StreamBuilder<String>(
      stream: _bloc.loadImage(path),
      builder: (context, snapshot) {
        return snapshot?.hasData == true
            ? Image.network(
                snapshot.data,
                height: 60,
                width: 60,
                loadingBuilder: (context, child, loadingProgress) {
                  var percent = loadingProgress != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : 0.0;
                  print("Show percent: $percent");
                  if (loadingProgress == null)
                    return child;
                  else
                    return CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: loadingProgress.expectedTotalBytes != null
                          ? percent
                          : null,
                    );
                },
              )
            : CircularProgressIndicator(
                backgroundColor: Colors.grey,
              );
      },
    );
  }

  ///
  /// List Animals Widget + Swipe logic
  ///
  Widget _listStreamAnimalsSwipe() {
    return StreamBuilder<List<Animal>>(
        stream: _bloc.loadAnimals(),
        builder: (context, snapshot) {
          var list = snapshot.data;
          return snapshot.hasData && list != null
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final animal = list[index];
                    return Dismissible(
                        background: Container(color: Colors.red),
                        key: Key(animal.id),
                        onDismissed: (direction) => _bloc.deleteAnimal(animal.id),
                        direction: DismissDirection.endToStart,
                        child: _animalCardItem(animal));
                  })
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          focusColor: Colors.blue[100],
          child: Icon(Icons.add),
          onPressed: () async => await UploadAnimalDialog().show(context)),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Flutter Fire Extra",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(SizeConfig.spacing_medium_vertical), child: _listStreamAnimalsSwipe()),
      ),
    );
  }
}

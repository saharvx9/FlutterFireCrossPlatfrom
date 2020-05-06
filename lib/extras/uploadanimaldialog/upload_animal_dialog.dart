import 'dart:async';

import 'package:firebasetut/extras/api/states/upload_state.dart';
import 'package:firebasetut/extras/uploadanimaldialog/pickimage/pick_image_export.dart';
import 'package:firebasetut/extras/uploadanimaldialog/upload_animal_bloc.dart';
import 'package:firebasetut/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadAnimalDialog {
  final bloc = UploadAnimalBloc();

  Future<void> show(BuildContext context) => _showCustomDialog(context);

  Future<void> _showCustomDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: SizeConfig.screenWidth / 1.5,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close,size: 20,),
                        ),
                      ),
                      _spacer(),
                      Text(
                        "Upload New Animal",
                        style: TextStyle(color: Colors.black, fontSize: SizeConfig.font_large),
                      ),
                      _spacer(height: 20),
                      _textField("Name", bloc.nameStream),
                      _spacer(),
                      _textField("Age", bloc.ageStream,
                          inputType: TextInputType.number),
                      _spacer(),
                      _pickImageButton(),
                      _spacer(),
                      _imageBeforeUpload(),
                      _spacer(),
                      _addNewAnimalButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _textField(String hint, StreamController stream,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
          hintText: "Write $hint",
          filled: true),
      onChanged: (s) => stream.add(s),
    );
  }

  Widget _spacer({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  Widget _imageBeforeUpload() {
    return StreamBuilder<dynamic>(
        stream: bloc.imageStream.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? (kIsWeb
                  ? Image.memory(snapshot.data, height: 200, width: 200)
                  : Image.file(
                      snapshot.data,
                      height: 100,
                      width: 100,
                    ))
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1)),
                );
        });
  }

  Widget _pickImageButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(),
      onPressed: () => _startPickImage(),
      color: Colors.green,
      child: Text(
        "Pick image",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  _startPickImage() {
    if (kIsWeb) _pickImageMultiPlatform();
    else _checkForPermissions();
  }

  _checkForPermissions() async {
    final storagePermission = Permission.storage;
    switch (await storagePermission.request()) {
      case PermissionStatus.granted:
        print("Granted!!");
        _pickImageMultiPlatform();
        break;
      default:
        print("need permission!!");
        _checkForPermissions();
        break;
    }
  }

  _pickImageMultiPlatform() async {
    var pickImage = PickImage();
    try{
      final image = await pickImage.pickImage();
      bloc.displayAndSaveFileImage(image);
    } catch(e){
      print("Pick image error!!: ${e.toString()}");
    }
  }

  Widget _addNewAnimalButton() {
    return StreamBuilder<UploadState>(
        stream: bloc.uploadAnimalStream.stream,
        initialData: UploadState.DEFAULT,
        builder: (context, snapshot) {
          return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child: _stateUploadWidget(snapshot.data));
        });
  }

  ///
  /// _stateUploadWidget
  /// handle to display widgets by [UploadState]
  ///
  Widget _stateUploadWidget(UploadState state) {
    switch (state) {
      case UploadState.DEFAULT:
        return RaisedButton(
          onPressed: () => bloc.uploadNewAnimal(),
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        );
        break;
      case UploadState.ERROR:
        return Text(
          "Failed upload",
          style: TextStyle(color: Colors.red, fontSize: 30),
        );
        break;
      case UploadState.FINISH:
        return Text(
          "Finish Succssfuly upload",
          style: TextStyle(color: Colors.green, fontSize: 30),
        );
        break;
      case UploadState.FINISH_UPLOAD_IMAGE:
      case UploadState.LOADING:
        return CircularProgressIndicator(backgroundColor: Colors.grey);
        break;
      default:
        return Text("sahat");
    }
  }
}

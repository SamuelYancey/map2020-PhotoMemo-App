import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/views/mydialog.dart';
import 'package:photomemo/screens/views/myimageview.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/detailedScreen/editScreen';
  @override
  State<StatefulWidget> createState() {
    return _EditState();
  }
}

class _EditState extends State<EditScreen> {
  _Controller con;
  PhotoMemo photoMemo;
  FirebaseUser user;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(f) => setState(f);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    photoMemo ??= args['photoMemo'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit PhotoMemo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: con.imageFile == null
                        ? MyImageView.network(
                            imageUrl: photoMemo.photoURL, context: context)
                        : Image.file(con.imageFile, fit: BoxFit.fill),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: Colors.green[200],
                      child: PopupMenuButton<String>(
                        onSelected: con.getPicture,
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'camera',
                            child: Row(children: <Widget>[
                              Icon(Icons.photo_camera),
                              Text('Camera'),
                            ]),
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(children: <Widget>[
                              Icon(Icons.photo_library),
                              Text('Gallery'),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              con.uploadProgress == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      con.uploadProgress,
                      style: TextStyle(fontSize: 20),
                    ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                initialValue: photoMemo.title,
                autocorrect: true,
                validator: con.validatorTitle,
                onSaved: con.onSavedTitle,
              ),
              TextFormField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter new Memo?',
                ),
                initialValue: photoMemo.memo,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                validator: con.validatorMemo,
                onSaved: con.onSavedSaved,
              ),
              TextFormField(
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  hintText: 'Shared With',
                ),
                initialValue: photoMemo.sharedWith.join(','),
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: con.validatorSharedWith,
                onSaved: con.onSavedSharedWith,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _EditState _state;
  File imageFile;
  _Controller(this._state);
  String uploadProgress;

  void save() async {
    if (!_state.formKey.currentState.validate()) return;
    _state.formKey.currentState.save();

    // 1) If image is changed then update storage in firebase
    try {
      MyDialog.circularProgressStart(_state.context);
      if (imageFile != null) {
        Map<String, String> photo = await FirebaseController.uploadStorage(
            image: imageFile,
            uid: _state.user.uid,
            sharedWith: _state.photoMemo.sharedWith,
            listener: (progress) {
              _state.render(() {
                uploadProgress = 'Uploading ${progress.toStringAsFixed(1)}%';
              });
            });
        _state.photoMemo.photoPath = photo['path'];
        _state.photoMemo.photoURL = photo['url'];

        _state.render(() {
          uploadProgress = 'ML Image Labeler Beginning';
        });

        List<String> labels =
            await FirebaseController.getImageLabels(imageFile);
        _state.photoMemo.imageLabels = labels;
      } else {
        // image changes did not occur

      }
      _state.render(() {
        uploadProgress = 'Updating Firestore Document';
      });
      await FirebaseController.updatePhotoMemo(_state.photoMemo);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Edit photoMemo saving error',
        content: e.message ?? e.toString(),
      );
    }
    // 2) save document in firestore
  }

  void getPicture(String source) async {
    try {
      PickedFile _imageFile;
      if (source == 'camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

      _state.render(() {
        imageFile = File(_imageFile.path);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'getPicture from camera/gallery failed',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorTitle(String value) {
    if (value.length < 2) {
      return 'min 2 chars';
    } else
      return null;
  }

  void onSavedTitle(String value) {
    _state.photoMemo.title = value;
  }

  String validatorMemo(String value) {
    if (value.length < 3) {
      return 'min 3 chars';
    } else
      return null;
  }

  void onSavedSaved(String value) {
    _state.photoMemo.memo = value;
  }

  String validatorSharedWith(String value) {
    if (value.trim().length == 0) return null;
    List<String> emailList = value.split(',').map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (!(email.contains('@') && email.contains('.'))) {
        return 'Comma separated email list only';
      }
    }
    return null;
  }

  void onSavedSharedWith(String value) {
    if (value.trim().length != 0) {
      _state.photoMemo.sharedWith =
          value.split(',').map((e) => e.trim()).toList();
    }
  }
}

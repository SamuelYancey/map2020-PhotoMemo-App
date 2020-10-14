import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/edit_screen.dart';
import 'package:photomemo/screens/views/mydialog.dart';
import 'package:photomemo/screens/views/myimageview.dart';

class DetailedScreen extends StatefulWidget {
  static const routeName = '/homescreen/detailedScreen';

  @override
  State<StatefulWidget> createState() {
    return _DetailedState();
  }
}

class _DetailedState extends State<DetailedScreen> {
  _Controller con;
  FirebaseUser user;
  PhotoMemo photoMemo;

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
      appBar: AppBar(title: Text('Details'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: con.edit,
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MyImageView.network(
                      imageUrl: photoMemo.photoURL, context: context),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    color: Colors.green[300],
                    child: IconButton(
                      icon: Icon(Icons.label),
                      onPressed: con.showImageLabels,
                    ),
                  ),
                ),
              ]),
              Text(photoMemo.title, style: TextStyle(fontSize: 20)),
              Text(photoMemo.memo, style: TextStyle(fontSize: 16)),
              Text('Created By: ${photoMemo.createdBy}',
                  style: TextStyle(fontSize: 16)),
              Text('Updated At: ${photoMemo.updatedAt}',
                  style: TextStyle(fontSize: 16)),
              Text('Shared With: ${photoMemo.sharedWith}',
                  style: TextStyle(fontSize: 16)),
            ]),
      ),
    );
  }
}

class _Controller {
  _DetailedState _state;
  _Controller(this._state);

  void edit() async {
    await Navigator.pushNamed(_state.context, EditScreen.routeName,
        arguments: {'user': _state.user, 'photoMemo': _state.photoMemo});
        _state.render((){
          
        });
  }

  void showImageLabels() {
    MyDialog.info(
      context: _state.context,
      title: 'Image Labels by ML',
      content: _state.photoMemo.imageLabels.toString(),
    );
  }
}

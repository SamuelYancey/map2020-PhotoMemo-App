import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  static const routeName = '/home/addScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddState();
  }
}

class _AddState extends State<AddScreen> {
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new photo to memo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Title',
              ),
              autocorrect: true,
              validator: con.validatorTitle,
              onSaved: con.onSavedTitle,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Memo',
              ),
              autocorrect: true,
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              validator: con.validatorMemo,
              onSaved: con.onSavedMemo,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'SharedWith',
              ),
              autocorrect: true,
              maxLines: 3,
              validator: con.validatorSharedWith,
              onSaved: con.onSavedSharedWith,
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _AddState _state;
  _Controller(this._state);

  String validatorTitle(String value){

  }
  void onSavedTitle(String value){

  }
  String validatorMemo(String value){

  }
  void onSavedMemo(String value){

  }
  String validatorSharedWith(String value){

  }
  void onSavedSharedWith(String value){

  }
}

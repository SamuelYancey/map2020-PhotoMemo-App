import 'package:flutter/material.dart';

class SharedWithScreen extends StatefulWidget{
  static const routeName = '/home/sharedWithScreen';
  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }

}

class _SharedWithState extends State<SharedWithScreen>{
  _Controller con;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(f) => setState(f);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Text('body'),
    );
  }

}


class _Controller{
  _SharedWithState _state;
  _Controller(this._state);
}
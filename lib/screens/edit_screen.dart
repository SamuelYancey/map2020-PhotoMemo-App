import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget{
  static const routeName = '/detailedScreen/editScreen';
  @override
  State<StatefulWidget> createState() {
    return _EditState();
  }

}


class _EditState extends State<EditScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit PhotoMemo'),
      ),
      body: Text('Body'),
    );
  }

}
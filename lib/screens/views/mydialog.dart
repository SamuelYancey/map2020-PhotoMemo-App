import 'package:flutter/material.dart';

class MyDialog{
  static void info({BuildContext context, String title, String content}){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]
        );
      }
    );
  }
}
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  static const routeName = '/signinScreen/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Text('Home'),
    );
  }

}
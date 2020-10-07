import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen>{

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
        title: Text('Sign in'),
      ),
      body: Text('Sign in'),
    );
  }

}


class _Controller{
  _SignInState _state;
  _Controller(this._state);
}
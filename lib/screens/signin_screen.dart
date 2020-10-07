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
  var formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              RaisedButton(
                child: Text('Sign In', style: TextStyle(fontSize: 25, color: Colors.white),),
                color: Colors.teal,
                onPressed: con.signIn,
              ),
            ]
          ),
        ),
      ),
    );
  }

}


class _Controller{
  _SignInState _state;
  _Controller(this._state);

  void signIn(){

  }

  String validatorEmail(String value){

  }

  void onSavedEmail(String value){

  }

  String validatorPassword(String value){

  }

  void onSavedPassword(String value){

  }
}
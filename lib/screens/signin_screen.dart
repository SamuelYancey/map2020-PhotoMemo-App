import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/screens/views/mydialog.dart';

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
  String email;
  String password;

  void signIn() async{
    if(!_state.formKey.currentState.validate()){
      return;
    }
    _state.formKey.currentState.save();
    print('========= Email: $email  Password: $password');

    try{
      var user = await FirebaseController.signIn(email, password);
      print('==== USER: $user');
    } catch(e){
      MyDialog.info(
        context: _state.context,
        title: 'Sign in error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorEmail(String value){
    if(value == null || !value.contains('@') || !value.contains('.')){
      return 'Invalid Email Address';
    }else return null;
  }

  void onSavedEmail(String value){
    email = value;
  }

  String validatorPassword(String value){
    if(value == null || value.length < 6){
      return 'Invalid Password-Minimum 6 chars';
    }else return null;
  }

  void onSavedPassword(String value){
    password = value;
  }
}
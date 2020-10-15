import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/home_screen.dart';
import 'package:photomemo/screens/signup_screen.dart';
import 'package:photomemo/screens/views/mydialog.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
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
          child: Column(children: <Widget>[
            Stack(children: <Widget>[
              Center(
                  child:
                      Image.asset('assets/images/ClipArt1.png', height: 150.0)),
              Positioned(
                top: 50.0,
                left: 90.0,
                right: 0.0,
                bottom: 0.0,
                child: Text('Photo Memo',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 45,
                      fontFamily: 'Cormorant',
                    )),
              ),
            ]),
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
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              color: Colors.teal,
              onPressed: con.signIn,
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              onPressed: con.signUp,
              child: Text(
                'Sign Up - Account Creation',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;

  void signUp() async{
    Navigator.pushNamed(_state.context, SignUpScreen.routeName);
  }

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();

    MyDialog.circularProgressStart(_state.context);

    FirebaseUser user;

    try {
      user = await FirebaseController.signIn(email, password);
      print('==== USER: $user');
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Sign in error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    //Sign in did not fail
    // 1) Grab their photos from firebase
    // 2) take them to home page and display the photos we just grabbed
    try {
      List<PhotoMemo> photoMemos =
          await FirebaseController.getPhotoMemos(user.email);
      // go to home screen to display
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pushReplacementNamed(_state.context, HomeScreen.routeName,
          arguments: {'user': user, 'photoMemoList': photoMemos});
      print(photoMemos.toString());
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: 'Firebase/Firestore error',
          content: 'Cant get memo, $e');
    }
  }

  String validatorEmail(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Invalid Email Address';
    } else
      return null;
  }

  void onSavedEmail(String value) {
    email = value;
  }

  String validatorPassword(String value) {
    if (value == null || value.length < 6) {
      return 'Invalid Password-Minimum 6 chars';
    } else
      return null;
  }

  void onSavedPassword(String value) {
    password = value;
  }
}

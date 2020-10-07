import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/signinScreen/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  _Controller con;
  FirebaseUser user;
  List<PhotoMemo> photoMemos;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    photoMemos ??= arg['photoMemoList'];
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(accountName: Text(user.displayName ?? 'N/A'), accountEmail: Text(user.email)),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ]
          ),
        ),
        body: Text('Home: Docs present: ${photoMemos.length}'),
      ),
    );
  }
}

class _Controller{
  _HomeState _state;
  _Controller(this._state);

  void signOut() async{
    try{
      await FirebaseController.signOut();
    }catch(e){
      print('Sign out error: $e');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }
}
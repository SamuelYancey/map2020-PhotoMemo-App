import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/chatroom.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/add_screen.dart';
import 'package:photomemo/screens/chat_screen.dart';
import 'package:photomemo/screens/detailed_screen.dart';
import 'package:photomemo/screens/settings_screen.dart';
import 'package:photomemo/screens/sharedwith_screen.dart';
import 'package:photomemo/screens/signin_screen.dart';
import 'package:photomemo/screens/views/mydialog.dart';
import 'package:photomemo/screens/views/myimageview.dart';

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
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(f) => setState(f);

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
            actions: <Widget>[
              Container(
                width: 180.0,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Image Search',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    autocorrect: false,
                    onSaved: con.onSavedSearchKey,
                  ),
                ),
              ),
              con.delIndex == null
                  ? IconButton(
                      icon: Icon(Icons.search),
                      onPressed: con.search,
                    )
                  : IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: con.delete,
                    ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: ClipOval(
                    
                    child: MyImageView.network(
                      imageUrl: user.photoUrl,
                      context: context,
                    ),
                  ),
                  accountName: Text(user.displayName ?? 'N/A'),
                  accountEmail: Text(user.email),
                ),
                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text('Chat with Friends'),
                  onTap: con.chatWith,
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Shared With Me'),
                  onTap: con.sharedWith,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                  onTap: con.signOut,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: con.settings,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: con.addButton,
          ),
          body: photoMemos.length == 0
              ? Text('No Photo Memo', style: TextStyle(fontSize: 40))
              : ListView.builder(
                  itemCount: photoMemos.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    color: con.delIndex != null && con.delIndex == index
                        ? Colors.red[300]
                        : Colors.white,
                    child: ListTile(
                      //leading: Image.network(photoMemos[index].photoURL),
                      leading: MyImageView.network(
                          imageUrl: photoMemos[index].photoURL,
                          context: context),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text(photoMemos[index].title),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Created by: ${photoMemos[index].createdBy}'),
                            Text('SharedWith: ${photoMemos[index].sharedWith}'),
                            Text(
                                'Updated at by: ${photoMemos[index].updatedAt}'),
                            Text(photoMemos[index].memo),
                          ]),
                      onTap: () => con.onTap(index),
                      onLongPress: () => con.onLongPress(index),
                    ),
                  ),
                )),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);
  int delIndex;
  String searchKey;


  void chatWith() async{
    try {
      List<ChatRoom> sharedChat =
          await FirebaseController.getChatRoomSharedWithMe(_state.user.email);

      await Navigator.pushNamed(_state.context, ChatScreen.routeName,
          arguments: {
            'user': _state.user,
            'sharedChat': sharedChat
          });
      Navigator.pop(_state.context);
    } catch (e) {}
  }

  void settings() async {
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: _state.user);

    await _state.user.reload();
    _state.user = await FirebaseAuth.instance.currentUser();
    Navigator.pop(_state.context);
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void onTap(int index) async {
    if (delIndex != null) {
      _state.render(() {
        delIndex = null;
      });
      return;
    }
    await Navigator.pushNamed(_state.context, DetailedScreen.routeName,
        arguments: {
          'user': _state.user,
          'photoMemo': _state.photoMemos[index]
        });
    _state.render(() {});
  }

  void addButton() async {
    await Navigator.pushNamed(_state.context, AddScreen.routeName,
        arguments: {'user': _state.user, 'photoMemoList': _state.photoMemos});
    _state.render(() {});
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void delete() async {
    try {
      PhotoMemo photoMemo = _state.photoMemos[delIndex];
      await FirebaseController.deletePhotoMemo(photoMemo);
      _state.render(() {
        _state.photoMemos.removeAt(delIndex);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete PhotoMemo Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void onSavedSearchKey(String value) {
    searchKey = value;
  }

  void search() async {
    _state.formKey.currentState.save();
    //print('SearchKey: $searchKey');
    var results;
    if (searchKey == null || searchKey.trim().isEmpty) {
      results = await FirebaseController.getPhotoMemos(_state.user.email);
    } else {
      results = await FirebaseController.searchImages(
          email: _state.user.email, imageLabel: searchKey);
    }

    _state.render(() {
      _state.photoMemos = results;
    });
  }

  void sharedWith() async {
    try {
      List<PhotoMemo> sharedPhotoMemos =
          await FirebaseController.getPhotoMemosSharedWithMe(_state.user.email);

      await Navigator.pushNamed(_state.context, SharedWithScreen.routeName,
          arguments: {
            'user': _state.user,
            'sharedPhotoMemoList': sharedPhotoMemos
          });
      Navigator.pop(_state.context);
    } catch (e) {}
  }
}

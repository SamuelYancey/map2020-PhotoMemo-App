import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/chatroom.dart';
import 'package:photomemo/screens/views/mydialog.dart';

class SendMessageScreen extends StatefulWidget{
  static const routeName = '/home/chatScreen/sendMessageScreen';

  @override
  State<StatefulWidget> createState() {
    return _SendMessageState();
  }
}

class _SendMessageState extends State<SendMessageScreen>{
  _Controller con;
  List<ChatRoom> chatRoom;
  FirebaseUser user;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Recipient Email',
                ),
                initialValue: '',
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Message Body',
                ),
                initialValue: '',
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                validator: con.validatorMessage,
                onSaved: con.onSavedMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller{
  _SendMessageState _state;
  _Controller(this._state);
  String message;
  String sendTo;
  String from;

  void save() async{
  if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      var p = ChatRoom(
        message: message,
        sendTo: sendTo,
        sentAt: DateTime.now(),
        from: _state.user.email,
      );

      p.docId = await FirebaseController.addMessage(p);
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorEmail(String value){
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid email';
  }

  void onSavedEmail(String value){
    this.sendTo = value;
  }

  String validatorMessage(String value){
    if (value.length < 1) {
      return 'Message was empty';
    } else
      return null;
  }

  void onSavedMessage(String value){
    this.message = value;
  }
}
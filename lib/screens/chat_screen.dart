import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photomemo/screens/sendmessage_screen.dart';

class ChatScreen extends StatefulWidget{

  static const routeName = '/home/ChatScreen';

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}


class _ChatState extends State<ChatScreen>{
  _Controller con;
  List<dynamic> chatRoom;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(f) => setState(f);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    chatRoom ??= args['sharedChat'];
    user ??= args['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.send), onPressed: con.navToSend)
        ],
      ),
      body: chatRoom.length == 0
          ? Text('No one has messaged you',
              style: TextStyle(fontSize: 25, color: Colors.teal))
          : ListView.builder(
              itemCount: chatRoom.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 10.0,
                    color: Colors.green[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${chatRoom[index].from}:',
                          style: TextStyle(fontSize: 16.0, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '${chatRoom[index].message}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(
                            'Timestamp: ${DateFormat.yMd().add_jm().format(chatRoom[index].sentAt)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Controller{
  _ChatState _state;
  _Controller(this._state);

  void navToSend() async{
    try{
      await Navigator.pushNamed(_state.context, SendMessageScreen.routeName,
       arguments: {'user': _state.user,});
      Navigator.pop(_state.context);
    }catch(e){

    }
  }
}
import 'package:flutter/material.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/views/myimageview.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/home/sharedWithScreen';
  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  _Controller con;
  List<PhotoMemo> photoMemos;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(f) => setState(f);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    photoMemos ??= args['sharedPhotoMemoList'];
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: photoMemos.length == 0
          ? Text('No one is sharing with you',
              style: TextStyle(fontSize: 25, color: Colors.teal))
          : ListView.builder(
              itemCount: photoMemos.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(25.0),
                  child: Card(
                    elevation: 10.0,
                    color: Colors.green[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: MyImageView.network(
                              imageUrl: photoMemos[index].photoURL,
                              context: context),
                        ),
                        Text(
                          'Title: ${photoMemos[index].title}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          'Memo: ${photoMemos[index].memo}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'Created By: ${photoMemos[index].createdBy}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'Updated At: ${photoMemos[index].updatedAt}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'Shared With: ${photoMemos[index].sharedWith}',
                          style: TextStyle(fontSize: 16.0),
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

class _Controller {
  _SharedWithState _state;
  _Controller(this._state);
}

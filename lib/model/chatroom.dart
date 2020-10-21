class ChatRoom{
  static const COLLECTION = 'chatRoom';
  static const CHATROOM = 'messageBoard';
  static const MESSAGE = 'message';
  static const SENT_AT = 'sentAt';
  static const SEND_TO = 'sendTo';
  static const FROM = 'from';

  String docId;
  String message;
  String sendTo;
  String from;
  DateTime sentAt;

  ChatRoom({
    this.docId,
    this.message,
    this.sentAt,
    this.sendTo,
    this.from
    });

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      SENT_AT: sentAt,
      MESSAGE: message,
      SEND_TO: sendTo,
      FROM: from,
    };
  }

  //Convert firestore doc to dart object
  static ChatRoom deserialize(Map<String, dynamic> data, String docId){
    return ChatRoom(
      docId: docId,
      message: data[ChatRoom.MESSAGE],
      sentAt: data[ChatRoom.SENT_AT] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[ChatRoom.SENT_AT].millisecondsSinceEpoch) : null,
      sendTo: data[SEND_TO],
      from: data[FROM],
    );
  }
}
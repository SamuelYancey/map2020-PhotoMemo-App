import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class PhotoMemo{
  //Field names for firebase
  static const COLLECTION = 'photoMemos';
  static const IMAGE_FOLDER = 'photoMemoPictures';
  static const CREATED_BY = 'createdBy';
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const UPDATED_AT = 'updatedAt';
  static const SHARED_WITH = 'sharedWith';
  static const IMAGE_LABELS = 'imageLabels';


  String docId; // auto generated firebase doc id
  String createdBy;
  String title;
  String memo;
  String photoPath; // firebase storage's name
  String photoURL; // firebase storage URL for internet access
  DateTime updatedAt; //created/revised time
  List<dynamic> sharedWith;
  List<dynamic> imageLabels; // gernated by machine learning

  PhotoMemo({
    this.docId,
    this.createdBy,
    this.title,
    this.memo,
    this.photoPath,
    this.photoURL,
    this.updatedAt,
    this.sharedWith,
    this.imageLabels,
  }){
    this.sharedWith ??= [];
    this.imageLabels ??= [];
  
  }

//Converting dart object to firestore document
  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      TITLE: title,
      CREATED_BY: createdBy,
      MEMO: memo,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      UPDATED_AT: updatedAt,
      SHARED_WITH: sharedWith,
      IMAGE_LABELS: imageLabels,
    };
  }

  //Convert firestore doc to dart object
  static PhotoMemo deserialize(Map<String, dynamic> data, String docId){
    return PhotoMemo(
      docId: docId,
      createdBy: data[PhotoMemo.CREATED_BY],
      title: data[PhotoMemo.TITLE],
      memo: data[PhotoMemo.MEMO],
      photoPath: data[PhotoMemo.PHOTO_PATH],
      photoURL: data[PhotoMemo.PHOTO_URL],
      sharedWith: data[PhotoMemo.SHARED_WITH],
      imageLabels: data[PhotoMemo.IMAGE_LABELS],
      updatedAt: data[PhotoMemo.UPDATED_AT] != null ?
        DateTime.fromMicrosecondsSinceEpoch(data[PhotoMemo.UPDATED_AT].millisecondsSinceEpoch) : null,
    );
  }

  @override
  String toString(){
    return '======================\n$docId $createdBy $title $memo \n $photoURL\n';
  }
}
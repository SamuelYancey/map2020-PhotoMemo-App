import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/model/photomemo.dart';

class FirebaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  static Future<List<PhotoMemo>> getPhotoMemos(String email) async{
    QuerySnapshot qss = await Firestore.instance
    .collection(PhotoMemo.COLLECTION)
    .where(PhotoMemo.CREATED_BY, isEqualTo: email)
    .orderBy(PhotoMemo.UPDATED_AT, descending: true)
    .getDocuments();
    var result = <PhotoMemo>[];
    if(qss != null && qss.documents.length != 0){
      for(var doc in qss.documents){
        result.add(PhotoMemo.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future<Map<String,String>> uploadStorage({
    @required File image,
      String filePath,
    @required String uid,
    @required List<dynamic> sharedWith,
    @required Function listener,
  }) async{
    filePath ??= '${PhotoMemo.IMAGE_FOLDER}/$uid/${DateTime.now()}';

    StorageUploadTask task = FirebaseStorage.instance.ref().child(filePath).putFile(image);
    task.events.listen((event) {
      double perc = (event.snapshot.bytesTransferred.toDouble()/event.snapshot.totalByteCount.toDouble())*100;
      listener(perc);
    });
    var download = await task.onComplete;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  static Future<String> addPhotoMemo(PhotoMemo photoMemo) async{
    photoMemo.updatedAt = DateTime.now();
    DocumentReference ref = await Firestore.instance.collection(PhotoMemo.COLLECTION).add(photoMemo.serialize());
    return ref.documentID;
  }

  static Future<List<dynamic>> getImageLabels(File imageFile) async{
//ML KIT
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);
    var labels = <String>[];
    for(ImageLabel label in cloudLabels){
      String text = label.text.toLowerCase();
      double confidence = label.confidence;
      if(confidence >= PhotoMemo.MIN_CONFIDENCE) labels.add(text);
    }
    cloudLabeler.close();
    return labels;
  }
}
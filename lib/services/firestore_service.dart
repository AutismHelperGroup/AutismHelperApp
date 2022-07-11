import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({ required String path, required Map<String, dynamic> data, }) async {
    var newDocRef = FirebaseFirestore.instance.collection(path).doc();

    data.addAll({
      'IDD': newDocRef.id
    });
    newDocRef.set(data);
  }

  Future<void> updateDoc({ required String path,required String docID, required Map<String, dynamic> data, }) async {
    CollectionReference database = FirebaseFirestore.instance.collection(path);
    database.doc(docID).update(data).then((value)
    => print("User Updated"))
        .catchError((error)
    => print("Failed to update user: $error"));
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }

    await reference.delete();
  }

  Stream<dynamic> collectionStream({ required String path}) {
    Stream collectionStream = FirebaseFirestore.instance.collection(path).snapshots();
    return collectionStream;
  }

  DocumentReference<Map<String, dynamic>> getDoc({required String path, required String documentID })  {
    DocumentReference<Map<String, dynamic>> collectionStream = FirebaseFirestore.instance.collection(path).doc(documentID);
    return collectionStream;

  }

  Stream<dynamic> getDocStream({required String path, required String documentID })  {
    Stream collectionStream = FirebaseFirestore.instance.collection(path).doc(documentID).snapshots();
    return collectionStream;

  }



}

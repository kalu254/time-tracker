import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService{

  FirestoreService._();
  static final instance =   FirestoreService._();

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data,String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map(
                (snapshot) => builder(snapshot.data(),snapshot.id)
        ).toList());
  }

  Future<void> deleteData({@required String path}) async{
    final reference = FirebaseFirestore.instance.doc(path);
    reference.delete();
  }

  Future<void> setData({@required String path,@required Map<String, dynamic> data}) async {
    print('$path : $data');
    final reference = FirebaseFirestore.instance.doc(path);
    reference.set(data);
  }

}

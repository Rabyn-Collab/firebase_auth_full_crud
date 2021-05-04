import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_model_provider.dart';
import 'package:flutter_app_models/database_provider/api_path.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';




final dbProvider = Provider<Db>((ref) {
  final auth = ref.watch(authStateProvider);

  if (auth.data?.value?.uid != null) {
    return Db(uid: auth.data.value.uid);
  }
  return null;
});




final dataProvider = StreamProvider.autoDispose((ref) => ref.read(dbProvider).posts);

class Db {
  final String uid;

  Db({this.uid});

  String docIdFromDate() => DateTime.now().toIso8601String();

  Future<void> createPost(Posts posts, BuildContext context) async {
    final path = ApiPath.post(uid, posts.id);
    DocumentReference _db = FirebaseFirestore.instance.doc(path);
    try {
      await _db.set(posts.toJson());
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')));
    }
  }


  Future<void> removeData(String postId) async {
    final path = ApiPath.post(uid, postId);
    DocumentReference _db = FirebaseFirestore.instance.doc(path);
    await _db.delete();
  }


  Stream<List<Posts>> get posts {
    final path = ApiPath.posts(uid);
    CollectionReference _db = FirebaseFirestore.instance.collection(path);
    return _db.snapshots().map(_getFromSnap);
  }

  Stream<List<Posts>>  pos(String user) {
    final path = ApiPath.posts(user);
    CollectionReference _db = FirebaseFirestore.instance.collection(path);
    return _db.snapshots().map(_getFromSnap);
  }

  List<Posts> _getFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Posts.fromJson(e.data(), e.id)).toList();
  }


  List<Users> _getFromSnaps(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Users.fromJson(e.data())).toList();
  }



  Stream<List<Users>> get users {
    CollectionReference _db = FirebaseFirestore.instance.collection('users');
    return _db.snapshots().map(_getFromSnaps);
  }


  Stream<List<Posts>> get post {
    StreamController controller = StreamController<List<Posts>>();
    List<Stream<List<Posts>>> streams = [];
    // users.map((event) {
    //   event.map((e) {
    //     final path = ApiPath.posts(e.userId);
    //    CollectionReference  _db = FirebaseFirestore.instance.collection(path);
    //     streams.add(pos(e.userId));
    //   });
    // });
    //
    // return StreamGroup.merge(streams);
    Rx.combineLatest2(posts, users, (List<Posts> pt, List<Users> us) {
      us.map((e) {
        for (int i = 0; i < us.length; i++)
          streams.add(pos(e.userId));
      });
    }).toList();

    return StreamGroup.merge(streams) ?? [];

    controller.close();
  }





  Stream<List<Posts>> get memos {
    List<Stream<List<Posts>>> streams = [];
  final _db = FirebaseFirestore.instance.collection('users').get();

 final db = _db.then((value) => value.docs.map((e) => Users.fromJson(e.data())));
 db.then((value) => value.map((e) {
   final path = ApiPath.posts(e.userId);
   CollectionReference _db = FirebaseFirestore.instance.collection(path);
   streams.add(_db.snapshots().map(_getFromSnap));
 }));
  // streams.add(posts);
     users.listen((friends){
      for (var i = 0; i < friends.length; i++) {
       friends.map((e) => streams.add(pos(e.userId)));
       print(streams);
      }
    });
    print(streams);
    return StreamGroup.merge(streams);
  }




}





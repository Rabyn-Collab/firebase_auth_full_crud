import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final statusProvider = StateNotifierProvider<StatusCheck, bool>((ref) => StatusCheck());

class StatusCheck extends StateNotifier<bool>{
  StatusCheck() : super(false);
  void toggle(){
    state = !state;
  }

}

final visibilityProvider = StateNotifierProvider<StatusCheck, bool>((ref) => StatusCheck());

class VisibilityCheck extends StateNotifier<bool>{
  VisibilityCheck() : super(false);
  void toggle(){
    state = !state;
  }

}



class Database{
  bool loading;
  Future<void> initDatabase() async {
    loading = true;
  }

}
final databaseProvider = Provider<Database>((ref) => Database());


class FireAuth extends StateNotifier<AsyncValue<bool>> {
CollectionReference _db = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth;
  final Reader read;
  FireAuth(this._firebaseAuth, this.read) : super(AsyncLoading()){
   _init();
  }

  void _init() async {
    await read(databaseProvider).initDatabase();
    state = AsyncData(true);
  }


Future<void> signUp({String email, String password, BuildContext context}) async {
  try {
    state = AsyncLoading();
   await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    state = AsyncData(true);

    Users user = Users(
      email: _firebaseAuth.currentUser.email,
      userId: _firebaseAuth.currentUser.uid,
    );
   _db.add(user.toJson());

  }on FirebaseException catch(e){
    state = AsyncLoading();
    await Future.delayed(Duration(seconds: 1));
    state = AsyncData(true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (e.code == 'network-request-failed') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('check your connection')));
    } else  {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('check your email or password')));
    }

  }
}

Future<void> signIn({String email, String password, BuildContext context}) async {
  try {
    state = AsyncLoading();
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    state = AsyncData(true);
  } on FirebaseException catch (e) {
    state = AsyncLoading();
    await Future.delayed(Duration(seconds: 1));
    state = AsyncData(true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (e.code == 'network-request-failed') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('check your connection')));
    } else  {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('check your email or password')));
    }

  }
}

Future<void> logOut() async{
  await FirebaseAuth.instance.signOut();
}


}


final authProvider = Provider((ref) => FireAuth(FirebaseAuth.instance, ref.read));
final loadProvider = StateNotifierProvider<FireAuth, AsyncValue<bool>>((ref) => FireAuth(FirebaseAuth.instance, ref.read));
final authStateProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());
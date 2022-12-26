import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  //* create account
  static Future<UserCredential?> singupService(
      {required String email, required String pass}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
    } on FirebaseException catch (e) {
      log(e.toString());
    }
    return userCredential;
  }

  //* login services
  static Future<UserCredential?> signInServices(
      {required String email, required String password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      log(e.toString());
      throw e.toString();
    }
    return userCredential;
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/models/user_model.dart';
import 'package:flutter_chat_app/src/provider/notification_provider.dart';
import 'package:flutter_chat_app/src/services/firebase_services.dart';
import 'package:flutter_chat_app/src/views/auth/signin_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum SignupState { initial, loading, loaded, failed }

enum SignInState { inital, loading, loaded, failed }

class AuthProvider with ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance;

  // NotificationProvider? notificationProvider;

  // AuthProvider() {
  //   notificationProvider;
  // }

  bool _isSignupLoading = false;
  bool _isSigninLoading = false;
  //* setters

  SignupState _signupState = SignupState.initial;
  SignInState _signInState = SignInState.inital;
  //* Getters

  SignupState get signupstate => _signupState;
  SignInState get signInState => _signInState;

  bool get isSignuploading => _isSignupLoading;
  bool get isSignInLoadig => _isSigninLoading;

  setSignupStatus({required SignupState state}) {
    _signupState = state;
    notifyListeners();
  }

  setSignInStatus({required SignInState state}) {
    _signInState = state;
    notifyListeners();
  }

  setSignupLoading() {
    _isSignupLoading = !_isSigninLoading;
    notifyListeners();
  }

  setSigninLoading() {
    _isSigninLoading = !isSignInLoadig;
    notifyListeners();
  }

  //* login Function
  Future<UserCredential?> loginFunction(
      {required String email, required String password}) async {
    setSigninLoading();
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseServices.signInServices(
          email: email, password: password);

      Future<String> getDeviceToken() async {
        final FirebaseMessaging messaging = await FirebaseMessaging.instance;
        final String? token = await messaging.getToken();
        return token!;
      }

      String token = await getDeviceToken();

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential!.user!.uid.toString())
          .update({
        "token": token,
      });

      setSigninLoading();
      notifyListeners();
    } catch (e) {
      log(e.toString());
      setSigninLoading();
      notifyListeners();
    }
    return userCredential;
  }

  //* register function
  Future<UserCredential?> signupFunction(
      {required String email,
      required String pass,
      required UserModel userModel}) async {
    UserCredential? userCredential;
    // setSignupStatus(state: SignupState.loading);
    setSignupLoading();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();

    try {
      userCredential =
          await FirebaseServices.singupService(email: email, pass: pass);

      if (userCredential!.user != null) {
        pref.setString("uid", userModel.userId.toString());

        try {
          _fireStore
              .collection("users")
              .doc(userModel.userId)
              .set(userModel.toMap());
          setSignupLoading();
          notifyListeners();
        } catch (e) {
          log(e.toString());
          setSignupLoading();
          notifyListeners();
        }
      }
    } catch (e) {
      log(e.toString());
      setSignupLoading();
      notifyListeners();
    }
    return userCredential;
  }

  //* upload image

  uploadImageToFirebase(File imageFile) async {
    try {
      // UploadTask uploadTask = storageRef.ref("images").putFile(File(imageFile!, "fileName"));
      final ref = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      UploadTask task = ref.putFile(imageFile);
      // String downlaodUrl = await task
    } catch (e) {
      log(e.toString());
    }
  }

  //* google signin
  Future<void> handleGoogleSignIn() async {
    notifyListeners();

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          UserModel userModel = UserModel(
              userId: Uuid().v1(),
              imageUrl: firebaseUser.photoURL.toString(),
              email: firebaseUser.email.toString(),
              username: firebaseUser.displayName.toString(),
              password: "",
              phone: firebaseUser.phoneNumber.toString(),
              createdOn: DateTime.now().millisecondsSinceEpoch.toString());

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userModel.userId)
              .set(userModel.toMap());
        }
      }
    }
  }

  void logoutFunction(BuildContext context) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    try {
      await preference.clear();

      await FirebaseAuth.instance.signOut().then((value) => [
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => SigninScreen())),
          ]);
    } catch (e) {
      log(e.toString());
    }
  }
}

import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RealTimeFunctions {
  static FirebaseDatabase databaseInstance = FirebaseDatabase.instance;
  final pathCollection = "posts";

  static createPostFromRealTimeServices(
      {required String value, required BuildContext context}) async {
    try {
      if (value.isNotEmpty) {
        // var id = DateTime.now().toString();
        var id = Uuid().v1().toString();
        await databaseInstance.ref("post").child(id).set({
          "content": value,
          "id": id,
          "createdOn": DateTime.now().toString()
        }).then((value) => [
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                content: const Text(
                  "post is successfull",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              )),
              Navigator.pop(context),
            ]);
      } else {
        var snackbar = const SnackBar(
          content: Text(
            "please type something to post!!!!!!!!!!!!!!!!!!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

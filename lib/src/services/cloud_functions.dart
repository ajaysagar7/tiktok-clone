import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CloudFunctions {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final pathCollection = "posts";

  static createPostFromCloudServices(
      {required String value, required BuildContext context}) async {
    try {
      if (value.isNotEmpty) {
        var id = DateTime.now().toString();
        await fireStore.collection("posts").doc(id).set({
          "content": value,
          "id": id,
          "createdOn": DateTime.now().toString()
        }).then((value) => [
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                content: const Text(
                  "post is successfull",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              )),
              Navigator.pop(context),
            ]);
      } else {
        var snackbar = SnackBar(
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: "ok",
              textColor: Colors.blue,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
          content: Text(
            "type something to post!!!!!!!!!!!!!!!!!!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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

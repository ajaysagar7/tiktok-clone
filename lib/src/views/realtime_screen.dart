import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants/app_colors.dart';
import 'package:flutter_chat_app/src/views/post/create_post.dart';
import 'package:intl/intl.dart';

class RealTimeStorageScreen extends StatefulWidget {
  const RealTimeStorageScreen({super.key});

  @override
  State<RealTimeStorageScreen> createState() => _RealTimeStorageScreenState();
}

class _RealTimeStorageScreenState extends State<RealTimeStorageScreen> {
  final _postStream = FirebaseDatabase.instance.ref("post");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Real Time Database Flutter")),
        body: StreamBuilder<DatabaseEvent>(
            stream: _postStream.onValue,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error occoured : ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.pinkAccent),
                );
              }
              if (snapshot.data!.snapshot.children.isEmpty) {
                return const Center(
                  child: Text("No Data found on firebase"),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (c, i) {
                      Map<dynamic, dynamic> data = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;

                      List<dynamic> dataList = [];
                      dataList.clear();
                      dataList = data.values.toList();
                      var title = dataList[i]["content"];
                      var dateString = dataList[i]["createdOn"].toString();
                      var createdON =
                          DateFormat.yMMMd().format(DateTime.parse(dateString));
                      return Card(
                          color: Colors
                              .primaries[
                                  Random().nextInt(Colors.primaries.length)]
                              .shade200,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(9),
                          child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Text(title),
                              subtitle: Text(createdON),
                              trailing: PopupMenuButton(
                                elevation: 7,
                                enableFeedback: true,
                                enabled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                icon: const Icon(Icons.more_vert_outlined),
                                itemBuilder: (c) => [
                                  PopupMenuItem(
                                      padding: EdgeInsets.zero,
                                      value: 0,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text("Update"),
                                      )),
                                  PopupMenuItem(
                                      padding: EdgeInsets.zero,
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          FirebaseDatabase.instance
                                              .ref("post")
                                              .child(
                                                  dataList[i]["id"].toString())
                                              .remove()
                                              .then((value) => [
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                                "post deleted successfully")))
                                                  ])
                                              .onError((error, stackTrace) => [
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(error
                                                                .toString())))
                                                  ]);
                                        },
                                        leading:
                                            Icon(Icons.delete_forever_rounded),
                                        title: Text("Delete"),
                                      )),
                                ],
                              )));
                    });
              }
            })),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CreatePostScreen()));
          },
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(CupertinoIcons.create),
          ),
        ),
      ),
    );
  }
}

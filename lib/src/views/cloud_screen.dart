import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants/app_colors.dart';
import 'package:flutter_chat_app/src/views/post/create_post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CloudStorageScreen extends StatefulWidget {
  const CloudStorageScreen({super.key});

  @override
  State<CloudStorageScreen> createState() => CloudStorageScreenState();
}

class CloudStorageScreenState extends State<CloudStorageScreen> {
  final _postStream =
      FirebaseFirestore.instance.collection("posts").snapshots();
  final updateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Cloud Storage  Flutter")),
        body: StreamBuilder(
          // initialData: null,
          stream: _postStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            } else {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("No Data Found"),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, i) {
                      // Map<String, dynamic> data =
                      //     snapshot.data!.docs[i] as Map<String, dynamic>;
                      var title = snapshot.data!.docs[i]["content"];
                      var createdON = DateFormat.yMMMd().format(DateTime.parse(
                          snapshot.data!.docs[i]["createdOn"].toString()));
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
                              padding: EdgeInsets.zero,
                              enableFeedback: true,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              itemBuilder: (c) => [
                                PopupMenuItem(
                                    value: 0,
                                    child: ListTile(
                                        trailing: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            updateController.text = snapshot
                                                .data!.docs[i]["content"]
                                                .toString();
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (c) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Update the content of your post"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          maxLines: 4,
                                                          controller:
                                                              updateController,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "posts")
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[i]["id"]
                                                                  .toString())
                                                              .update({
                                                                "content":
                                                                    updateController
                                                                        .text
                                                                        .toString()
                                                              })
                                                              .then((value) => [
                                                                    updateController
                                                                        .clear(),
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "update success",
                                                                        backgroundColor:
                                                                            Colors.green),
                                                                    Navigator.pop(
                                                                        context),
                                                                  ])
                                                              .onError((error,
                                                                      stackTrace) =>
                                                                  [
                                                                    Navigator.pop(
                                                                        context),
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "update failed",
                                                                        backgroundColor:
                                                                            Colors.red),
                                                                    debugPrint(error
                                                                        .toString()),
                                                                  ]);
                                                        },
                                                        child: const Text(
                                                            "Update")),
                                                  ],
                                                );
                                              });
                                        })),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      trailing: const Icon(Icons.delete),
                                      title: const Text("Delete"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        FirebaseFirestore.instance
                                            .collection("posts")
                                            .doc(snapshot.data!.docs[i]["id"]
                                                .toString())
                                            .delete()
                                            .then((value) => [
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                              "post deleted successfully")))
                                                ])
                                            .onError((error, stackTrace) => [
                                                  ScaffoldMessenger.of(context)
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
                                    ))
                              ],
                            )),
                      );
                    });
              }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CreatePostScreen()));
          },
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(
              Icons.create,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

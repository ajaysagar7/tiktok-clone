// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/bouncer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_chat_app/constants/app_colors.dart';

import 'package:flutter_chat_app/src/models/chatroom_model.dart';
import 'package:flutter_chat_app/src/models/message_model.dart';
import 'package:flutter_chat_app/src/views/auth/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import "package:timeago/timeago.dart" as timeAgo;
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  ChatRoomModel chatRoomModel;
  ChatScreen({
    Key? key,
    required this.chatRoomModel,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              title: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.chatRoomModel.senderId)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data found"),
                      );
                    }
                    return Container(
                      height: 60,
                      child: ListTile(
                        leading: snapshot.data!["imageUrl"].toString().isEmpty
                            ? const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/default.png"),
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data!["imageUrl"])),
                        subtitle: Text(
                          snapshot.data!["email"].toString(),
                        ),
                        title: Text(snapshot.data!["username"].toString()),
                      ),
                    );
                  }
                }),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(widget.chatRoomModel.chatRoomid)
                  .collection("messages")
                  .orderBy("createdOn", descending: true)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return snapshot.data!.docs.length == 0
                      ? Center(
                          child: CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                await sendMessage("first message");
                              },
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  controller: scrollController,
                                  reverse: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (c, i) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot
                                            .data!.docs[i]["text"]
                                            .toString()),
                                      ),
                                    );
                                  }),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                height: 60.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabled: true,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "write a message"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    CircleAvatar(
                                      child: IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () async {
                                          await sendMessage(messageController
                                              .text
                                              .toString());
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                }
                return Container();
              }),
            )));
  }

  sendMessage(String value) async {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: "enter something");
    } else {
      MessageModel model = MessageModel()
        ..messageId = Uuid().v1()
        ..createdOn = DateTime.now().toString()
        ..sender = FirebaseAuth.instance.currentUser!.uid.toString()
        ..seen = false
        ..text = value;
      log(model.toString());

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatRoomid)
          .collection("messages")
          .doc(model.messageId)
          .set(model.tojson())
          .then((value) => [
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut),
                messageController.clear(),
              ]);

      Fluttertoast.showToast(
        msg: "message sent successfully",
        backgroundColor: Colors.green,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

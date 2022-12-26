import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/src/models/chatroom_model.dart';
import 'package:flutter_chat_app/src/models/user_model.dart';
import 'package:flutter_chat_app/src/provider/auth_provider.dart';
import 'package:flutter_chat_app/src/provider/notification_provider.dart';
import 'package:flutter_chat_app/src/services/local_notification_services.dart';
import 'package:flutter_chat_app/src/views/auth/notification_example.dart';
import 'package:flutter_chat_app/src/views/auth/signin_screen.dart';
import 'package:flutter_chat_app/src/views/chat_screen.dart';
import 'package:flutter_chat_app/src/views/second_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  UserModel? primaryUser;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    //* terminated state
    FirebaseMessaging.instance.getInitialMessage().then((value) => {
          if (value != null)
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => SecondScreen(message: value)))
            }
        });

    //* foregroudn state(user-interating with ui)
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.init();
      LocalNotificationService.displayNotification(event);
    });
  }

  Future<UserModel?> getPrimaryUser() async {
    var pref = await SharedPreferences.getInstance();
    var uid = pref.getString("uid");
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    primaryUser = UserModel.fromDoc(userSnapshot);
    log(primaryUser!.toJson().toString());
    return primaryUser;
  }

  @override
  Widget build(BuildContext context) {
    final fcmProvider = Provider.of<NotificationProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("HomePage"),
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<AuthProvider>().logoutFunction(context);
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Center(child: Text(snapshot.error.toString())),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, i) {
                    // var data = snapshot.data!.docs[i].data();
                    UserModel userModel =
                        UserModel.fromDoc(snapshot.data!.docs[i]);
                    log(userModel.toJson());
                    // Map<String, dynamic> data =
                    //     snapshot.data!.docs[i].data()! as Map<String, dynamic>;

                    return ListTile(
                      onTap: () async {
                        fcmProvider.sendNotification(
                            token: userModel.deviceToken.toString(),
                            title: userModel.username.toString(),
                            body: userModel.email.toString());
                        // ChatRoomModel? chatRoomModel =
                        //     await getChatRoomModel(userModel);
                        // if (chatRoomModel != null) {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (c) {
                        //     return ChatScreen(chatRoomModel: chatRoomModel);
                        //   }));
                        // }
                      },
                      leading: userModel.imageUrl!.isEmpty
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/default.png"),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(snapshot
                                  .data!.docs[i]["imageUrl"]
                                  .toString()),
                              // backgroundImage: CachedNetworkImageProvider(
                              //   snapshot.data!.docs[i]["imageUrl"].toString(),
                              // ),
                            ),
                      title: Text(userModel.username.toString()),
                      subtitle: Text(userModel.email.toString()),
                    );
                  });
            }),
          )),
    );
  }
}

getChatRoomModel(UserModel userModel) async {
  ChatRoomModel? chatroomModel;

  final pref = await SharedPreferences.getInstance();
  var uid = pref.getString("uid");

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("chatrooms")
      .where("participants.${uid.toString()}", isEqualTo: true)
      .where("participants.${userModel.userId.toString()}", isEqualTo: true)
      .get();

  if (querySnapshot.docs.length > 0) {
    log("chat room found");
    chatroomModel = ChatRoomModel.fromMap(
        querySnapshot.docs[0].data() as Map<String, dynamic>);
  } else {
    log("No chatroom Exists");
    chatroomModel = ChatRoomModel(
        chatRoomid: Uuid().v1(),
        // members: [
        //   userModel,
        // ],
        lastMessage: "",
        participants: {
          userModel.userId.toString(): true,
          FirebaseAuth.instance.currentUser!.uid.toString(): true
        },
        senderId: userModel.userId.toString(),
        buyerId: uid.toString(),
        createdDate: DateTime.now().toString());

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomModel.chatRoomid)
        .set(chatroomModel.toJson());
  }
  return chatroomModel;
}

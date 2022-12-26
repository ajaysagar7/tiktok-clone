// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_app/src/models/user_model.dart';

class ChatRoomModel {
  final String chatRoomid;
  // final List<UserModel> members;
  final String lastMessage;
  final String senderId;
  final String buyerId;
  Map<String, dynamic>? participants;
  final String createdDate;
  ChatRoomModel({
    required this.chatRoomid,
    // required this.members,
    required this.lastMessage,
    required this.senderId,
    required this.buyerId,
    this.participants,
    required this.createdDate,
  });

  // factory ChatRoomModel.fromDoc(DocumentSnapshot snapshot) {
  //   final snap = snapshot.data() as Map<String, dynamic>;

  //   return ChatRoomModel(
  //       chatRoomid: snap["chatRoomid"],
  //       members: snap["members"],
  //       lastMessage: snap["lastMessage"],
  //       senderId: snap["senderId"],
  //       buyerId: snap["buyerId"],
  //       participants: snap["participants"],
  //       createdDate: snap["createdDate"]);
  // }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
        chatRoomid: map["chatRoomid"],
        // members: map["members"],
        lastMessage: map["lastMessage"],
        senderId: map["senderId"],
        buyerId: map["buyerId"],
        participants: map['participants'],
        createdDate: map["createdDate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "chatRoomid": chatRoomid,
      // "members": members,
      "lastMessage": lastMessage,
      "senderId": senderId,
      "buyerId": buyerId,
      "createdDate": createdDate,
      "participants": participants
    };
  }
}

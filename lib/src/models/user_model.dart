// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? imageUrl;
  String? email;
  String? username;
  String? password;
  String? phone;
  String? createdOn;
  String? deviceToken;
  UserModel({
    required this.userId,
    required this.imageUrl,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    required this.createdOn,
    this.deviceToken,
  });

  UserModel copyWith({
    String? userId,
    String? imageUrl,
    String? email,
    String? username,
    String? password,
    String? phone,
    String? createdOn,
  }) {
    return UserModel(
        userId: userId ?? this.userId,
        imageUrl: imageUrl ?? this.imageUrl,
        email: email ?? this.email,
        username: username ?? this.username,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        createdOn: createdOn ?? this.createdOn,
        deviceToken: deviceToken ?? this.deviceToken);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'imageUrl': imageUrl,
      'email': email,
      'username': username,
      'password': password,
      'phone': phone,
      'createdOn': createdOn,
      "deviceToken": deviceToken
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userId: map['userId'] as String,
        imageUrl: map['imageUrl'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        phone: map['phone'] as String,
        createdOn: map["createdOn"] as String,
        deviceToken: map["deviceToken"] as String);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromDoc(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        userId: snap["userId"],
        imageUrl: snap["imageUrl"],
        email: snap["email"],
        username: snap["username"],
        password: snap["password"],
        phone: snap["phone"],
        deviceToken: snap["deviceToken"],
        createdOn: snap["createdOn"].toString());
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, imageUrl: $imageUrl, email: $email, username: $username, password: $password, phone: $phone, createdOn: $createdOn)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.imageUrl == imageUrl &&
        other.email == email &&
        other.username == username &&
        other.password == password &&
        other.phone == phone &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        imageUrl.hashCode ^
        email.hashCode ^
        username.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        createdOn.hashCode;
  }
}

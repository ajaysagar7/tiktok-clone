import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static displayNotification(RemoteMessage pushMessage) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            importance: Importance.high,
            color: Colors.blue,
            autoCancel: true,
            enableVibration: true,
            playSound: true,
            "push Notifications",
            "pusn notificatoin channel",
            priority: Priority.high));

    final int id = DateTime.now().microsecondsSinceEpoch.toSigned(5);
    await _flutterLocalNotificationsPlugin.show(
        id,
        pushMessage.notification!.title.toString(),
        pushMessage.notification!.body.toString(),
        notificationDetails,
        payload: pushMessage.data["id"]);
  }
}

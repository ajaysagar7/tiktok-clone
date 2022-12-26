//* STEP-1 : download packages

// flutter_local_notifications:
// firebase_messaging
// http or dio

//! step 2:  generate device token
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

Future<String> getDeviceToken() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String? token = await messaging.getToken();
  return token!;
}

// add token to firebase  in both signup and sign in function for latest device token;
// String token = await getDeviceToken();
//   {
//     "token" : token
//   }


//! STEP 3 : create Notification Provider Class
// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;

// class NotificationProvider with ChangeNotifier {
//   sendNotification({
//     required String token,
//     required String title,
//     required String body,
//   }) async {
//     const posturl = "https://fcm.googleapis.com/fcm/send";
//     Map<String, dynamic> data;

//     data = {
//       "registration_ids": [token],
//       "collapse_key": "type_a",
//       "notification": {
//         "title": title,
//         "body": body,
//       },
//       "data": {
//         "title": title,
//         "body": body,
//         "_id" : "this data can be send before getting push notification"
//       },
//     };

//     String serverKey =
//         "AAAAS7oYVus:APA91bET9kUnXN28uYgppYci4VoEqmH3aS_0GZevjVNu6vpGoOyqpchfjTgu-SECSh-y2z5mGgfysUxCe02jmtZyc00OwJjIdlUfvrjrc7gPAHMNa4IAoReiWvwM03M0KUU-FzcSY86G";

//     final response = await http.post(Uri.parse(posturl),
//         body: jsonEncode(data),
//         headers: {
//           "content-type": "application/json",
//           "Authorization": "Key=$serverKey"
//         });

//     if (response.statusCode == 200) {
//       log(response.body.toString());
//     } else {
//       log("error occoured in send push notifications");
//     }
//   }
// }



//! STEP 5 : send notification manually with user details in listview (users)

  //! initialze provider below build context
    // final fcmProvider = Provider.of<NotificationProvider>(context);

  //! on tap function
//  fcmProvider.sendNotification(
//                             token: userModel.deviceToken.toString(),
//                             title: userModel.username.toString(),
//                             body: userModel.email.toString());


//! Step 6 : create local-notification class
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static init() {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");

//     InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);

//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

// static  displayNotification(RemoteMessage pushMessage) async {
//     const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//             "push Notifications", "pusn notificatoin channel",
//             priority: Priority.high));

//     final int id = DateTime.now().microsecondsSinceEpoch.toSigned(5);
//     await _flutterLocalNotificationsPlugin.show(
//         id,
//         pushMessage.notification!.title.toString(),
//         pushMessage.notification!.body.toString(),
//         notificationDetails,
//         payload: pushMessage.data["id"]);
//   }
// }


//! STEP 7 : define push notification states 



//! FOREGROUDN STATE 
//when user is interacting with ui and notification will shows as material banner
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.init();
    //   LocalNotificationService.displayNotification(event);
    // });  

// -------------------------------------------------------------------------------------------


//! TERIMINATED STATE
// when  app is closed and user click on notification


    // FirebaseMessaging.instance.getInitialMessage().then((value) => {
    //       if (value != null)
    //         {
    //           Navigator.of(context).push(MaterialPageRoute(
    //               builder: (c) => SecondScreen(message: value)))
    //         }
    //     });


  // // ignore_for_file: public_member_api_docs, sort_constructors_first
  //! user can user ontap on notification function in page like this
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class SecondScreen extends StatelessWidget {
//   RemoteMessage message;
//   SecondScreen({
//     Key? key,
//     required this.message,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(message.data.toString()),
//           Text(message.notification!.toMap().toString())
//         ],
//       )),
//     ));
//   }
// }



     










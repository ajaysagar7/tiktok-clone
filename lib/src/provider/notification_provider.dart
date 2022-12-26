import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NotificationProvider with ChangeNotifier {
  sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    const posturl = "https://fcm.googleapis.com/fcm/send";
    Map<String, dynamic> data;

    data = {
      "registration_ids": [token],
      "collapse_key": "type_a",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "title": title,
        "body": body,
        "_id" : "this data can be send before getting push notification"
      },
    };

    String serverKey =
        "AAAAS7oYVus:APA91bET9kUnXN28uYgppYci4VoEqmH3aS_0GZevjVNu6vpGoOyqpchfjTgu-SECSh-y2z5mGgfysUxCe02jmtZyc00OwJjIdlUfvrjrc7gPAHMNa4IAoReiWvwM03M0KUU-FzcSY86G";

    final response = await http.post(Uri.parse(posturl),
        body: jsonEncode(data),
        headers: {
          "content-type": "application/json",
          "Authorization": "Key=$serverKey"
        });

    if (response.statusCode == 200) {
      log(response.body.toString());
    } else {
      log("error occoured in send push notifications");
    }
  }
}

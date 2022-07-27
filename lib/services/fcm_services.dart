// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

dynamic serverKey =
    "AAAA_aADkKs:APA91bHYHJyCurXWPnCuuJYs9odY4VsAZ-QY06740YUIx2MYzxC6gqWDs4VU8ArQsXOvM-KB6aJ-2fEnI1sSrQ5sfVnM_SKQd3QwbpbLVhAWE6MWDE1SFmslSJtTMiqMeiWHqQnttOxN";

class FCMServices {
  static fcmGetTokenandSubscribe(topic) {
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseMessaging.instance.subscribeToTopic("$topic");
      print("SUBSCRIBEDDDD");
    });
  }

  static Future<http.Response> sendFCM(topic, id, title, description) {
    print("HERRRRRR---------");
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "key=$serverKey",
      },
      body: jsonEncode({
        // "to": "/topics/$topic",
        'to': "$topic",
        "notification": {
          "title": title,
          "body": description,
        },
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        "data": {
          // "android_channel_id": "crave",
          "id": id,
          "userName": "crave",
        }
      }),
    );
  }
}

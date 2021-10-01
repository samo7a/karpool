// import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notification {
  late final token;
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static init() {
    // super.initState();
    // _getToken();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('A new onMessageOpenedApp event was published! $message');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('a message from firebase: ${message.data.toString()}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message');
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published! $message');
    });

    FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      criticalAlert: true,
    );
  }

  _getToken() async {
    token = await firebaseMessaging.getToken();
    print("token : $token");
  }
}

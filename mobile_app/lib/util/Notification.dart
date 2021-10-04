// import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Message {
  String? title;
  String? body;
  dynamic data;

  Message({
    this.title,
    this.body,
    this.data,
  });
}

class Notification {
  // static late final String? token;

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static List<Message> messages = [];

  static init() async {
    // print("token : " + await getToken());
    firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      criticalAlert: true,
      provisional: false,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
    );

    //when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('A new getInitialMessage event was published! $message');
    });

    //when the app is on the foreground. works only on android
    FirebaseMessaging.onMessage.listen(_firebaseMessagingFrontgroundHandler);

    //when the app is in the background not terminated.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      Message m = Notification._getMessage(message);
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 12223,
          channelKey: 'basic_channel',
          title: m.title,
          body: m.body,
          // notificationLayout: NotificationLayout.BigText,
        ),
      );
      print('A new onMessageOpenedApp event was published! $message');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static getToken() async {
    return await firebaseMessaging.getToken();
  }

  static _getMessage(RemoteMessage? message) {
    final notification = message!.notification;
    print(message.data.toString());
    String? title = notification!.title;
    String? body = notification.body;
    print(title);
    print(body);
    return Message(title: title, body: body);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  Message m = Notification._getMessage(message);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 12113,
      channelKey: 'basic_channel',
      title: m.title,
      body: m.body,
      // notificationLayout: NotificationLayout.BigText,
    ),
  );
  print('A new onBackgroundMessage event was published! ${message!.data}');
}

Future<void> _firebaseMessagingFrontgroundHandler(RemoteMessage? message) async {
  print("foreground notification triggered");
  Message m = Notification._getMessage(message);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 12344,
      channelKey: 'basic_channel',
      title: m.title,
      body: m.body,
      notificationLayout: NotificationLayout.BigText,
    ),
  );
  print(m.title);
  print(m.body);
  print('a data from firebase: ${message!.data}');
}

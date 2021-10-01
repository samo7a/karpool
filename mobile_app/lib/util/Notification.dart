// import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Message {
  String? title;
  String? body;
  // Map<dynamic, dynamic>? payLoad;

  Message({
    this.title,
    this.body,
    // this.payLoad,
  });
}

class Notification {
  static late final String? token;

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static List<Message> messages = [];

  static init() async {
    firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      criticalAlert: true,
    );
    // await FirebaseMessaging.instance.
    // await FirebaseMessaging.instance.getAPNSToken();

    print("token from Notification object: ${await _getToken()}");
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
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
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('A new onMessageOpenedApp event was published! $message');
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null) {
        Message m = _getMessage(message);
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            channelKey: 'basic_channel',
            title: m.title,
            body: m.body,
            notificationLayout: NotificationLayout.BigText,
          ),
        );
        print('a message from firebase: ${message.data.toString()}');
      }
    });

    await FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message != null) {
        // _setMessage(message);
        Message m = _getMessage(message);
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            channelKey: 'basic_channel',
            title: m.title,
            body: m.body,
            notificationLayout: NotificationLayout.BigText,
          ),
        );
        print('A new onMessageOpenedApp event was published! $message');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static _getToken() async {
    token = await firebaseMessaging.getToken();
    return token;
  }

  static _getMessage(RemoteMessage? message) {
    final notification = message!.notification;
    // final data = message.data;
    String? title = notification!.title;
    String? body = notification.body;
    print(title);
    print(body);
    return Message(title: title, body: body);
    // Map<dynamic, dynamic>? payLoad = message
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // _getMessage(message);
  Message m = Notification._getMessage(message);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      channelKey: 'basic_channel',
      title: m.title,
      body: m.body,
      // notificationLayout: NotificationLayout.BigText,
    ),
  );
  print('A new onBackgroundMessage event was published! $message');
}

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zlp_poc/notification/local_notification_service.dart';

class Fcm {
  Fcm._internal();

  static final Fcm instance = Fcm._internal();

  FirebaseMessaging get firebaseMessaging {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.setAutoInitEnabled(true);
    return firebaseMessaging;
  }

  Future<void> setUpNotificationBeforeRunApp() async {
    LocalNotificationService.instance.createNotificationChanel();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void listenRemoteMessageOnOpenApp(BuildContext context) {
    /// Work when app is in the background button opened when user taps on notification
    /// App is in the background, terminated, close and user tap on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleTapOnNotification(message, context);
    });
  }

  void getInitialMessage(BuildContext context) {
    /// Give the message on which user taps
    /// And it opened the app from terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      /// Do the same on the stream listen function onMessageOpenedApp
      if (message != null) {
        addNotificationToLocal(message);
        handleTapOnNotification(message, context);
      }
    });
  }

  void showingComingNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.instance.display(message);
      addNotificationToLocal(message);
      print('====message====: ${message.data}');
    });
  }

  void handleTapOnNotification(RemoteMessage message, BuildContext context) {
    RemoteNotification? notification = message.notification;
    // if (notification != null) {
    //   NotificationData notificationData =
    //   NotificationData.fromJson(message.data);
    //   NotificationItem notificationItem =
    //   convertFromNotificationDataToItem(notificationData);
    //
    //   LocalNotificationService.instance.onTapNotification(
    //     buttonKeyPressed: '',
    //     notificationItem: notificationItem,
    //   );
    // }
  }

  void addNotificationToLocal(RemoteMessage message) {
    // NotificationData notificationData = NotificationData.fromJson(message.data);
    // getIt<NotificationBloc>().add(
    //   AddLatestNotificationEvent(
    //     notificationItem: convertFromNotificationDataToItem(notificationData),
    //   ),
    // );
  }

  static Future<void> generateFcmToken() async {
    await Fcm.instance.firebaseMessaging.deleteToken();
    final fcmToken = await Fcm.instance.firebaseMessaging.getToken() ?? '';
  }
}

import 'dart:io';

import 'package:zlp_poc/notification/fcm.dart';

class PushNotification {
  PushNotification._internal();

  static final PushNotification instance = PushNotification._internal();

  Future<void> requestNotificationPermission() async {
    if (Platform.isIOS) {
      await Fcm.instance.firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }
}

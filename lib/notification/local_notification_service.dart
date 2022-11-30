import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// final String notificationSound = 'notification.mp3';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'zlp_notifications',
  'ZLP Notifications',
  description: 'Notification channel for ZLP project',
  ledColor: Colors.white,
  playSound: true,
  enableVibration: true,
  importance: Importance.max,
  showBadge: true,
);

class LocalNotificationService {
  LocalNotificationService._internal();

  static final LocalNotificationService instance =
      LocalNotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void createNotificationChanel() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  final NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      playSound: true,
      icon: '@drawable/white_logo',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      // sound: RawResourceAndroidNotificationSound(
      //   notificationSound.split('.').first,
      // ),
      channelShowBadge: true,
      color: Colors.yellow,
    ),
    iOS: IOSNotificationDetails(
      // sound: notificationSound,
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    ),
  );

  void initializeSettings(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/white_logo');
    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {},
    );
    tz.initializeTimeZones();
  }

  /// Handle notification UI
  void display(RemoteMessage message) async {
    print('link image ${message.data['imageURL']}');
    // final String _largeIcon =
    //     await _downloadAndSaveFile('https://www.zuelligpharma.com/images/content/news_and_thought_leadership/news/ZPwebsiteLogo.png', 'largeIcon');
    //
    // BigPictureStyleInformation? bigPictureStyleInformation;
    // if (message.data['imageURL'] != null) {
    //   final String _bigPicture =
    //       await _downloadAndSaveFile('https://www.zuelligpharma.com/images/content/news_and_thought_leadership/news/ZPwebsiteLogo.png', 'bigPicture');
    //   bigPictureStyleInformation = BigPictureStyleInformation(
    //     FilePathAndroidBitmap(_bigPicture),
    //     largeIcon: FilePathAndroidBitmap(_largeIcon),
    //     hideExpandedLargeIcon: true,
    //   );
    // }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      // sound: RawResourceAndroidNotificationSound(
      //   notificationSound.split('.').first,
      // ),
      // largeIcon: FilePathAndroidBitmap(_largeIcon),
      channelShowBadge: true,
      // styleInformation: bigPictureStyleInformation,
    );
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['title'],
        message.data['description'],
        NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: IOSNotificationDetails(
            // sound: notificationSound,
            presentSound: true,
            presentAlert: true,
            presentBadge: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Call on initState of MyAppSate to display notification automatically
  void displayScheduleNotification() async {
    cancelScheduledNotifications();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Zporter Diary',
      'Any training or matches today?',
      scheduleDaily(const Time(21, 30)),
      _notificationDetails,
      payload: defaultPayload(
        notificationType: '',
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  /// =========================================================================
  /// Show normal notification
  void showNormalNotification(String title, String body) async {
    await _flutterLocalNotificationsPlugin.show(
      4,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          playSound: true,
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          // sound: RawResourceAndroidNotificationSound(
          //   notificationSound.split('.').first,
          // ),
          channelShowBadge: false,
        ),
        iOS: IOSNotificationDetails(
          // sound: notificationSound,
          presentSound: true,
          presentAlert: true,
          presentBadge: false,
        ),
      ),
      payload: defaultPayload(notificationType: 'Download'),
    );
  }

  /// =========================================================================
  /// Cancel the notification

  void cancelScheduledNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// =========================================================================
  /// Push to screen when tap on the notification
  /// Push to player diary update form

  /// Push to biography

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<bool?> requestNotificationPermission() async =>
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

  String defaultPayload({required String notificationType}) {
    return jsonEncode({
      "createdAt": "1634746872400",
      "notificationStatus": 'true',
      "senderId": "FRm9kt1fqoalpkiBBrQUWFgbRMm1",
      "receiverId": "R0kYq1vZS7bFnTppuifAz8wFm5f1",
      "notificationId": "",
      "notificationType": notificationType,
      "body": "",
      "title": "",
      "username": ""
    });
  }
}

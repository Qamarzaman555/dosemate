import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../views/home_view/home_vu.dart';

class Notifications {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<NotificationDetails> notificationsDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'medicine_reminder_channel',
        'Medicine Reminder',
        channelDescription: "Don't Forget to Take Your Medicines",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future<void> init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeVU(),
          ),
        );

        onNotifications.add(response.payload);
      },
    );
  }

  static Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await notificationsDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification({required int id}) async {
    await notifications.cancel(id);
  }
}

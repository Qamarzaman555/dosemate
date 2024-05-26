import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../views/home_view/home_vu.dart';

class Notifications {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationsDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'Medicine Reminder',
        "Don't Forget to Take Your Medicines",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('time_workout');
    const settings = InitializationSettings(android: android);

    await notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeVU(),
          ));

      onNotifications.add(payload as String);
    });
  }

  static Future showNotifications({
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

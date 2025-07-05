import 'package:calendar_view/src/enumerations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //initialization
  Future<void> initNotification() async {
    if (_isInitialized) {
      return;
    }

    //set local timezone
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    //prepare  android init settings
    const initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    //finally initialize plugin
    await notificationsPlugin.initialize(initSettings);
    print("notifications init");
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily Notifications',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high));
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification({
    int id = 1,
    String? title,
    String? body,
    required DateTime time,
    RepeatFrequency? repeatFrequency,
  }) async {
    final now = tz.TZDateTime.from(time, tz.local);
    await notificationsPlugin.zonedSchedule(
      id, title, body, now, notificationDetails(),

      //android specific allow the notification in low power mode
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: switch (repeatFrequency) {
        RepeatFrequency.daily => DateTimeComponents.time,
        RepeatFrequency.monthly => DateTimeComponents.dayOfMonthAndTime,
        RepeatFrequency.yearly => DateTimeComponents.dateAndTime,
        RepeatFrequency.weekly => DateTimeComponents.dayOfWeekAndTime,
        RepeatFrequency.doNotRepeat => null,
        null => null,
      },
    );
  }

  Future<void> cancellNotifications() async {
    notificationsPlugin.cancelAll();
  }
}

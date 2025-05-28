// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();

//   factory NotificationService() => _instance;

//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     tz.initializeTimeZones();

//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const initializationSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // 🔴 إنشاء قناة الإشعارات
//     const androidChannel = AndroidNotificationChannel(
//       'vet_channel_id',
//       'Vet Reminders',
//       description: 'تذكيرات لزيارات الطبيب البيطري',
//       importance: Importance.max,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(androidChannel);
//   }

//   NotificationDetails _notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'vet_channel_id',
//         'Vet Reminders',
//         channelDescription: 'تذكيرات لزيارات الطبيب البيطري',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//   }

//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       _notificationDetails(),
//     );
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required tz.TZDateTime scheduledDate,
//   }) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       _notificationDetails(),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime, uiLocalNotificationDateInterpretation: ,
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiServes {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final bool _isIntialized = false;
  bool get isIntialized => _isIntialized;

  //initalzed
  Future<void> initNotification() async {
    if (_isIntialized) return;

    //init timezon
    tz.initializeTimeZones();
    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));

    //androd
    const initStettingAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //ios
    const initStetingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //init setting
    const initSettings = InitializationSettings(
      android: initStettingAndroid,
      iOS: initStetingsIos,
    );

    //fa
    await notificationsPlugin.initialize(initSettings);
  }

  //noti det
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'daily notification',
        channelDescription: 'daily notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //show notification
  Future<void> shownotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  //schedul noitifications

  Future<void> schedulenotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    //create date
    var scheduledate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    //sechdule notif
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledate,
      notificationDetails(),
      //ios
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      //and
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("nooooooooootiiiiiiiiiiii");
  }

  //cancel
  Future<void> cancelnotification() async {
    await notificationsPlugin.cancelAll();
  }
}

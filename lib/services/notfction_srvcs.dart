import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/tsk.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  cencelNotification(Task tsk) async {
    await flutterLocalNotificationsPlugin.cancel(tsk.id!);
  }

  cencelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  displayNotification({required String title, required String body}) async {
    print('doing test');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high);
    IOSNotificationDetails iosPlatformChannelSpecifics =
        const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formatdDate = DateFormat.yMd().parse(date);
    final tz.TZDateTime formatedLocalDt =
        tz.TZDateTime.from(formatdDate, tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, formatedLocalDt.year,
        formatedLocalDt.month, formatedLocalDt.day, hour, minutes);

    scheduledDate = reminding(remind, scheduledDate);
    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily')
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatdDate.day) + 1, hour, minutes);
      else if (repeat == 'Weekly')
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatdDate.day) + 7, hour, minutes);
      else if (repeat == 'Monthly')
        scheduledDate = tz.TZDateTime(tz.local, now.year,
            (formatdDate.month) + 1, formatdDate.day, hour, minutes);
      scheduledDate = reminding(remind, scheduledDate);
    }

    print('Next SchedualeDate = $scheduledDate');
    return scheduledDate;
  }

  tz.TZDateTime reminding(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 1)
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 1));
    else if (remind == 5)
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    else if (remind == 10)
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    else if (remind == 15)
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    else if (remind == 20)
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    return scheduledDate;
  }

  /*
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  */

/*final List<ActiveNotification>? requestAndroidPermissions =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
        */

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

//Older IOS
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }
}

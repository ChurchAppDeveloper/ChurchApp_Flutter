import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws/flutter_aws.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  var daysArray = [
    Day.sunday,
    Day.monday,
    Day.tuesday,
    Day.wednesday,
    Day.thursday,
    Day.friday,
    Day.saturday
  ];

  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  // static const MethodChannel platform =
  //     MethodChannel('dexterx.dev/flutter_local_notifications_example');
  var initializationSettings;

  notificationPluginInitilization() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // if (Platform.isIOS) {
    initializePlatformSpecifics();
    // }
    configureLocalTimeZone();
  }

  Future initialise() async {
    // Aws.initialize();
    notificationPluginInitilization();
    Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
      Aws.onMessage(message);
      if (message.containsKey('data')) {
        // Handle data message
        final dynamic data = message['data'];
      }

      if (message.containsKey('notification')) {
        // Handle notification message
        final dynamic notification = message['notification'];
      }

      // Or do other work.
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        displayNotification(message);
        await Aws.onMessage(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await Aws.onMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await Aws.onMessage(message);
      },
    );

    _fcm.onTokenRefresh.listen((String token) {
      Aws.registerDeviceToken(token);
    });

    _fcm.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));

    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});

    _fcm.onTokenRefresh.listen((String token) {
      // ignore: deprecated_member_use
      Aws.onNewToken(token);
    });

    _fcm.getToken().then((String token) {
      Aws.registerDeviceToken(token);
      print("FirebaseMessaging token: $token");
      sendTokenToServer(token);
    });
  }

  configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    print("timeZoneName $timeZoneName");
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  sendTokenToServer(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Compare and send token to server
    String pushtoken = prefs.getString('pushtoken');
    if (pushtoken != token) {
      prefs.setString('newpushtoken', token);
    }

    // final String url =
    //     'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/deviceModule';
    // Map data = {'deviceToken': token};
    // String body = json.encode(data);
    // http.Response response = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: body);
    // print(response.body.toString());
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('channel-id', 'fcm', 'androidcoding.in');
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentAlert: true, presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message["default"],
      message["default"],
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notif_app');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    // if (payload != null) {
    //   debugPrint('notification payload: ' + payload);
    // }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var wepage = WebViewLoad(
    //     weburl: prefs.getString('youtubeUrl'),
    //     isShowAppbar: true,
    //     pageTitle: "ANNOUNCEMENT DETAIL");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => wepage));
  }

  // setNotificationOnDailyandTimelyBasis() {
  //   daysArray.forEach((element) {
  //     var time = (element == Day.sunday) ? Time(08, 55, 0) : Time(09, 45, 0);
  //     showDailyAtDayTime(time, element);
  //   });
  // }

  Future<void> showDailyAtDayTime(Time time, Day day) async {
    var notificationid = day.value;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID $notificationid',
      'CHANNEL_NAME $notificationid',
      "CHANNEL_DESCRIPTION $notificationid",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      notificationid,
      'Mass Live Stream Info',
      'Live Stream to start within 5 minutes!', //null
      day,
      time,
      platformChannelSpecifics,
      payload: 'Live Stream to start within 5 minutes!',
    );
  }

  Future displayNotification1() async {
    var androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('channel-id', 'fcm', 'androidcoding.in');
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentAlert: true, presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      "title",
      "body",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  checkNotificationExists(int notificationid) async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests.contains(notificationid);
  }

  cancelNotification(int notificationid) async {
    var value = await checkNotificationExists(notificationid);
    if (value) {
      await flutterLocalNotificationsPlugin.cancel(notificationid);
    }
  }

  scheduleWeeklyNotificationForRespectiveDays(
      int hour, int minutes, DateTime day, int notificationid) async {
    print("not reequired");
    var value = await checkNotificationExists(notificationid);
    if (value) {
      return;
    }
    print("Going to set");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var notificationid1 = day.day + hour + minutes;
    print("notificationid $notificationid");
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID $notificationid',
      'CHANNEL_NAME $notificationid',
      "CHANNEL_DESCRIPTION $notificationid",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics =
        IOSNotificationDetails(presentAlert: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationid,
        'Mass Live Stream Info',
        'Live Stream to start within 5 minutes!',
        _nextInstanceOfDay(hour, minutes, day),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  scheduleNotificationForCelebrityDay(
      DateTime dateTime, int notificationid, String eventName) async {
    print("notificationid $notificationid");
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID $notificationid',
      'CHANNEL_NAME $notificationid',
      "CHANNEL_DESCRIPTION $notificationid",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics =
        IOSNotificationDetails(presentAlert: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);

    var scheduletime = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    print("scheduletime $scheduletime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationid,
      '$eventName Info',
      '$eventName to start within 5 minutes!',
      scheduletime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfDay(int hour, int minutes, DateTime day) {
    tz.TZDateTime scheduledDate = _nextInstanceOfHour(hour, minutes);
    print("_nextInstanceOfDay*** $scheduledDate");
    print("scheduledDate.weekday ${scheduledDate.weekday}");
    print("day.weekday ${day.weekday}");
    while (scheduledDate.weekday != day.weekday + 1) {
      // print("inside---*** $scheduledDate");/
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfHour(int hour, int minutes) {
    var local = tz.local;
    print("Local $local");
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    scheduledDate = scheduledDate.subtract(new Duration(minutes: 5));
    // print("_nextInstanceOfHour*** $scheduledDate");
    if (scheduledDate.isBefore(now)) {
      // print("iside+++*** $scheduledDate");
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

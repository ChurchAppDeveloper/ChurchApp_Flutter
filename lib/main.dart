import 'dart:core';

import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/Screens/Announcement/AnnouncementList.dart';
import 'package:churchapp/Screens/Classifields/ClassifiedCreate.dart';
import 'package:churchapp/Screens/Classifields/ClassifiedList.dart';
import 'package:churchapp/Screens/Confession/Confession.dart';
import 'package:churchapp/Screens/ContactUS/Contactus.dart';
import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
import 'package:churchapp/Screens/Landing.dart';
import 'package:churchapp/Screens/LiveStream/LiveStream.dart';
import 'package:churchapp/Screens/LoginPage/otp_screen.dart';
import 'package:churchapp/Screens/MassTiming/MassTiming.dart';
import 'package:churchapp/Screens/PrayerRequest/PrayerRequest.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Screens/LoginPage/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.


  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      defaultTransition: Transition.rightToLeftWithFade,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 219, 69, 71),
      ),
      home: Landing(),
      getPages: [
        GetPage(name: '/', page: () => Landing()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/otp', page: () => OtpScreen()),
        GetPage(name: '/home', page: () => Dashboard()),
        GetPage(name: '/announcementList', page: () => AnnouncementList()),
        GetPage(name: '/announcementCreate', page: () => AnnouncementCreation()),
        GetPage(name: '/contact', page: () => ContactUS()),
        GetPage(name: '/liveStream', page: () => LiveStream()),
        GetPage(name: '/prayerRequest', page: () => PrayerRequest()),
        GetPage(name: '/classifiedList', page: () => ClassifiedList()),
        GetPage(name: '/classifiedCreate', page: () => ClassifiedCreate()),
        GetPage(name: '/mass', page: () => MassTiming()),
        GetPage(name: '/confession', page: () => Confession()),
      ],
    );
  }
}

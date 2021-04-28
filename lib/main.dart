import 'dart:core';

import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
import 'package:churchapp/Screens/Landing.dart';
import 'package:churchapp/Screens/LoginPage/otp_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Screens/LoginPage/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isAmplifyConfigured = false;

  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  initState() {
    super.initState();
    // final pushNotificationService = PushNotificationService(_firebaseMessaging);
    // pushNotificationService.notificationPluginInitilization(); //Test
    // MassTimingService().updateWeelyMassTiming1(); //Test
    // pushNotificationService.initialise();
    // pushNotificationService.context = context;

    // configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barnabas',
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
      ],
    );
  }
}
